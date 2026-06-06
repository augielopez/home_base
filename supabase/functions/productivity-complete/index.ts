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
    if (!taskId) return new Response(JSON.stringify({ error: 'task_id required' }), { status: 400, headers: corsHeaders });

    const { data: task } = await supabase.from('productivity_tasks').select('*').eq('id', taskId).single();
    if (!task) return new Response(JSON.stringify({ error: 'Task not found' }), { status: 404, headers: corsHeaders });
    const now = new Date().toISOString();
    const started = task.started_at ? new Date(task.started_at) : null;
    let actualMinutes = 0;
    if (started) actualMinutes = Math.max(0, Math.round((Date.now() - started.getTime()) / 60000));

    const { error: uErr } = await supabase.from('productivity_tasks').update({ completed_at: now, actual_minutes: actualMinutes, status: 'completed', is_completed: true }).eq('id', taskId);
    if (uErr) {
      console.error('task complete update error', uErr);
      return new Response(JSON.stringify({ error: 'Failed to complete task' }), { status: 500, headers: corsHeaders });
    }

    const eventType = actualMinutes < (task.estimated_minutes || 0) ? 'completed_early' : 'completed_on_time';
    await supabase.from('productivity_task_events').insert({
      task_id: taskId,
      session_id: task.session_id,
      event_type: eventType,
      event_minutes: actualMinutes,
      created_at: now,
    });

    // find next
    const { data: next } = await supabase
      .from('productivity_tasks')
      .select('*')
      .eq('session_id', task.session_id)
      .eq('task_type', 'child')
      .neq('status', 'completed')
      .gt('display_order', task.display_order)
      .order('display_order', { ascending: true })
      .limit(1)
      .single();

    if (!next) {
      // finish session
      await supabase.from('productivity_day_sessions').update({ status: 'completed', ended_at: now, active_task_id: null }).eq('id', task.session_id);
      return new Response(JSON.stringify({ next: null }), { status: 200, headers: corsHeaders });
    }

    const est = next.estimated_minutes || 25;
    const expectedEnd = new Date(Date.now() + est * 60000).toISOString();
    await supabase.from('productivity_tasks').update({ started_at: now, expected_end_at: expectedEnd, status: 'active' }).eq('id', next.id);
    await supabase.from('productivity_day_sessions').update({ active_task_id: next.id }).eq('id', task.session_id);
    await supabase.from('productivity_task_events').insert({
      task_id: next.id,
      session_id: task.session_id,
      event_type: 'started',
      created_at: now,
    });

    const { data: nextTask } = await supabase.from('productivity_tasks').select('*').eq('id', next.id).single();
    return new Response(JSON.stringify({ next: nextTask }), { status: 200, headers: corsHeaders });
  } catch (err) {
    console.error('productivity-complete error', err);
    return new Response(JSON.stringify({ error: 'Internal server error' }), { status: 500, headers: corsHeaders });
  }
});

