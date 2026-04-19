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

    if (!payload || !payload.username || !payload.password || !payload.email) {
      return jsonResponse({ error: "username, email and password are required" }, 400);
    }

    const username = String(payload.username).trim();
    const email = String(payload.email).trim().toLowerCase();
    const password = String(payload.password);

    if (username.length < 3 || password.length < 8 || !email.includes("@")) {
      return jsonResponse({ error: "Invalid input" }, 400);
    }

    // Ensure username uniqueness
    const { data: existing } = await supabase.from("master_users").select("user_id").eq("username", username).limit(1);
    if (existing && existing.length) {
      return jsonResponse({ error: "Username already taken" }, 409);
    }

    // Hash password with bcrypt
    const saltRounds = 12;
    const passwordHash = await bcrypt.hash(password, saltRounds);

    const insertPayload: Record<string, unknown> = {
      username,
      email,
      password_hash: passwordHash,
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
    };

    const { data, error } = await supabase.from("master_users").insert(insertPayload).select("*").limit(1);

    if (error) {
      console.error("master_users insert error:", error.message);
      return jsonResponse({ error: "Failed to create user" }, 500);
    }

    const created = Array.isArray(data) && data.length ? data[0] : data;
    // Do not return password hash
    if (created && created.password_hash) {
      delete (created as Record<string, unknown>).password_hash;
    }

    // Create JWT for the new user
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
        sub: String(created.user_id ?? created.user_id),
        username: created.username,
        exp: getNumericDate(60 * 60), // 1 hour
      },
      cryptoKey
    );

    return jsonResponse({ success: true, user: created, token }, 201);
  } catch (err) {
    console.error("auth-signup error:", err);
    return jsonResponse({ error: "Internal server error" }, 500);
  }
});

function jsonResponse(body: Record<string, unknown>, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

