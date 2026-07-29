// @ts-nocheck
// Apply deterministic hb_categorization_rules to SimpleFIN transactions.
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { tokenFromRequest, verifyToken } from "../_shared/auth.ts";
import { applyCategorizationRules } from "../_shared/categorize.ts";

const DEFAULT_FRONTEND = Deno.env.get("FRONTEND_ORIGIN") || "http://localhost:5173";

function buildCorsHeaders(origin: string) {
  return {
    "Access-Control-Allow-Origin": origin,
    "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
    "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
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
  return "Categorization failed";
}

serve(async (req) => {
  const origin = req.headers.get("origin") || DEFAULT_FRONTEND;
  const corsHeaders = buildCorsHeaders(origin);

  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  if (req.method !== "POST") {
    return jsonResponse({ success: false, error: "Method Not Allowed" }, 405, corsHeaders);
  }

  const supabaseUrl = Deno.env.get("PROJECT_URL") || Deno.env.get("SUPABASE_URL");
  const serviceKey = Deno.env.get("SERVICE_ROLE_KEY") || Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  if (!supabaseUrl || !serviceKey) {
    return jsonResponse({ success: false, error: "Server misconfigured" }, 500, corsHeaders);
  }

  const token = await tokenFromRequest(req);
  const verified = await verifyToken(token);
  if (!verified.valid) {
    return jsonResponse({ success: false, error: "Unauthorized" }, 401, corsHeaders);
  }

  const userId = String(verified.payload?.sub || "");
  if (!userId) {
    return jsonResponse({ success: false, error: "Unauthorized" }, 401, corsHeaders);
  }

  const supabase = createClient(supabaseUrl, serviceKey, { auth: { persistSession: false } });

  try {
    const result = await applyCategorizationRules(supabase, userId);
    return jsonResponse({ success: true, ...result }, 200, corsHeaders);
  } catch (err) {
    const message = errorMessageFromUnknown(err);
    console.error("categorize-transactions error:", message, err);
    return jsonResponse({ success: false, error: message }, 500, corsHeaders);
  }
});
