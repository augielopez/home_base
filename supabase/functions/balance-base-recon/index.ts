// @ts-nocheck
// Bills Recon: month unmatched/matched queues + manual/auto match writes.
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { tokenFromRequest, verifyToken } from "../_shared/auth.ts";
import {
  bestSuggestionForTransaction,
  buildHistoryHints,
  HIGH_CONFIDENCE,
  isExcludedSentinelBill,
} from "../_shared/billMatchSuggest.ts";

const DEFAULT_FRONTEND = Deno.env.get("FRONTEND_ORIGIN") || "http://localhost:5173";

function buildCorsHeaders(origin: string) {
  return {
    "Access-Control-Allow-Origin": origin,
    "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
    "Access-Control-Allow-Methods": "GET, POST, PATCH, OPTIONS",
    "Access-Control-Allow-Credentials": "true",
  };
}

function jsonResponse(body: Record<string, unknown>, status = 200, headers: Record<string, string> = {}) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json", ...headers },
  });
}

function errorMessageFromUnknown(err: unknown) {
  if (err instanceof Error && err.message) return err.message;
  if (typeof err === "string" && err.trim()) return err;
  if (err && typeof err === "object" && "message" in err) return String((err as { message?: unknown }).message);
  return "Bills recon request failed";
}

async function requireUser(req: Request) {
  const token = await tokenFromRequest(req);
  const verified = await verifyToken(token);
  if (!verified.valid) return { userId: null, error: "Unauthorized" };
  const userId = String(verified.payload.sub || "");
  if (!userId) return { userId: null, error: "Unauthorized" };
  return { userId, error: null };
}

function monthBounds(year: number, month: number) {
  const start = `${year}-${String(month).padStart(2, "0")}-01`;
  const endDate = new Date(Date.UTC(year, month, 0));
  const end = endDate.toISOString().slice(0, 10);
  return { start, end };
}

function parseYearMonth(url: URL, body: Record<string, unknown> = {}) {
  const now = new Date();
  const year = Number(body.year || url.searchParams.get("year") || now.getFullYear());
  const month = Number(body.month || url.searchParams.get("month") || now.getMonth() + 1);
  if (!Number.isFinite(year) || !Number.isFinite(month) || month < 1 || month > 12) {
    return { error: "Valid year and month are required" };
  }
  return { year, month, error: null };
}

function mapTx(row: Record<string, unknown>, suggestion: Record<string, unknown> | null = null) {
  const bill = row.bill && typeof row.bill === "object" ? (row.bill as Record<string, unknown>) : null;
  return {
    id: row.id,
    date: row.date,
    amount: Number(row.amount || 0),
    description: row.description || row.name || null,
    payee: row.merchant_name || null,
    bill_id: row.bill_id || null,
    bill_name: bill?.bill_name || null,
    match_method: row.match_method || null,
    match_confidence: row.match_confidence == null ? null : Number(row.match_confidence),
    recon_excluded: Boolean(row.recon_excluded),
    suggestion,
  };
}

serve(async (req) => {
  const origin = req.headers.get("origin") || DEFAULT_FRONTEND;
  const corsHeaders = buildCorsHeaders(origin);

  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  const supabaseUrl = Deno.env.get("PROJECT_URL") || Deno.env.get("SUPABASE_URL");
  const serviceKey = Deno.env.get("SERVICE_ROLE_KEY") || Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  if (!supabaseUrl || !serviceKey) {
    return jsonResponse({ success: false, error: "Server misconfigured" }, 500, corsHeaders);
  }

  const { userId, error: authError } = await requireUser(req);
  if (authError || !userId) {
    return jsonResponse({ success: false, error: "Unauthorized" }, 401, corsHeaders);
  }

  const supabase = createClient(supabaseUrl, serviceKey, { auth: { persistSession: false } });
  const url = new URL(req.url);

  try {
    if (req.method === "GET") {
      const parsed = parseYearMonth(url);
      if (parsed.error) return jsonResponse({ success: false, error: parsed.error }, 400, corsHeaders);

      const { start, end } = monthBounds(parsed.year, parsed.month);

      const [{ data: bills, error: billsError }, { data: historyRows, error: historyError }, { data: transactions, error: txError }] =
        await Promise.all([
          supabase
            .from("hb_bills")
            .select("id, bill_name, amount_due, due_date, status, description, frequency_id, last_paid, is_fixed_bill, is_included_in_monthly_payment, created_at, updated_at, created_by, updated_by, frequency:hb_frequency_types(id, name)")
            .eq("status", "Active")
            .order("bill_name", { ascending: true }),
          supabase
            .from("hb_transactions")
            .select("bill_id, name, description, merchant_name")
            .eq("user_id", userId)
            .not("bill_id", "is", null)
            .order("date", { ascending: false })
            .limit(500),
          supabase
            .from("hb_transactions")
            .select("id, date, amount, name, description, merchant_name, bill_id, match_method, match_confidence, recon_excluded, bill:hb_bills(id, bill_name)")
            .eq("user_id", userId)
            .eq("import_method", "simplefin")
            .gte("date", start)
            .lte("date", end)
            .order("date", { ascending: false })
            .limit(500),
        ]);

      if (billsError) throw billsError;
      if (historyError) throw historyError;
      if (txError) throw txError;

      const historyHints = buildHistoryHints(historyRows || []);
      const activeBills = (bills || []).filter((bill) => !isExcludedSentinelBill(bill));

      const unmatched = [];
      const matched = [];
      const excluded = [];

      for (const row of transactions || []) {
        if (row.recon_excluded || String(row.bill_id || "") === "00000000-0000-0000-0000-000000000001") {
          excluded.push(mapTx(row, null));
          continue;
        }
        if (row.bill_id) {
          matched.push(mapTx(row, null));
          continue;
        }
        const suggestion = bestSuggestionForTransaction(row, activeBills, historyHints);
        unmatched.push(mapTx(row, suggestion));
      }

      return jsonResponse(
        {
          success: true,
          year: parsed.year,
          month: parsed.month,
          highConfidence: HIGH_CONFIDENCE,
          bills: activeBills,
          unmatched,
          matched,
          excluded,
        },
        200,
        corsHeaders
      );
    }

    if (req.method === "POST" || req.method === "PATCH") {
      const body = await req.json().catch(() => ({}));
      const action = String(body.action || "").toLowerCase();
      const transactionId = String(body.transactionId || body.transaction_id || "");

      if (!transactionId && action !== "accept_high_confidence") {
        return jsonResponse({ success: false, error: "transactionId is required" }, 400, corsHeaders);
      }

      if (action === "match") {
        const billId = String(body.billId || body.bill_id || "");
        if (!billId) return jsonResponse({ success: false, error: "billId is required" }, 400, corsHeaders);

        const method = String(body.matchMethod || body.match_method || "manual").toLowerCase();
        const confidenceRaw = Number(body.confidence);
        const confidence = Number.isFinite(confidenceRaw)
          ? Math.max(0, Math.min(100, Math.round(confidenceRaw)))
          : method === "manual"
            ? 100
            : HIGH_CONFIDENCE;

        const { data, error } = await supabase
          .from("hb_transactions")
          .update({
            bill_id: billId,
            is_reconciled: true,
            recon_excluded: false,
            match_method: method === "auto" || method === "ai" ? method : "manual",
            match_confidence: confidence,
            match_timestamp: new Date().toISOString(),
          })
          .eq("id", transactionId)
          .eq("user_id", userId)
          .select("id, bill_id, match_method, match_confidence")
          .maybeSingle();

        if (error) throw error;
        if (!data) return jsonResponse({ success: false, error: "Transaction not found" }, 404, corsHeaders);
        return jsonResponse({ success: true, transaction: data }, 200, corsHeaders);
      }

      if (action === "unmatch") {
        const { data, error } = await supabase
          .from("hb_transactions")
          .update({
            bill_id: null,
            is_reconciled: false,
            recon_excluded: false,
            match_method: "unmatched",
            match_confidence: 0,
            match_timestamp: null,
          })
          .eq("id", transactionId)
          .eq("user_id", userId)
          .select("id")
          .maybeSingle();

        if (error) throw error;
        if (!data) return jsonResponse({ success: false, error: "Transaction not found" }, 404, corsHeaders);
        return jsonResponse({ success: true, transactionId }, 200, corsHeaders);
      }

      if (action === "exclude") {
        const { data, error } = await supabase
          .from("hb_transactions")
          .update({
            bill_id: null,
            is_reconciled: false,
            recon_excluded: true,
            match_method: "unmatched",
            match_confidence: 0,
            match_timestamp: null,
          })
          .eq("id", transactionId)
          .eq("user_id", userId)
          .select("id")
          .maybeSingle();

        if (error) throw error;
        if (!data) return jsonResponse({ success: false, error: "Transaction not found" }, 404, corsHeaders);
        return jsonResponse({ success: true, transactionId }, 200, corsHeaders);
      }

      if (action === "include") {
        const { data, error } = await supabase
          .from("hb_transactions")
          .update({ recon_excluded: false })
          .eq("id", transactionId)
          .eq("user_id", userId)
          .select("id")
          .maybeSingle();

        if (error) throw error;
        if (!data) return jsonResponse({ success: false, error: "Transaction not found" }, 404, corsHeaders);
        return jsonResponse({ success: true, transactionId }, 200, corsHeaders);
      }

      if (action === "accept_high_confidence") {
        const parsed = parseYearMonth(url, body);
        if (parsed.error) return jsonResponse({ success: false, error: parsed.error }, 400, corsHeaders);
        const { start, end } = monthBounds(parsed.year, parsed.month);
        const minConfidence = Number(body.minConfidence) > 0 ? Number(body.minConfidence) : HIGH_CONFIDENCE;

        const [{ data: bills, error: billsError }, { data: historyRows, error: historyError }, { data: transactions, error: txError }] =
          await Promise.all([
            supabase.from("hb_bills").select("id, bill_name, amount_due, due_date, status").eq("status", "Active"),
            supabase
              .from("hb_transactions")
              .select("bill_id, name, description, merchant_name")
              .eq("user_id", userId)
              .not("bill_id", "is", null)
              .limit(500),
            supabase
              .from("hb_transactions")
              .select("id, date, amount, name, description, merchant_name, bill_id, recon_excluded")
              .eq("user_id", userId)
              .eq("import_method", "simplefin")
              .is("bill_id", null)
              .eq("recon_excluded", false)
              .gte("date", start)
              .lte("date", end)
              .limit(500),
          ]);

        if (billsError) throw billsError;
        if (historyError) throw historyError;
        if (txError) throw txError;

        const historyHints = buildHistoryHints(historyRows || []);
        const activeBills = (bills || []).filter((bill) => !isExcludedSentinelBill(bill));
        let updated = 0;
        let examined = 0;

        for (const row of transactions || []) {
          examined += 1;
          const suggestion = bestSuggestionForTransaction(row, activeBills, historyHints);
          if (!suggestion || suggestion.confidence < minConfidence) continue;

          const { error: updateError } = await supabase
            .from("hb_transactions")
            .update({
              bill_id: suggestion.bill_id,
              is_reconciled: true,
              recon_excluded: false,
              match_method: "auto",
              match_confidence: suggestion.confidence,
              match_timestamp: new Date().toISOString(),
            })
            .eq("id", row.id)
            .eq("user_id", userId)
            .is("bill_id", null);

          if (updateError) throw updateError;
          updated += 1;
        }

        return jsonResponse({ success: true, examined, updated, minConfidence }, 200, corsHeaders);
      }

      return jsonResponse({ success: false, error: `Unsupported action: ${action}` }, 400, corsHeaders);
    }

    return jsonResponse({ success: false, error: "Method Not Allowed" }, 405, corsHeaders);
  } catch (err) {
    const message = errorMessageFromUnknown(err);
    console.error("balance-base-recon error:", message, err);
    return jsonResponse({ success: false, error: message }, 500, corsHeaders);
  }
});
