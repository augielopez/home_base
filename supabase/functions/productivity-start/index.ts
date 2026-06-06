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
    let sessionId = payload?.session_id || null;
    const sessionDate = payload?.session_date || null;

    // create session if not provided
    if (!sessionId) {
      const insert = await supabase.from('productivity_day_sessions').insert([{ session_date: sessionDate || new Date().toISOString().split('T')[0] }]).select('*').single();
      if (insert.error) {
        console.error('session create error', insert.error);
        return new Response(JSON.stringify({ error: 'Failed to create session' }), { status: 500, headers: corsHeaders });
      }
      sessionId = insert.data.id;
    }

    const now = new Date().toISOString();

    // mark session active
    await supabase.from('productivity_day_sessions').update({ status: 'active', started_at: now }).eq('id', sessionId);

    // find first incomplete child task
    const { data: task } = await supabase
      .from('productivity_tasks')
      .select('*')
      .eq('session_id', sessionId)
      .eq('task_type', 'child')
      .neq('status', 'completed')
      .order('display_order', { ascending: true })
      .limit(1)
      .single();

    if (!task) {
      // mark session completed
      await supabase.from('productivity_day_sessions').update({ status: 'completed', ended_at: now }).eq('id', sessionId);
      return new Response(JSON.stringify({ session_id: sessionId, task: null }), { status: 200, headers: corsHeaders });
    }

    const est = task.estimated_minutes || 25;
    const expectedEnd = new Date(Date.now() + est * 60000).toISOString();

    const { error: tErr } = await supabase
      .from('productivity_tasks')
      .update({ started_at: now, expected_end_at: expectedEnd, status: 'active', auto_started: false })
      .eq('id', task.id);
    if (tErr) {
      console.error('task start update error', tErr);
      return new Response(JSON.stringify({ error: 'Failed to start task' }), { status: 500, headers: corsHeaders });
    }

    await supabase.from('productivity_day_sessions').update({ active_task_id: task.id }).eq('id', sessionId);

    // log event
    await supabase.from('productivity_task_events').insert({
      task_id: task.id,
      session_id: sessionId,
      event_type: 'started',
      created_at: now,
    });

    // return session and active task
    const { data: startedTask } = await supabase.from('productivity_tasks').select('*').eq('id', task.id).single();

    return new Response(JSON.stringify({ session: { id: sessionId }, task: startedTask }), { status: 200, headers: corsHeaders });
  } catch (err) {
    console.error('productivity-start error', err);
    return new Response(JSON.stringify({ error: 'Internal server error' }), { status: 500, headers: corsHeaders });
  }
});

