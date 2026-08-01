// @ts-nocheck
// Authenticated Bills CRUD for Balance Base (hb_token + service role).
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { tokenFromRequest, verifyToken } from "../_shared/auth.ts";

const DEFAULT_FRONTEND = Deno.env.get("FRONTEND_ORIGIN") || "http://localhost:5173";

function buildCorsHeaders(origin: string) {
  return {
    "Access-Control-Allow-Origin": origin,
    "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
    "Access-Control-Allow-Methods": "GET, POST, PATCH, DELETE, OPTIONS",
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
  return "Bills request failed";
}

async function requireUser(req: Request) {
  const token = await tokenFromRequest(req);
  const verified = await verifyToken(token);
  if (!verified.valid) return { userId: null, error: "Unauthorized" };

  const userId = String(verified.payload.sub || "");
  if (!userId) return { userId: null, error: "Unauthorized" };
  return { userId, error: null };
}

function parseBillPayload(body: Record<string, unknown>) {
  const billName = typeof body.bill_name === "string" ? body.bill_name.trim() : "";
  if (!billName) {
    return { error: "bill_name is required" };
  }

  const amountRaw = body.amount_due;
  let amountDue: number | null = null;
  if (amountRaw !== null && typeof amountRaw !== "undefined" && amountRaw !== "") {
    amountDue = Number(amountRaw);
    if (!Number.isFinite(amountDue)) {
      return { error: "amount_due must be a number" };
    }
  }

  return {
    error: null,
    payload: {
      bill_name: billName,
      amount_due: amountDue,
      due_date: body.due_date === null || body.due_date === "" ? null : String(body.due_date || "").trim() || null,
      status: body.status === null || body.status === "" ? "Active" : String(body.status),
      description: body.description === null || body.description === "" ? null : String(body.description || "").trim() || null,
      frequency_id: body.frequency_id === null || body.frequency_id === "" ? null : String(body.frequency_id),
      is_fixed_bill: Boolean(body.is_fixed_bill),
      is_included_in_monthly_payment: body.is_included_in_monthly_payment === false ? false : true,
      last_paid: body.last_paid === null || body.last_paid === "" ? null : String(body.last_paid),
    },
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
      const includeRaw = (url.searchParams.get("include") || "bills,frequencies").toLowerCase();
      const include = new Set(includeRaw.split(",").map((part) => part.trim()).filter(Boolean));
      const result: Record<string, unknown> = { success: true };

      if (include.has("frequencies")) {
        const { data, error } = await supabase
          .from("hb_frequency_types")
          .select("id, name, description")
          .order("name", { ascending: true });
        if (error) throw error;
        result.frequencies = data || [];
      }

      if (include.has("bills")) {
        const { data, error } = await supabase
          .from("hb_bills")
          .select("*, frequency:hb_frequency_types(id, name)")
          .order("bill_name", { ascending: true });
        if (error) throw error;
        result.bills = (data || []).filter((bill) => {
          const id = String(bill.id || "");
          const name = String(bill.bill_name || "").toLowerCase();
          return id !== "00000000-0000-0000-0000-000000000001" && !name.includes("excluded - not a bill");
        });
      }

      return jsonResponse(result, 200, corsHeaders);
    }

    if (req.method === "POST") {
      const body = await req.json().catch(() => ({}));
      const parsed = parseBillPayload(body);
      if (parsed.error || !parsed.payload) {
        return jsonResponse({ success: false, error: parsed.error }, 400, corsHeaders);
      }

      const now = new Date().toISOString();
      const { data, error } = await supabase
        .from("hb_bills")
        .insert({
          ...parsed.payload,
          created_by: userId,
          updated_by: userId,
          created_at: now,
          updated_at: now,
        })
        .select("*, frequency:hb_frequency_types(id, name)")
        .single();

      if (error) throw error;
      return jsonResponse({ success: true, bill: data }, 201, corsHeaders);
    }

    if (req.method === "PATCH") {
      const body = await req.json().catch(() => ({}));
      const billId = String(body.id || body.bill_id || url.searchParams.get("id") || "");
      if (!billId) {
        return jsonResponse({ success: false, error: "id is required" }, 400, corsHeaders);
      }

      const parsed = parseBillPayload(body);
      if (parsed.error || !parsed.payload) {
        return jsonResponse({ success: false, error: parsed.error }, 400, corsHeaders);
      }

      const { data, error } = await supabase
        .from("hb_bills")
        .update({
          ...parsed.payload,
          updated_by: userId,
          updated_at: new Date().toISOString(),
        })
        .eq("id", billId)
        .select("*, frequency:hb_frequency_types(id, name)")
        .maybeSingle();

      if (error) throw error;
      if (!data) {
        return jsonResponse({ success: false, error: "Bill not found" }, 404, corsHeaders);
      }

      return jsonResponse({ success: true, bill: data }, 200, corsHeaders);
    }

    if (req.method === "DELETE") {
      const billId = String(url.searchParams.get("id") || "");
      if (!billId) {
        return jsonResponse({ success: false, error: "id is required" }, 400, corsHeaders);
      }

      // Unlink any matched transactions before delete (FK to hb_bills).
      const { error: unlinkError } = await supabase
        .from("hb_transactions")
        .update({
          bill_id: null,
          is_reconciled: false,
          match_method: "unmatched",
          match_confidence: 0,
          match_timestamp: null,
        })
        .eq("bill_id", billId);

      if (unlinkError) throw unlinkError;

      const { data, error } = await supabase
        .from("hb_bills")
        .delete()
        .eq("id", billId)
        .select("id")
        .maybeSingle();

      if (error) throw error;
      if (!data) {
        return jsonResponse({ success: false, error: "Bill not found" }, 404, corsHeaders);
      }

      return jsonResponse({ success: true, deletedId: billId }, 200, corsHeaders);
    }

    return jsonResponse({ success: false, error: "Method Not Allowed" }, 405, corsHeaders);
  } catch (err) {
    const message = errorMessageFromUnknown(err);
    console.error("balance-base-bills error:", message, err);
    return jsonResponse({ success: false, error: message }, 500, corsHeaders);
  }
});
