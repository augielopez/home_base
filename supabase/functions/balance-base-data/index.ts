// @ts-nocheck
// Authenticated Balance Base reads/updates for the existing home_base hb_token session.
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { tokenFromRequest, verifyToken } from "../_shared/auth.ts";

const DEFAULT_FRONTEND = Deno.env.get("FRONTEND_ORIGIN") || "http://localhost:5173";

function buildCorsHeaders(origin: string) {
  return {
    "Access-Control-Allow-Origin": origin,
    "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
    "Access-Control-Allow-Methods": "GET, PATCH, POST, OPTIONS",
    "Access-Control-Allow-Credentials": "true",
  };
}

function jsonResponse(body: Record<string, unknown>, status = 200, headers: Record<string, string> = {}) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json", ...headers },
  });
}

async function requireUser(req: Request) {
  const token = await tokenFromRequest(req);
  const verified = await verifyToken(token);
  if (!verified.valid) return { userId: null, error: "Unauthorized" };

  const userId = String(verified.payload.sub || "");
  if (!userId) return { userId: null, error: "Unauthorized" };
  return { userId, error: null };
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
    return jsonResponse({ error: "Server misconfigured" }, 500, corsHeaders);
  }

  const { userId, error: authError } = await requireUser(req);
  if (authError || !userId) {
    return jsonResponse({ error: "Unauthorized" }, 401, corsHeaders);
  }

  const supabase = createClient(supabaseUrl, serviceKey, { auth: { persistSession: false } });

  try {
    if (req.method === "PATCH") {
      const body = await req.json().catch(() => ({}));
      const transactionId = String(body.transactionId || body.transaction_id || "");
      const categoryId = body.categoryId === null || body.categoryId === "" || typeof body.categoryId === "undefined"
        ? null
        : String(body.categoryId || body.category_id || "");

      if (!transactionId) {
        return jsonResponse({ error: "transactionId is required" }, 400, corsHeaders);
      }

      if (categoryId) {
        const { data: category, error: categoryError } = await supabase
          .from("hb_transaction_categories")
          .select("id, name")
          .eq("id", categoryId)
          .eq("is_active", true)
          .maybeSingle();

        if (categoryError) throw categoryError;
        if (!category) {
          return jsonResponse({ error: "Category not found" }, 400, corsHeaders);
        }
      }

      const { data, error } = await supabase
        .from("hb_transactions")
        .update({
          category_id: categoryId,
          category_match_method: categoryId ? "manual" : "unmatched",
          category_confidence: categoryId ? 1.0 : 0.0,
        })
        .eq("id", transactionId)
        .eq("user_id", userId)
        .select("*, category:hb_transaction_categories(id, name)")
        .maybeSingle();

      if (error) throw error;
      if (!data) {
        return jsonResponse({ error: "Transaction not found" }, 404, corsHeaders);
      }

      return jsonResponse({ success: true, transaction: data }, 200, corsHeaders);
    }

    if (req.method !== "GET") {
      return jsonResponse({ error: "Method Not Allowed" }, 405, corsHeaders);
    }

    const url = new URL(req.url);
    const includeRaw = (url.searchParams.get("include") || "accounts,transactions,syncRuns,categories").toLowerCase();
    const include = new Set(includeRaw.split(",").map((part) => part.trim()).filter(Boolean));

    const result: Record<string, unknown> = { success: true };

    if (include.has("categories")) {
      const { data, error } = await supabase
        .from("hb_transaction_categories")
        .select("id, name, description, color, icon, is_active")
        .eq("is_active", true)
        .order("name", { ascending: true });

      if (error) throw error;
      result.categories = data || [];
    }

    if (include.has("accounts")) {
      const { data, error } = await supabase
        .from("hb_bank_accounts")
        .select("*")
        .eq("user_id", userId)
        .eq("is_active", true)
        .order("name", { ascending: true });

      if (error) throw error;
      result.accounts = data || [];
    }

    if (include.has("transactions")) {
      let query = supabase
        .from("hb_transactions")
        .select("*, category:hb_transaction_categories(id, name)")
        .eq("user_id", userId)
        .eq("import_method", "simplefin")
        .order("date", { ascending: false })
        .limit(250);

      const search = url.searchParams.get("search")?.trim();
      if (search) {
        const value = search.replaceAll(",", " ");
        query = query.or(`description.ilike.%${value}%,merchant_name.ilike.%${value}%,name.ilike.%${value}%`);
      }

      const accountId = url.searchParams.get("accountId");
      if (accountId) query = query.eq("account_id", accountId);

      const categoryId = url.searchParams.get("categoryId");
      if (categoryId === "uncategorized") {
        query = query.is("category_id", null);
      } else if (categoryId) {
        query = query.eq("category_id", categoryId);
      }

      const startDate = url.searchParams.get("startDate");
      if (startDate) query = query.gte("date", startDate);

      const endDate = url.searchParams.get("endDate");
      if (endDate) query = query.lte("date", endDate);

      const { data, error } = await query;
      if (error) throw error;
      result.transactions = data || [];
    }

    if (include.has("syncruns")) {
      const { data, error } = await supabase
        .from("hb_sync_runs")
        .select("*")
        .eq("user_id", userId)
        .order("started_at", { ascending: false })
        .limit(10);

      if (error) throw error;
      result.syncRuns = data || [];
    }

    return jsonResponse(result, 200, corsHeaders);
  } catch (err) {
    console.error("balance-base-data error:", err);
    return jsonResponse({ error: "Failed to load Balance Base data" }, 500, corsHeaders);
  }
});
