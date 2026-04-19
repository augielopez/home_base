// @ts-nocheck
import { verify } from "https://deno.land/x/djwt@v2.8/mod.ts";

export async function tokenFromRequest(req: Request) {
  const auth = req.headers.get("authorization");
  if (auth && auth.startsWith("Bearer ")) return auth.slice(7);
  const cookie = req.headers.get("cookie") || "";
  const m = cookie.match(/(?:^|;\s*)hb_token=([^;]+)/);
  return m ? m[1] : null;
}

export async function verifyToken(token: string | null) {
  if (!token) return { valid: false, error: "missing token" };
  const secret = Deno.env.get("AUTH_JWT_SECRET");
  if (!secret) return { valid: false, error: "missing secret" };
  const key = await crypto.subtle.importKey(
    "raw",
    new TextEncoder().encode(secret),
    { name: "HMAC", hash: "SHA-256" },
    false,
    ["verify"]
  );

  try {
    const payload = await verify(token, key);
    return { valid: true, payload };
  } catch (err) {
    return { valid: false, error: err };
  }
}

