<script setup>
import { onMounted, ref } from 'vue';
import { useRoute, useRouter } from 'vue-router';

const route = useRoute();
const router = useRouter();
const sessionId = route.params.sessionId;

const tasks = ref([]);
const activeIndex = ref(0);
const running = ref(true);
const remainingSeconds = ref(0);
let intervalId = null;

function loadSession() {
  try {
    const raw = localStorage.getItem(`productivity_session_${sessionId}`);
    if (raw) {
      tasks.value = JSON.parse(raw);
    } else {
      tasks.value = [];
    }
  } catch (e) {
    tasks.value = [];
  }
}

function startTimerForTask(index) {
  const t = tasks.value[index];
  const minutes = t?.estimatedMinutes ?? 25;
  remainingSeconds.value = Math.max(1, Math.floor(minutes) * 60);
  running.value = true;
  clearInterval(intervalId);
  intervalId = setInterval(() => {
    if (!running.value) return;
    remainingSeconds.value -= 1;
    if (remainingSeconds.value <= 0) {
      clearInterval(intervalId);
      // auto-advance to next
      if (activeIndex.value < tasks.value.length - 1) {
        activeIndex.value += 1;
        startTimerForTask(activeIndex.value);
      } else {
        running.value = false;
      }
    }
  }, 1000);
}

function toggleRunning() {
  running.value = !running.value;
}

function selectTask(i) {
  activeIndex.value = i;
  startTimerForTask(i);
}

onMounted(() => {
  loadSession();
  if (tasks.value.length) {
    // flatten parents->children into a single tasks list for the runner
    const flat = [];
    for (const p of tasks.value) {
      for (const c of (p.children || [])) {
        flat.push({ title: c.title, estimatedMinutes: c.estimatedMinutes });
      }
    }
    tasks.value = flat;
  }
  if (tasks.value.length) {
    startTimerForTask(0);
  }
});
</script>

<template>
  <div class="grid grid-cols-12 gap-4">
    <div class="col-span-4">
      <div class="card">
        <h3 class="text-lg font-semibold mb-2">Tasks</h3>
        <ul>
          <li v-for="(t, i) in tasks" :key="i" class="py-2 flex items-center justify-between cursor-pointer" :class="{ 'bg-surface-100': i === activeIndex }" @click="selectTask(i)">
            <div>{{ t.title }}</div>
            <div class="text-sm text-muted-color">{{ t.estimatedMinutes !== null ? t.estimatedMinutes + ' min' : '-' }}</div>
          </li>
        </ul>
      </div>
    </div>
    <div class="col-span-8">
      <div class="card flex flex-col items-center justify-center" style="min-height:420px;">
        <div class="text-muted-color mb-2 uppercase text-sm">Pomodoro</div>
        <div class="text-7xl font-bold">{{ Math.floor(remainingSeconds/60).toString().padStart(2,'0') }}:{{ (remainingSeconds%60).toString().padStart(2,'0') }}</div>
        <div class="text-xl mt-3">{{ tasks[activeIndex]?.title || 'No task' }}</div>
        <div class="mt-6">
          <Button :label="running ? 'Pause' : 'Resume'" @click="toggleRunning" />
          <Button label="Done & Next" class="ml-2" @click="() => { clearInterval(intervalId); if (activeIndex < tasks.length -1) { activeIndex += 1; startTimerForTask(activeIndex); } }" />
        </div>
      </div>
    </div>
  </div>
</template>

