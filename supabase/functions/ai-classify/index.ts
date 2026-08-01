// @ts-nocheck
// Generic AI classify entrypoint.
// domain=transactions now; bills-recon can reuse the same route later.
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { tokenFromRequest, verifyToken } from "../_shared/auth.ts";
import { applyAiTransactionCategorization } from "../_shared/aiCategorizeTransactions.ts";

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
  return "AI classification failed";
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

  const body = await req.json().catch(() => ({}));
  const domain = String(body.domain || "transactions");
  const limit = Number(body.limit) > 0 ? Number(body.limit) : 60;
  const minConfidence = Number(body.minConfidence) > 0 ? Number(body.minConfidence) : undefined;

  const supabase = createClient(supabaseUrl, serviceKey, { auth: { persistSession: false } });

  try {
    if (domain === "transactions") {
      const result = await applyAiTransactionCategorization(supabase, userId, { limit, minConfidence });
      return jsonResponse({ success: true, domain, ...result }, 200, corsHeaders);
    }

    if (domain === "bills-recon") {
      return jsonResponse(
        {
          success: false,
          domain,
          error: "bills-recon AI classification is not implemented yet. Reuse _shared/aiClassify.ts when Bills Recon is built.",
        },
        501,
        corsHeaders
      );
    }

    return jsonResponse({ success: false, error: `Unsupported domain: ${domain}` }, 400, corsHeaders);
  } catch (err) {
    const message = errorMessageFromUnknown(err);
    console.error("ai-classify error:", message, err);
    return jsonResponse({ success: false, error: message }, 500, corsHeaders);
  }
});
