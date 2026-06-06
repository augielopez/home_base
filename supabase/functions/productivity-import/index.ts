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

  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }
  if (req.method !== "POST") {
    return new Response("Method Not Allowed", { status: 405, headers: corsHeaders });
  }

  try {
    const supabaseUrl = Deno.env.get("PROJECT_URL");
    const serviceKey = Deno.env.get("SERVICE_ROLE_KEY");
    if (!supabaseUrl || !serviceKey) {
      console.error("Missing Supabase environment configuration");
      return new Response(JSON.stringify({ error: "Server configuration error" }), { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } });
    }

    const supabase = createClient(supabaseUrl, serviceKey, { auth: { persistSession: false } });

    const body = await req.json();
    const { user_id, session_date, session_id, tasks } = body || {};
    if (!Array.isArray(tasks)) {
      return new Response(JSON.stringify({ error: "Invalid tasks payload" }), { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } });
    }

    // use provided session_id if present
    let session = null;
    if (session_id) {
      const { data: existing, error: exErr } = await supabase.from("productivity_day_sessions").select("*").eq("id", session_id).single();
      if (exErr || !existing) {
        console.error("invalid session_id provided", exErr);
        return new Response(JSON.stringify({ error: "Invalid session_id" }), { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } });
      }
      session = existing;
    } else {
      // create session; ensure session_date is non-null (use provided or today's date)
      const sessionPayload: Record<string, unknown> = {
        user_id: user_id || null,
        status: "not_started",
        session_date: (typeof session_date !== 'undefined' && session_date !== null) ? session_date : new Date().toISOString().split('T')[0]
      };
      const { data: sData, error: sessErr } = await supabase.from("productivity_day_sessions").insert([sessionPayload]).select("*").single();
      if (sessErr) {
        console.error("session create error", sessErr);
        return new Response(JSON.stringify({ error: "Failed to create session" }), { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } });
      }
      session = sData;
    }

    let order = 0;
    const parentIds: Array<any> = [];
    for (const parent of tasks) {
      const parentRec = {
        session_id: session.id,
        parent_task_id: null,
        task_type: "parent",
        title: parent.title || "Untitled",
        display_order: order++,
      };
      const { data: pData, error: pErr } = await supabase.from("productivity_tasks").insert([parentRec]).select("*").single();
      if (pErr) {
        console.error("parent insert error", pErr);
        return new Response(JSON.stringify({ error: "Failed to insert parent task" }), { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } });
      }
      parentIds.push(pData.id);
      if (Array.isArray(parent.children)) {
        for (const child of parent.children) {
          const childRec = {
            session_id: session.id,
            parent_task_id: pData.id,
            task_type: "child",
            title: child.title || "Untitled Task",
            display_order: order++,
            estimated_minutes: child.estimatedMinutes ?? null,
          };
          const { error: cErr } = await supabase.from("productivity_tasks").insert([childRec]);
          if (cErr) {
            console.error("child insert error", cErr);
            return new Response(JSON.stringify({ error: "Failed to insert child task" }), { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } });
          }
        }
      }
    }

    // log import events for parents
    const events = parentIds.map((pid) => ({ task_id: pid, session_id: session.id, event_type: "imported", metadata: { source: "json_import" } }));
    const { error: evErr } = await supabase.from("productivity_task_events").insert(events);
    if (evErr) {
      console.error("events insert error", evErr);
    }

    return new Response(JSON.stringify({ success: true, session_id: session.id }), { status: 201, headers: { ...corsHeaders, "Content-Type": "application/json" } });
  } catch (err) {
    console.error("productivity-import error", err);
    return new Response(JSON.stringify({ error: "Internal server error" }), { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } });
  }
});

