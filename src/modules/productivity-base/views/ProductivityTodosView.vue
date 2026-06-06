<script setup>
import { computed, ref, onBeforeUnmount } from 'vue';
import { useRouter } from 'vue-router';
import { useProductivityApi } from '@/lib/composables/useProductivityApi';

const newParentTitle = ref('');
const jsonInput = ref('');
const importing = ref(false);
const importMessage = ref('');
const showImportDialog = ref(false);

// In-memory tree for imported tasks (parents -> children). Not persisted until Save.
const tree = ref([]);
const newChildTitle = ref({});
const newChildEstimate = ref({});
const saving = ref(false);
const savedSessionId = ref(null);
const router = useRouter();
const runMode = ref(false);
const sessionDate = ref(new Date().toISOString().split('T')[0]);
const activeTaskId = ref(null);
const activeTaskIndex = ref(0);
const remainingSeconds = ref(0);
const running = ref(false);
const pauseModal = ref(false);
const pauseReason = ref('');
const pausedRemaining = ref(0);
const api = useProductivityApi();
let timerInterval = null;

const openCount = computed(() => {
  return tree.value.reduce((acc, p) => acc + (p.children ? p.children.filter((c) => !c.done).length : 0), 0);
});

// todo/localStorage behavior removed — tasks are managed in tree and saved explicitly

function generateFromJson() {
  importMessage.value = '';
  try {
    importing.value = true;
    const parsed = JSON.parse(jsonInput.value);
    if (!Array.isArray(parsed)) throw new Error('JSON must be an array of parent nodes');
    // build in-memory tree
    const out = [];
    for (const parent of parsed) {
      const p = {
        id: crypto.randomUUID(),
        title: parent.title || 'Untitled',
        children: Array.isArray(parent.children)
          ? parent.children.map((c) => ({
              id: crypto.randomUUID(),
              title: c.title || 'Untitled Task',
              estimatedMinutes: typeof c.estimatedMinutes === 'number' ? c.estimatedMinutes : null,
              done: false
            }))
          : []
      };
      out.push(p);
    }
    tree.value = out;
    importMessage.value = 'JSON parsed into checklist (not yet saved)';
    // close import dialog after successful generate
    try {
      showImportDialog.value = false;
    } catch (e) {
      // ignore if template binding uses raw variable
      // no-op
    }
  } catch (err) {
    importMessage.value = (err && err.message) || 'Invalid JSON';
  } finally {
    importing.value = false;
  }
}

function addParent(title = 'New Group') {
  tree.value.push({ id: crypto.randomUUID(), title, children: [] });
}

function addGroupFromInput() {
  const t = (newParentTitle.value || '').trim();
  if (!t) return;
  addParent(t);
  newParentTitle.value = '';
}

function addChild(parentId) {
  const title = (newChildTitle.value[parentId] || '').trim() || 'New Task';
  const est = newChildEstimate.value[parentId] || null;
  const p = tree.value.find((x) => x.id === parentId);
  if (p) {
    p.children.push({ id: crypto.randomUUID(), title, estimatedMinutes: est, done: false });
    newChildTitle.value[parentId] = '';
    newChildEstimate.value[parentId] = null;
  }
}

function removeParent(parentId) {
  tree.value = tree.value.filter((p) => p.id !== parentId);
}

function removeChild(parentId, childId) {
  const p = tree.value.find((x) => x.id === parentId);
  if (p) p.children = p.children.filter((c) => c.id !== childId);
}

async function saveTree() {
  importMessage.value = '';
  saving.value = true;
  try {
    // basic validation: ensure child estimatedMinutes present (set null allowed)
    const payload = tree.value.map((p) => ({
      title: p.title,
      children: p.children.map((c) => ({ title: c.title, estimatedMinutes: c.estimatedMinutes ?? null }))
    }));
    const res = await fetch((import.meta.env.VITE_FUNCTIONS_URL || '') + '/productivity-import', {
      method: 'POST',
      credentials: 'include',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ tasks: payload })
    });
    const json = await res.json();
    if (!res.ok) {
      importMessage.value = json?.error || 'Save failed';
    } else {
      importMessage.value = 'Saved session ' + (json.session_id || '');
      savedSessionId.value = json.session_id || null;
      // optionally clear tree
      // tree.value = [];
    }
  } catch (err) {
    importMessage.value = (err && err.message) || 'Save failed';
  } finally {
    saving.value = false;
  }
}

async function start() {
  // ensure saved to DB first
  importMessage.value = '';
  try {
    await saveTree();
    const id = savedSessionId.value;
    if (!id) {
      importMessage.value = 'Failed to save session before start';
      return;
    }
    // call server start to set active task
    const resp = await api.start(id, sessionDate.value).catch((e) => {
      importMessage.value = e?.body?.error || 'Failed to start server session';
      return null;
    });
    if (!resp) return;
    // mark run mode and initialize timer based on returned active task
    runMode.value = true;
    // save session id
    savedSessionId.value = resp.session?.id || id;
    if (resp.task && resp.task.expected_end_at) {
      activeTaskId.value = resp.task.id;
      // compute remaining seconds
      remainingSeconds.value = Math.max(0, Math.floor((new Date(resp.task.expected_end_at).getTime() - Date.now()) / 1000));
      running.value = true;
      startTimerLoop();
    } else {
      // no task to run
      running.value = false;
    }
  } catch (err) {
    importMessage.value = (err && err.message) || 'Failed to start session';
  }
}

function startTimerLoop() {
  clearInterval(timerInterval);
  timerInterval = setInterval(async () => {
    if (!running.value) return;
    remainingSeconds.value -= 1;
    if (remainingSeconds.value <= 0) {
      // complete current task via API and advance
      clearInterval(timerInterval);
      running.value = false;
      try {
        const res = await api.complete(activeTaskId.value);
        const next = res?.next || res?.task || null;
        if (next && next.expected_end_at) {
          activeTaskId.value = next.id;
          remainingSeconds.value = Math.max(0, Math.floor((new Date(next.expected_end_at).getTime() - Date.now()) / 1000));
          running.value = true;
          startTimerLoop();
        } else {
          // session finished
          runMode.value = false;
        }
      } catch (e) {
        console.error('Error advancing to next task', e);
        importMessage.value = e?.body?.error || 'Failed to advance to next task';
      }
    }
  }, 1000);
}

onBeforeUnmount(() => {
  clearInterval(timerInterval);
});

async function handlePauseRequest(task) {
  // open modal to collect reason
  activeTaskId.value = task.id;
  pauseModal.value = true;
}

async function confirmPause() {
  pauseModal.value = false;
  try {
    const res = await api.pause(activeTaskId.value, pauseReason.value);
    pausedRemaining.value = res?.remaining_seconds ?? Math.max(0, remainingSeconds.value);
    running.value = false;
    clearInterval(timerInterval);
  } catch (e) {
    importMessage.value = e?.body?.error || 'Failed to pause';
  } finally {
    pauseReason.value = '';
  }
}

async function resumeTask(taskId) {
  try {
    const res = await api.resume(taskId, pausedRemaining.value);
    if (res && res.expected_end_at) {
      remainingSeconds.value = Math.max(0, Math.floor((new Date(res.expected_end_at).getTime() - Date.now()) / 1000));
      running.value = true;
      startTimerLoop();
    }
  } catch (e) {
    importMessage.value = e?.body?.error || 'Failed to resume';
  }
}

function selectTaskById(childId) {
  // find estimated minutes from tree
  for (const p of tree.value) {
    const c = (p.children || []).find((x) => x.id === childId);
    if (c) {
      activeTaskId.value = childId;
      const est = c.estimatedMinutes || 25;
      remainingSeconds.value = Math.max(1, Math.floor(est * 60));
      running.value = true;
      startTimerLoop();
      return;
    }
  }
}

function remainingSecondsVisible(parent) {
  const activeChild = (parent.children || []).find((c) => c.id === activeTaskId.value);
  if (!activeChild) return 0;
  const est = (activeChild.estimatedMinutes || 25) * 60;
  const elapsed = Math.max(0, est - remainingSeconds.value);
  return Math.min(100, Math.round((elapsed / est) * 100));
}
</script>

<template>
  <div class="grid grid-cols-12 gap-4">
    <div class="col-span-12">
      <div class="card">
        <div class="flex flex-col gap-1 sm:flex-row sm:items-center sm:justify-between mb-6">
          <div>
            <h1 class="font-semibold text-2xl text-surface-900 dark:text-surface-0">Productivity Base</h1>
            <p class="text-muted-color mt-1">Track your todos — create groups, import JSON, and start focused sessions.</p>
          </div>
        </div>

        <div class="flex flex-col sm:flex-row gap-3 mb-6">
          <div class="flex gap-2 w-full">
            <InputText v-model="newParentTitle" class="w-full" placeholder="New group title" />
            <Button class="whitespace-nowrap" label="Add Group" icon="pi pi-plus" @click="addGroupFromInput" />
            <Button label="Import" icon="pi pi-upload" class="ml-2" @click="() => (showImportDialog = true)" />
          </div>
        </div>
      </div>

      <Dialog v-model:visible="showImportDialog" header="Import Tasks (JSON)" :modal="true" class="w-full max-w-3xl" @hide="() => { importMessage = ''; jsonInput = '' }">
        <div class="p-4">
          <textarea v-model="jsonInput" rows="10" class="w-full p-2 border rounded" placeholder='Paste task JSON here (see docs)'></textarea>
          <div class="flex gap-2 mt-3">
            <Button :loading="importing" label="Generate Tasks" @click="generateFromJson" />
            <Button label="Clear" severity="secondary" @click="() => (jsonInput = '')" />
            <Button label="Close" severity="secondary" @click="() => (showImportDialog = false)" />
          </div>
          <p class="text-sm text-muted-color mt-2">{{ importMessage }}</p>
        </div>
      </Dialog>

      <div class="card mt-4">
        <div class="flex items-center justify-between mb-4">
          <div class="flex items-center gap-4">
            <h3 class="text-lg font-semibold">Tasks</h3>
            <span class="text-sm text-muted-color">{{ tree.length }} groups / {{ openCount }} open</span>
          </div>
          <div class="flex items-center gap-2">
            <input type="date" v-model="sessionDate" class="border rounded px-2 py-1 mr-2" aria-label="Session date" />
            <Button v-if="tree.length && !runMode" :loading="saving" label="Save to DB" severity="success" @click="saveTree" title="Persist tasks to the database" />
            <Button v-if="tree.length" class="ml-2" :label="runMode ? 'Done' : 'Start'" :severity="runMode ? 'secondary' : 'primary'" @click="runMode ? (runMode=false, clearInterval(timerInterval)) : start" :title="runMode ? 'Finish the session' : 'Start run mode'" />
          </div>
        </div>

        <div v-if="tree.length" class="flex flex-col gap-4">
          <div v-for="parent in tree" :key="parent.id" class="p-3 border rounded bg-surface-50 dark:bg-surface-900">
            <div class="flex items-center justify-between mb-2">
              <h4 class="text-lg font-semibold">{{ parent.title }}</h4>
              <template v-if="!runMode">
                <Button icon="pi pi-trash" class="p-button-text p-button-danger" @click="removeParent(parent.id)" />
              </template>
            </div>
            <ul class="ml-4">
              <li v-for="child in parent.children" :key="child.id" class="flex items-center gap-3 py-1">
                <input type="checkbox" v-model="child.done" />
                <div class="flex-1">
                  <div class="font-medium">{{ child.title }}</div>
                </div>
                <div class="text-sm text-muted-color mr-2">{{ child.estimatedMinutes !== null ? child.estimatedMinutes + ' min' : '-' }}</div>
                <template v-if="!runMode">
                  <Button icon="pi pi-trash" class="p-button-text p-button-danger" @click="removeChild(parent.id, child.id)" />
                </template>
                <template v-else>
                  <div class="flex items-center gap-2">
                    <Button v-if="activeTaskId !== child.id" icon="pi pi-play" class="p-button-text" @click="() => selectTaskById(child.id)" title="Start this task" aria-label="Start task" />
                    <Button v-else :icon="running ? 'pi pi-pause' : 'pi pi-play'" class="p-button-text" @click="() => { if(running) handlePauseRequest(child); else resumeTask(child.id) }" :title="running ? 'Pause' : 'Resume'" :aria-label="running ? 'Pause task' : 'Resume task'" />
                  </div>
                </template>
              </li>
              <li v-if="runMode && parent.children && parent.children.find(c => c.id === activeTaskId)">
                <div class="w-full mt-2">
                  <div class="h-2 bg-gray-200 rounded overflow-hidden">
                    <div :style=\"{ width: (remainingSecondsVisible(parent) ) + '%' }\" class=\"h-2 bg-blue-500\"></div>
                  </div>
                </div>
              </li>
            </ul>
            <div class="mt-2 flex gap-2">
              <InputText v-if=\"!runMode\" v-model=\"newChildTitle[parent.id]\" placeholder=\"Child title\" />
              <InputText v-if=\"!runMode\" type=\"number\" v-model.number=\"newChildEstimate[parent.id]\" placeholder=\"Minutes\" style=\"width:6rem\" />
              <Button v-if=\"!runMode\" label=\"Add Task\" @click=\"() => addChild(parent.id)\" />
              <Button class=\"whitespace-nowrap\" label=\"Add Group\" severity=\"secondary\" @click=\"addParent('New Group')\" />
            </div>
          </div>
        </div>
        <p v-else class="text-muted-color text-center py-10">No todos yet. Add one above.</p>
      </div>
    </div>
  </div>
</template>

<Dialog v-model:visible="pauseModal" header="Pause reason" :modal="true" class="w-full max-w-lg">
  <div class="p-4">
    <label class="block text-sm mb-2">Why are you pausing?</label>
    <InputText v-model="pauseReason" class="w-full mb-3" placeholder="Brief reason (required)" />
    <div class="flex justify-end gap-2">
      <Button label="Cancel" severity="secondary" @click="() => (pauseModal=false)" />
      <Button label="Pause" severity="warning" @click="confirmPause" :disabled="!pauseReason.trim()" />
    </div>
  </div>
</Dialog>
