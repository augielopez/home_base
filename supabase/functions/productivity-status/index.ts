// @ts-nocheck
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const DEFAULT_FRONTEND = Deno.env.get("FRONTEND_ORIGIN") || "http://localhost:5173";
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
  if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders });
  if (req.method !== "POST") return new Response("Method Not Allowed", { status: 405, headers: corsHeaders });
  try {
    const supabaseUrl = Deno.env.get("PROJECT_URL");
    const serviceKey = Deno.env.get("SERVICE_ROLE_KEY");
    if (!supabaseUrl || !serviceKey) {
      console.error("Missing Supabase environment configuration");
      return new Response(JSON.stringify({ error: "Server configuration error" }), { status: 500, headers: corsHeaders });
    }
    const supabase = createClient(supabaseUrl, serviceKey, { auth: { persistSession: false } });
    const payload = await req.json();
    const sessionId = payload?.session_id || null;

    let session = null;
    if (sessionId) {
      const { data } = await supabase.from('productivity_day_sessions').select('*').eq('id', sessionId).single();
      session = data;
    } else {
      const { data } = await supabase.from('productivity_day_sessions').select('*').eq('status', 'active').limit(1).single();
      session = data;
    }
    if (!session) return new Response(JSON.stringify({ session: null, task: null }), { status: 200, headers: corsHeaders });
    const task = session.active_task_id ? (await supabase.from('productivity_tasks').select('*').eq('id', session.active_task_id).single()).data : null;
    return new Response(JSON.stringify({ session, task }), { status: 200, headers: corsHeaders });
  } catch (err) {
    console.error('productivity-status error', err);
    return new Response(JSON.stringify({ error: 'Internal server error' }), { status: 500, headers: corsHeaders });
  }
});

