// @ts-nocheck
// Sync SimpleFIN data into existing hb_* financial tables.
//
// Local secret setup:
//   supabase secrets set SIMPLEFIN_ACCESS_URL="your_access_url_here"
//
// Do not put SIMPLEFIN_ACCESS_URL in a Vite .env file.
// Do not use VITE_SIMPLEFIN_ACCESS_URL.
// The browser must never receive the SimpleFIN access URL.

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { tokenFromRequest, verifyToken } from "../_shared/auth.ts";
import { applyCategorizationRules } from "../_shared/categorize.ts";

const DEFAULT_FRONTEND = Deno.env.get("FRONTEND_ORIGIN") || "http://localhost:5173";
const DEFAULT_LOOKBACK_DAYS = 90;

function buildCorsHeaders(origin: string) {
  return {
    "Access-Control-Allow-Origin": origin,
    "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
    "Access-Control-Allow-Credentials": "true",
  };
}

function jsonResponse(body: Record<string, unknown>, status = 200, headers: Record<string, string> = {}) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json", ...headers },
  });
}

function parseNumber(value: unknown) {
  if (value === null || typeof value === "undefined" || value === "") return null;
  const parsed = Number(value);
  return Number.isFinite(parsed) ? parsed : null;
}

function truncate(value: string | null | undefined, max: number) {
  if (!value) return "";
  return value.length > max ? value.slice(0, max) : value;
}

function dateFromSimpleFinPosted(value: unknown) {
  if (typeof value === "number") return new Date(value * 1000).toISOString().slice(0, 10);
  if (typeof value === "string" && /^\d+$/.test(value)) return new Date(Number(value) * 1000).toISOString().slice(0, 10);
  if (typeof value === "string" && value.length >= 10) return value.slice(0, 10);
  return null;
}

function institutionName(account: Record<string, unknown>) {
  const org = (account.org || {}) as Record<string, unknown>;
  const orgId = org.domain || org.id || org.name || account.org_id || account.conn_name || "unknown";
  return String(account.conn_name || org.name || orgId || "Unknown Institution");
}

function categoryLabel(transaction: Record<string, unknown>) {
  const extra = (transaction.extra || {}) as Record<string, unknown>;
  if (Array.isArray(transaction.categories)) return transaction.categories.join(" / ");
  if (transaction.category) return String(transaction.category);
  if (extra.category) return String(extra.category);
  return null;
}

/** Build /accounts URL and Basic Auth header from a SimpleFIN Access URL. */
function buildAccountsRequest(accessUrl: string, lookbackDays = DEFAULT_LOOKBACK_DAYS) {
  const parsed = new URL(accessUrl.trim());
  const username = decodeURIComponent(parsed.username || "");
  const password = decodeURIComponent(parsed.password || "");
  parsed.username = "";
  parsed.password = "";

  const base = parsed.toString().replace(/\/+$/, "");
  const accountsBase = base.endsWith("/accounts") ? base : `${base}/accounts`;
  const startDate = Math.floor(Date.now() / 1000) - lookbackDays * 24 * 60 * 60;
  const url = new URL(accountsBase);
  url.searchParams.set("start-date", String(startDate));
  url.searchParams.set("pending", "1");

  const headers: Record<string, string> = { Accept: "application/json" };
  if (username || password) {
    headers.Authorization = `Basic ${btoa(`${username}:${password}`)}`;
  }

  return { url: url.toString(), headers };
}

function normalizeBankAccount(account: Record<string, unknown>, userId: string, bankName: string) {
  const balance = parseNumber(account.balance);
  const availableBalance = parseNumber(account["available-balance"] || account.available_balance);

  return {
    user_id: userId,
    name: truncate(String(account.name || account["official-name"] || "Unnamed account"), 100),
    bank_name: truncate(bankName, 100),
    account_type: truncate(String(account.type || "other"), 50),
    simplefin_account_id: String(account.id),
    external_source: "simplefin",
    is_active: true,
    metadata: {
      balance,
      available_balance: availableBalance,
      balance_date: account["balance-date"] || account.balance_date || null,
      official_name: account["official-name"] || account.official_name || null,
      account_subtype: account.subtype || null,
      currency: account.currency || "USD",
      conn_id: account.conn_id || null,
      raw: account,
    },
  };
}

function normalizeSimpleFinAmount(rawAmount: number, description: string | null, payee: string | null) {
  const text = `${description || ""} ${payee || ""}`.toUpperCase();

  // Keep clear outflows as-is (even if the text contains words like CREDIT).
  const outflowHints = [
    /CREDIT\s*CARD/,
    /CRD\s*PURCHASE/,
    /DEBIT\s*CARD/,
    /BILL\s*PAY/,
    /PAYMENT\s+TO/,
    /AUTOPAY/,
    /WITHDRAWAL/,
    /ATM\s+WITHDRAW/,
    /\bPURCHASE\b/,
    /\bFEE\b/,
    /POS\s+DEBIT/,
  ];
  if (outflowHints.some((pattern) => pattern.test(text))) {
    return rawAmount;
  }

  // SimpleFIN Bridge sometimes sends deposits/credits as negatives.
  // Protocol: positive = money in. Flip known inflows when they arrive negative.
  const inflowHints = [
    /CHECK\s+RECEIVED/,
    /DIRECT\s+DEPOSIT/,
    /\bPAYROLL\b/,
    /ACH\s+CREDIT/,
    /MOBILE\s+DEPOSIT/,
    /ATM\s+CASH\s+DEPOSIT/,
    /CASH\s+DEPOSIT/,
    /\bDEPOSIT\b/,
    /INTEREST\s+(PAID|CREDIT)/,
    /\bREFUND\b/,
    /ZELLE\s+(FROM|PAYMENT\s+FROM)/,
    /VENMO\s+CASH/,
    /TRANSFER\s+FROM/,
    /REMOTE\s+ONLINE\s+DEPOSIT/,
  ];

  if (rawAmount < 0 && inflowHints.some((pattern) => pattern.test(text))) {
    return Math.abs(rawAmount);
  }

  return rawAmount;
}

function normalizeTransaction(
  transaction: Record<string, unknown>,
  simplefinAccountId: string,
  userId: string,
  bankName: string,
  currency: string
) {
  const rawId = transaction.id
    ? String(transaction.id)
    : stableFallbackTransactionId(transaction, simplefinAccountId);
  const postedDate = dateFromSimpleFinPosted(transaction.posted);
  const payee = transaction.payee ? String(transaction.payee) : null;
  const description = transaction.description ? String(transaction.description) : null;
  const category = categoryLabel(transaction);
  const parsedAmount = parseNumber(transaction.amount) ?? 0;
  const amount = normalizeSimpleFinAmount(parsedAmount, description, payee);

  return {
    user_id: userId,
    account_id: simplefinAccountId,
    transaction_id: rawId,
    amount,
    date: postedDate || new Date().toISOString().slice(0, 10),
    name: truncate(description || payee || "Transaction", 255),
    merchant_name: payee,
    description,
    pending: Boolean(transaction.pending),
    is_reconciled: false,
    import_method: "simplefin",
    bank_source: truncate(bankName, 100),
    iso_currency_code: currency || "USD",
    source_metadata: {
      category,
      raw_simplefin_transaction_id: rawId,
      raw_amount: parsedAmount,
      normalized_amount: amount,
      raw: transaction,
    },
  };
}

function summarizeErrors(body: Record<string, unknown>) {
  const errlist = Array.isArray(body.errlist) ? body.errlist : [];
  const legacyErrors = Array.isArray(body.errors) ? body.errors : [];

  const messages = [
    ...errlist.map((item) => {
      if (!item || typeof item !== "object") return String(item);
      const err = item as Record<string, unknown>;
      return String(err.msg || err.code || "SimpleFIN connection error");
    }),
    ...legacyErrors.map((item) => String(item)),
  ].filter(Boolean);

  return [...new Set(messages)];
}

function errorMessageFromUnknown(err: unknown) {
  if (err instanceof Error && err.message) return err.message;
  if (typeof err === "string" && err.trim()) return err;
  if (err && typeof err === "object") {
    const record = err as Record<string, unknown>;
    const parts = [record.message, record.code, record.details, record.hint]
      .filter((part) => typeof part === "string" && part.trim())
      .map(String);
    if (parts.length) return parts.join(" | ");
  }
  try {
    return JSON.stringify(err);
  } catch {
    return "SimpleFIN sync failed";
  }
}

function stableFallbackTransactionId(transaction: Record<string, unknown>, accountId: string) {
  const posted = String(transaction.posted ?? "");
  const amount = String(transaction.amount ?? "");
  const description = String(transaction.description ?? transaction.payee ?? "");
  const seed = `${accountId}|${posted}|${amount}|${description}`;
  let hash = 0;
  for (let i = 0; i < seed.length; i += 1) {
    hash = (hash * 31 + seed.charCodeAt(i)) >>> 0;
  }
  return `sf-fallback-${hash.toString(16)}`;
}

async function upsertBankAccount(supabase: ReturnType<typeof createClient>, accountPayload: Record<string, unknown>) {
  const userId = String(accountPayload.user_id);
  const simplefinAccountId = String(accountPayload.simplefin_account_id);

  const { data: existing, error: lookupError } = await supabase
    .from("hb_bank_accounts")
    .select("id, simplefin_account_id")
    .eq("user_id", userId)
    .eq("simplefin_account_id", simplefinAccountId)
    .maybeSingle();

  if (lookupError) throw lookupError;

  if (existing) {
    const { data, error } = await supabase
      .from("hb_bank_accounts")
      .update(accountPayload)
      .eq("id", existing.id)
      .select("simplefin_account_id")
      .single();
    if (error) throw error;
    return data;
  }

  const { data, error } = await supabase
    .from("hb_bank_accounts")
    .insert(accountPayload)
    .select("simplefin_account_id")
    .single();
  if (error) throw error;
  return data;
}

async function upsertTransactions(supabase: ReturnType<typeof createClient>, transactionPayload: Record<string, unknown>[]) {
  if (!transactionPayload.length) return 0;

  const { error } = await supabase
    .from("hb_transactions")
    .upsert(transactionPayload, { onConflict: "user_id,transaction_id,account_id" });

  if (!error) return transactionPayload.length;

  // Batch failed (often a secondary unique index). Fall back to per-row upsert and skip true duplicates.
  let processed = 0;
  for (const row of transactionPayload) {
    const { error: rowError } = await supabase
      .from("hb_transactions")
      .upsert(row, { onConflict: "user_id,transaction_id,account_id" });

    if (!rowError) {
      processed += 1;
      continue;
    }

    const code = String((rowError as { code?: string }).code || "");
    const message = errorMessageFromUnknown(rowError).toLowerCase();
    const isDuplicate = code === "23505" || message.includes("duplicate key") || message.includes("unique");
    if (isDuplicate) {
      // Already present under another unique key; treat as successfully synced.
      processed += 1;
      continue;
    }

    throw rowError;
  }

  return processed;
}

async function getAppUserId(req: Request) {
  const token = await tokenFromRequest(req);
  const verified = await verifyToken(token);
  if (!verified.valid) return { userId: null, error: "Unauthorized" };

  const userId = String(verified.payload?.sub || "");
  if (!userId) return { userId: null, error: "Unauthorized" };

  return { userId, error: null };
}

serve(async (req) => {
  const origin = req.headers.get("origin") || DEFAULT_FRONTEND;
  const corsHeaders = buildCorsHeaders(origin);

  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  if (req.method !== "POST") {
    return jsonResponse({ success: false, accountsProcessed: 0, transactionsProcessed: 0, error: "Method Not Allowed" }, 405, corsHeaders);
  }

  const supabaseUrl = Deno.env.get("PROJECT_URL") || Deno.env.get("SUPABASE_URL");
  const serviceKey = Deno.env.get("SERVICE_ROLE_KEY") || Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  const simplefinAccessUrl = Deno.env.get("SIMPLEFIN_ACCESS_URL");

  if (!supabaseUrl || !serviceKey || !simplefinAccessUrl) {
    return jsonResponse({ success: false, accountsProcessed: 0, transactionsProcessed: 0, error: "Server configuration error" }, 500, corsHeaders);
  }

  const { userId, error: authError } = await getAppUserId(req);
  if (authError || !userId) {
    return jsonResponse({ success: false, accountsProcessed: 0, transactionsProcessed: 0, error: "Unauthorized" }, 401, corsHeaders);
  }

  const supabase = createClient(supabaseUrl, serviceKey, { auth: { persistSession: false } });
  let syncRunId: string | null = null;
  let accountsProcessed = 0;
  let transactionsProcessed = 0;

  try {
    const { data: syncRun, error: syncRunError } = await supabase
      .from("hb_sync_runs")
      .insert({
        user_id: userId,
        sync_type: "simplefin",
        status: "running",
        started_at: new Date().toISOString(),
        metadata: {},
      })
      .select("id")
      .single();

    if (syncRunError) throw syncRunError;
    syncRunId = syncRun.id;

    const { url, headers } = buildAccountsRequest(simplefinAccessUrl);
    const response = await fetch(url, {
      method: "GET",
      headers,
      redirect: "follow",
    });

    if (!response.ok) {
      throw new Error(`SimpleFIN request failed with status ${response.status}`);
    }

    const body = await response.json();
    const accounts = Array.isArray(body.accounts) ? body.accounts : [];
    const providerErrors = summarizeErrors(body);

    for (const account of accounts) {
      const bankName = institutionName(account);
      const accountPayload = normalizeBankAccount(account, userId, bankName);
      const upsertedAccount = await upsertBankAccount(supabase, accountPayload);
      accountsProcessed += 1;

      const currency = String(account.currency || "USD");
      const transactions = Array.isArray(account.transactions) ? account.transactions : [];

      if (transactions.length) {
        const transactionPayload = transactions.map((transaction) =>
          normalizeTransaction(transaction, upsertedAccount.simplefin_account_id, userId, bankName, currency)
        );

        transactionsProcessed += await upsertTransactions(supabase, transactionPayload);
      }
    }

    let categorized = { examined: 0, updated: 0, skipped: 0 };
    try {
      categorized = await applyCategorizationRules(supabase, userId);
    } catch (categorizeErr) {
      console.error("post-sync categorization failed:", errorMessageFromUnknown(categorizeErr));
    }

    await supabase
      .from("hb_sync_runs")
      .update({
        status: providerErrors.length ? "partial" : "success",
        finished_at: new Date().toISOString(),
        records_processed: accountsProcessed + transactionsProcessed,
        error_message: providerErrors.length ? providerErrors.join("; ") : null,
        metadata: {
          accounts_processed: accountsProcessed,
          transactions_processed: transactionsProcessed,
          provider_errors: providerErrors,
          categorized,
        },
      })
      .eq("id", syncRunId);

    return jsonResponse(
      {
        success: true,
        accountsProcessed,
        transactionsProcessed,
        categorized,
        warnings: providerErrors,
      },
      200,
      corsHeaders
    );
  } catch (err) {
    const message = errorMessageFromUnknown(err);

    if (syncRunId) {
      await supabase
        .from("hb_sync_runs")
        .update({
          status: "failed",
          finished_at: new Date().toISOString(),
          error_message: message,
        })
        .eq("id", syncRunId);
    }

    console.error("sync-simplefin error:", message, err);
    return jsonResponse({ success: false, accountsProcessed, transactionsProcessed, error: message }, 500, corsHeaders);
  }
});
