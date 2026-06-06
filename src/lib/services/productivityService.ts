import type { SupabaseClient } from '@supabase/supabase-js';

type UUID = string;

export class ProductivityService {
  client: SupabaseClient;
  constructor(client: SupabaseClient) {
    this.client = client;
  }

  async createSession(userId?: number, sessionDate?: string) {
    const { data, error } = await this.client
      .from('productivity_day_sessions')
      .insert([{ user_id: userId || null, session_date: sessionDate || null }])
      .select('*')
      .single();
    if (error) throw error;
    return data;
  }

  async importTasks(sessionId: UUID, json: any[]) {
    // json: array of parents with children
    const insertedParents: any[] = [];
    let order = 0;
    for (const parent of json) {
      const parentRecord = {
        session_id: sessionId,
        parent_task_id: null,
        task_type: 'parent',
        title: parent.title || 'Untitled',
        display_order: order++,
      };
      const { data: pData, error: pErr } = await this.client
        .from('productivity_tasks')
        .insert([parentRecord])
        .select('*')
        .single();
      if (pErr) throw pErr;
      insertedParents.push(pData);

      if (Array.isArray(parent.children)) {
        for (const child of parent.children) {
          const childRecord = {
            session_id: sessionId,
            parent_task_id: pData.id,
            task_type: 'child',
            title: child.title || 'Untitled Task',
            display_order: order++,
            estimated_minutes: child.estimatedMinutes || null,
          };
          const { error: cErr } = await this.client.from('productivity_tasks').insert([childRecord]);
          if (cErr) throw cErr;
        }
      }
    }
    // log import event per task
    const { error } = await this.client.from('productivity_task_events').insert(
      insertedParents.map((p) => ({
        task_id: p.id,
        session_id: sessionId,
        event_type: 'imported',
        metadata: { source: 'json_import' },
      }))
    );
    if (error) throw error;
    return true;
  }

  async startSession(sessionId: UUID) {
    // set session active
    const now = new Date().toISOString();
    const { error: sErr } = await this.client
      .from('productivity_day_sessions')
      .update({ status: 'active', started_at: now })
      .eq('id', sessionId);
    if (sErr) throw sErr;

    // find first incomplete child task
    const { data: task } = await this.client
      .from('productivity_tasks')
      .select('*')
      .eq('session_id', sessionId)
      .eq('task_type', 'child')
      .neq('status', 'completed')
      .order('display_order', { ascending: true })
      .limit(1)
      .single();

    if (!task) {
      // mark session completed
      await this.client.from('productivity_day_sessions').update({ status: 'completed', ended_at: now }).eq('id', sessionId);
      return null;
    }

    // start the task
    const est = task.estimated_minutes || 0;
    const expectedEnd = new Date(Date.now() + est * 60000).toISOString();
    const { error: tErr } = await this.client
      .from('productivity_tasks')
      .update({ started_at: now, expected_end_at: expectedEnd, status: 'active', auto_started: false })
      .eq('id', task.id);
    if (tErr) throw tErr;

    // update session active_task_id
    await this.client.from('productivity_day_sessions').update({ active_task_id: task.id }).eq('id', sessionId);

    // log event
    await this.client.from('productivity_task_events').insert({
      task_id: task.id,
      session_id: sessionId,
      event_type: 'started',
      created_at: now,
    });

    return task;
  }

  async getActiveSession(userId?: number) {
    const query = this.client.from('productivity_day_sessions').select('*').eq('status', 'active').limit(1);
    if (userId) query.eq('user_id', userId);
    const { data } = await query.single();
    return data;
  }

  async getActiveTask(sessionId: UUID) {
    const { data } = await this.client
      .from('productivity_day_sessions')
      .select('active_task_id')
      .eq('id', sessionId)
      .single();
    if (!data || !data.active_task_id) return null;
    const { data: task } = await this.client.from('productivity_tasks').select('*').eq('id', data.active_task_id).single();
    return task;
  }

  // extend task by minutes
  async extendTask(taskId: UUID, minutes: number) {
    // increase extension_minutes and expected_end_at
    const { data: task } = await this.client.from('productivity_tasks').select('*').eq('id', taskId).single();
    if (!task) throw new Error('Task not found');
    const newExt = (task.extension_minutes || 0) + minutes;
    let newExpected = task.expected_end_at ? new Date(task.expected_end_at) : new Date();
    newExpected = new Date(newExpected.getTime() + minutes * 60000);
    const { error } = await this.client
      .from('productivity_tasks')
      .update({ extension_minutes: newExt, expected_end_at: newExpected.toISOString() })
      .eq('id', taskId);
    if (error) throw error;
    await this.client.from('productivity_task_events').insert({
      task_id: taskId,
      session_id: task.session_id,
      event_type: 'extended',
      event_minutes: minutes,
      metadata: {},
    });
    return true;
  }

  async completeTask(taskId: UUID, manual = true) {
    const now = new Date().toISOString();
    const { data: task } = await this.client.from('productivity_tasks').select('*').eq('id', taskId).single();
    if (!task) throw new Error('Task not found');
    const started = task.started_at ? new Date(task.started_at) : null;
    let actualMinutes = 0;
    if (started) {
      actualMinutes = Math.max(0, Math.round((Date.now() - started.getTime()) / 60000));
    }
    const { error } = await this.client
      .from('productivity_tasks')
      .update({ completed_at: now, actual_minutes: actualMinutes, status: 'completed', is_completed: true })
      .eq('id', taskId);
    if (error) throw error;

    // log event
    const eventType = manual ? (actualMinutes < (task.estimated_minutes || 0) ? 'completed_early' : 'completed_on_time') : 'auto_advanced';
    await this.client.from('productivity_task_events').insert({
      task_id: taskId,
      session_id: task.session_id,
      event_type: eventType,
      event_minutes: actualMinutes,
      created_at: now,
    });

    // advance to next
    await this.advanceToNext(task.session_id, task.display_order);
    return true;
  }

  async advanceToNext(sessionId: UUID, afterOrder: number) {
    // find next incomplete child task
    const { data: next } = await this.client
      .from('productivity_tasks')
      .select('*')
      .eq('session_id', sessionId)
      .eq('task_type', 'child')
      .neq('status', 'completed')
      .gt('display_order', afterOrder)
      .order('display_order', { ascending: true })
      .limit(1)
      .single();

    const now = new Date().toISOString();
    if (!next) {
      // finish session
      await this.client.from('productivity_day_sessions').update({ status: 'completed', ended_at: now, active_task_id: null }).eq('id', sessionId);
      return null;
    }

    const est = next.estimated_minutes || 0;
    const expectedEnd = new Date(Date.now() + est * 60000).toISOString();
    await this.client.from('productivity_tasks').update({ started_at: now, expected_end_at: expectedEnd, status: 'active' }).eq('id', next.id);
    await this.client.from('productivity_day_sessions').update({ active_task_id: next.id }).eq('id', sessionId);
    await this.client.from('productivity_task_events').insert({
      task_id: next.id,
      session_id: sessionId,
      event_type: 'started',
      created_at: now,
    });
    return next;
  }

  // resume session: process expired tasks and set current active task
  async resumeSession(sessionId: UUID) {
    let session = await this.getActiveSession();
    if (!session || session.id !== sessionId) {
      const { data } = await this.client.from('productivity_day_sessions').select('*').eq('id', sessionId).single();
      session = data;
    }
    if (!session || session.status !== 'active') return null;

    // iterate from active task forward, auto-completing expired tasks
    let activeTask = await this.getActiveTask(sessionId);
    while (activeTask) {
      const now = new Date();
      const expected = activeTask.expected_end_at ? new Date(activeTask.expected_end_at) : null;
      if (!expected || now <= expected) break;
      // auto-complete this task
      await this.completeTask(activeTask.id, false);
      // fetch updated active task
      activeTask = await this.getActiveTask(sessionId);
    }
    // return currently active task (may be null)
    return await this.getActiveTask(sessionId);
  }

  // utilities
  remainingSeconds(task: any) {
    if (!task || !task.expected_end_at) return 0;
    const expected = new Date(task.expected_end_at).getTime();
    return Math.max(0, Math.floor((expected - Date.now()) / 1000));
  }

  actualMinutesFromTimestamps(startedAt?: string, endedAt?: string) {
    if (!startedAt || !endedAt) return 0;
    const s = new Date(startedAt).getTime();
    const e = new Date(endedAt).getTime();
    return Math.max(0, Math.round((e - s) / 60000));
  }
}

