// @ts-nocheck
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import * as bcrypt from "https://esm.sh/bcryptjs@2.4.3";
import { create, getNumericDate } from "https://deno.land/x/djwt@v2.8/mod.ts";

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

  if (req.method !== "POST") {
    return new Response("Method Not Allowed", { status: 405, headers: corsHeaders });
  }

  try {
    const supabaseUrl = Deno.env.get("PROJECT_URL");
    const serviceKey = Deno.env.get("SERVICE_ROLE_KEY");

    if (!supabaseUrl || !serviceKey) {
      console.error("Missing Supabase environment configuration");
      return jsonResponse({ error: "Server configuration error" }, 500, corsHeaders);
    }

    const supabase = createClient(supabaseUrl, serviceKey, { auth: { persistSession: false } });
    const payload = await req.json();

    if (!payload || !payload.username || !payload.password) {
      return jsonResponse({ error: "username and password are required" }, 400, corsHeaders);
    }

    const username = String(payload.username).trim();
    const password = String(payload.password);

    if (username.length < 1 || password.length < 1) {
      return jsonResponse({ error: "Invalid input" }, 400, corsHeaders);
    }

    const { data, error } = await supabase.from("master_users").select("*").eq("username", username).limit(1);

    if (error) {
      console.error("master_users lookup error:", error.message);
      return jsonResponse({ error: "Authentication failed" }, 500, corsHeaders);
    }

    const user = Array.isArray(data) && data.length ? data[0] : null;
    if (!user || !user.password_hash) {
      // Avoid leaking whether username exists
      return jsonResponse({ error: "Invalid credentials" }, 401, corsHeaders);
    }

    // Password compatibility:
    // - bcrypt hashes (start with $2a/$2b/$2y) -> use bcrypt.compare
    // - SHA-256 hex (64 hex chars) -> compare hex(password)
    // - legacy base64 (btoa) -> compare btoa(password)
    const stored = user.password_hash || '';
    let match = false;

    try {
      if (/^\$2[aby]\$/.test(stored)) {
        // bcrypt
        match = await bcrypt.compare(password, stored);
      } else if (/^[0-9a-f]{64}$/i.test(stored)) {
        // SHA-256 hex
        const data = new TextEncoder().encode(password);
        const digest = await crypto.subtle.digest('SHA-256', data);
        const hex = Array.from(new Uint8Array(digest)).map(b => b.toString(16).padStart(2, '0')).join('');
        match = hex === stored.toLowerCase();
      } else {
        // legacy base64 (btoa)
        try {
          match = (btoa(password) === stored);
        } catch {
          match = false;
        }
      }
    } catch (err) {
      console.error('Error verifying password format:', err);
      return jsonResponse({ error: "Authentication failed" }, 500, corsHeaders);
    }

    if (!match) {
      return jsonResponse({ error: "Invalid credentials" }, 401, corsHeaders);
    }

    // If matched and the stored value is not bcrypt, migrate to bcrypt (best-effort)
    if (!/^\$2[aby]\$/.test(stored)) {
      try {
        const newHash = await bcrypt.hash(password, 12);
        await supabase.from('master_users').update({ password_hash: newHash }).eq('user_id', user.user_id);
      } catch (err) {
        console.error('Failed to migrate legacy password to bcrypt for user', user.user_id, err);
        // don't block login on migration failure
      }
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

    // set cookie (httpOnly, Secure, SameSite=None for cross-site cookies)
    const maxAge = 60 * 60; // 1 hour
    const cookie = `hb_token=${token}; HttpOnly; Secure; SameSite=None; Path=/; Max-Age=${maxAge}`;

    return jsonResponse({ success: true, user, token }, 200, { "Set-Cookie": cookie, ...corsHeaders });
  } catch (err) {
    console.error("auth-login error:", err);
    return jsonResponse({ error: "Internal server error" }, 500, corsHeaders);
  }
});

function jsonResponse(body: Record<string, unknown>, status = 200, extraHeaders: Record<string, string> = {}) {
  const headers = {
    "Content-Type": "application/json",
    ...extraHeaders,
  };
  return new Response(JSON.stringify(body), {
    status,
    headers,
  });
}

