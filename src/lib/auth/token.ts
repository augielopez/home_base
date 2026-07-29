const HB_TOKEN_KEY = 'hb_token';

export function getHbToken(): string | null {
  try {
    return sessionStorage.getItem(HB_TOKEN_KEY);
  } catch {
    return null;
  }
}

export function setHbToken(token: string) {
  sessionStorage.setItem(HB_TOKEN_KEY, token);
}

export function clearHbToken() {
  try {
    sessionStorage.removeItem(HB_TOKEN_KEY);
  } catch {
    // ignore
  }
}

export function authHeaders(extra: Record<string, string> = {}): Record<string, string> {
  const headers: Record<string, string> = { 'Content-Type': 'application/json', ...extra };
  const token = getHbToken();
  if (token) headers.Authorization = `Bearer ${token}`;
  return headers;
}
