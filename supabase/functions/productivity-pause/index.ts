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
    const taskId = payload?.task_id;
    const reason = payload?.reason || null;
    if (!taskId) return new Response(JSON.stringify({ error: 'task_id required' }), { status: 400, headers: corsHeaders });

    const { data: task } = await supabase.from('productivity_tasks').select('*').eq('id', taskId).single();
    if (!task) return new Response(JSON.stringify({ error: 'Task not found' }), { status: 404, headers: corsHeaders });

    const now = new Date().toISOString();
    let remaining_seconds = 0;
    if (task.expected_end_at) {
      remaining_seconds = Math.max(0, Math.floor((new Date(task.expected_end_at).getTime() - Date.now()) / 1000));
    }

    // insert event to record pause (using 'resumed' event_type with metadata to avoid enum mismatch)
    await supabase.from('productivity_task_events').insert({
      task_id: taskId,
      session_id: task.session_id,
      event_type: 'resumed',
      metadata: { paused: true, reason, remaining_seconds },
      created_at: now,
    });

    // set task status to not_started to indicate paused (schema has no paused state)
    await supabase.from('productivity_tasks').update({ status: 'not_started' }).eq('id', taskId);

    return new Response(JSON.stringify({ remaining_seconds }), { status: 200, headers: corsHeaders });
  } catch (err) {
    console.error('productivity-pause error', err);
    return new Response(JSON.stringify({ error: 'Internal server error' }), { status: 500, headers: corsHeaders });
  }
});

