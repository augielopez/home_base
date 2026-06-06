import { ref } from 'vue';

const BASE = (import.meta.env.VITE_FUNCTIONS_URL || '');

function buildUrl(path: string) {
  return `${BASE}${path}`;
}

async function call(path: string, opts: RequestInit = {}) {
  const res = await fetch(buildUrl(path), { credentials: 'include', ...opts });
  const body = await res.json().catch(() => ({}));
  if (!res.ok) throw { status: res.status, body };
  return body;
}

export function useProductivityApi() {
  async function start(sessionId?: string, sessionDate?: string) {
    const body = {};
    if (sessionId) body['session_id'] = sessionId;
    if (sessionDate) body['session_date'] = sessionDate;
    return await call('/productivity-start', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(body) });
  }

  async function pause(taskId: string, reason: string) {
    return await call('/productivity-pause', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ task_id: taskId, reason }) });
  }

  async function resume(taskId: string, remaining_seconds?: number) {
    return await call('/productivity-resume', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ task_id: taskId, remaining_seconds }) });
  }

  async function complete(taskId: string) {
    return await call('/productivity-complete', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ task_id: taskId }) });
  }

  async function status(sessionId?: string) {
    const body = sessionId ? { session_id: sessionId } : {};
    return await call('/productivity-status', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(body) });
  }

  async function finish(sessionId: string) {
    return await call('/productivity-finish', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ session_id: sessionId }) });
  }

  return { start, pause, resume, complete, status, finish };
}

