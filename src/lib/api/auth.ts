const FUNCTIONS_BASE = import.meta.env.VITE_FUNCTIONS_URL || '';

async function callFunction(path: string, opts: RequestInit = {}) {
  const url = FUNCTIONS_BASE ? `${FUNCTIONS_BASE}/${path}` : `/api/${path}`;
  const res = await fetch(url, {
    ...opts,
    credentials: 'include',
    headers: { 'Content-Type': 'application/json', ...(opts.headers || {}) },
  });
  const json = await res.json().catch(() => ({}));
  if (!res.ok) throw { status: res.status, body: json };
  return json;
}

export function login(username: string, password: string) {
  return callFunction('auth-login', { method: 'POST', body: JSON.stringify({ username, password }) });
}

export function signup(username: string, email: string, password: string) {
  return callFunction('auth-signup', { method: 'POST', body: JSON.stringify({ username, email, password }) });
}

export function logout() {
  return callFunction('logout', { method: 'POST' });
}

export function getProfile() {
  return callFunction('profile', { method: 'GET' });
}

