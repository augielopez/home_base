// @ts-nocheck
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import * as bcrypt from "https://esm.sh/bcryptjs@2.4.3";
import { create, getNumericDate } from "https://deno.land/x/djwt@v2.8/mod.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
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
      return jsonResponse({ error: "Server configuration error" }, 500);
    }

    const supabase = createClient(supabaseUrl, serviceKey, { auth: { persistSession: false } });
    const payload = await req.json();

    if (!payload || !payload.username || !payload.password) {
      return jsonResponse({ error: "username and password are required" }, 400);
    }

    const username = String(payload.username).trim();
    const password = String(payload.password);

    if (username.length < 1 || password.length < 1) {
      return jsonResponse({ error: "Invalid input" }, 400);
    }

    const { data, error } = await supabase.from("master_users").select("*").eq("username", username).limit(1);

    if (error) {
      console.error("master_users lookup error:", error.message);
      return jsonResponse({ error: "Authentication failed" }, 500);
    }

    const user = Array.isArray(data) && data.length ? data[0] : null;
    if (!user || !user.password_hash) {
      // Avoid leaking whether username exists
      return jsonResponse({ error: "Invalid credentials" }, 401);
    }

    const match = await bcrypt.compare(password, user.password_hash);
    if (!match) {
      return jsonResponse({ error: "Invalid credentials" }, 401);
    }

    // Do not include password hash in response
    delete (user as Record<string, unknown>).password_hash;

    // Create JWT
    const jwtSecret = Deno.env.get("AUTH_JWT_SECRET");
    if (!jwtSecret) {
      console.error("Missing AUTH_JWT_SECRET");
      return jsonResponse({ error: "Server configuration error" }, 500);
    }

    const cryptoKey = await crypto.subtle.importKey(
      "raw",
      new TextEncoder().encode(jwtSecret),
      { name: "HMAC", hash: "SHA-256" },
      false,
      ["sign"]
    );

    const token = await create(
      { alg: "HS256", typ: "JWT" },
      {
        iss: "homebase",
        sub: String(user.user_id ?? user.user_id),
        username: user.username,
        exp: getNumericDate(60 * 60), // 1 hour
      },
      cryptoKey
    );

    return jsonResponse({ success: true, user, token }, 200);
  } catch (err) {
    console.error("auth-login error:", err);
    return jsonResponse({ error: "Internal server error" }, 500);
  }
});

function jsonResponse(body: Record<string, unknown>, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

