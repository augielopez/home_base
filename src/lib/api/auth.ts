import { authHeaders, clearHbToken, setHbToken } from '@/lib/auth/token';

const FUNCTIONS_BASE = import.meta.env.VITE_FUNCTIONS_URL || '';

async function callFunction(path: string, opts: RequestInit = {}) {
  const url = FUNCTIONS_BASE ? `${FUNCTIONS_BASE}/${path}` : `/api/${path}`;
  const res = await fetch(url, {
    ...opts,
    credentials: 'include',
    headers: authHeaders((opts.headers as Record<string, string>) || {}),
  });
  const json = await res.json().catch(() => ({}));
  if (!res.ok) throw { status: res.status, body: json };
  return json;
}

export async function login(username: string, password: string) {
  const json = await callFunction('auth-login', { method: 'POST', body: JSON.stringify({ username, password }) });
  if (json?.token) setHbToken(String(json.token));
  return json;
}

export async function signup(username: string, email: string, password: string) {
  const json = await callFunction('auth-signup', { method: 'POST', body: JSON.stringify({ username, email, password }) });
  if (json?.token) setHbToken(String(json.token));
  return json;
}

export async function logout() {
  try {
    return await callFunction('logout', { method: 'POST' });
  } finally {
    clearHbToken();
  }
}

export function getProfile() {
  return callFunction('profile', { method: 'GET' });
}

