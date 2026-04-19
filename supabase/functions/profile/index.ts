// @ts-nocheck
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { tokenFromRequest, verifyToken } from "../_shared/auth.ts";

const DEFAULT_FRONTEND = Deno.env.get("FRONTEND_ORIGIN") || "http://localhost:4200";

function buildCorsHeaders(origin: string) {
  return {
    "Access-Control-Allow-Origin": origin,
    "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
    "Access-Control-Allow-Credentials": "true",
  };
}

serve(async (req) => {
  const origin = req.headers.get("origin") || DEFAULT_FRONTEND;
  const corsHeaders = buildCorsHeaders(origin);

  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  if (req.method !== "GET") {
    return new Response("Method Not Allowed", { status: 405, headers: corsHeaders });
  }

  try {
    const token = await tokenFromRequest(req);
    const verified = await verifyToken(token);
    if (!verified.valid) {
      return new Response(JSON.stringify({ error: "Unauthorized" }), { status: 401, headers: corsHeaders });
    }

    const sub = String(verified.payload.sub || verified.payload.sub);
    const supabaseUrl = Deno.env.get("PROJECT_URL");
    const serviceKey = Deno.env.get("SERVICE_ROLE_KEY");
    if (!supabaseUrl || !serviceKey) {
      return new Response(JSON.stringify({ error: "Server misconfigured" }), { status: 500, headers: corsHeaders });
    }

    const supabase = createClient(supabaseUrl, serviceKey, { auth: { persistSession: false } });
    const { data, error } = await supabase.from("master_users").select("user_id,username,email,created_at,updated_at").eq("user_id", sub).limit(1);
    if (error) {
      return new Response(JSON.stringify({ error: "Failed to load profile" }), { status: 500, headers: corsHeaders });
    }

    const user = Array.isArray(data) && data.length ? data[0] : null;

    // Fetch aggregated permissions from the view (vw_user_permissions)
    const { data: permsData, error: permsError } = await supabase
      .from("vw_user_permissions")
      .select("modules_perms")
      .eq("user_id", sub)
      .limit(1)
      .single();

    const modules_perms = permsError || !permsData ? {} : (permsData.modules_perms || {});

    return new Response(JSON.stringify({ success: true, user, modules_perms }), { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } });
  } catch (err) {
    return new Response(JSON.stringify({ error: "Internal server error" }), { status: 500, headers: corsHeaders });
  }
});

