<script setup>
import { computed, onMounted, ref, watch } from 'vue';

const STORAGE_KEY = 'home_base_productivity_todos';

const newTitle = ref('');
const todos = ref([]);

function load() {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (raw) {
      const parsed = JSON.parse(raw);
      if (Array.isArray(parsed)) todos.value = parsed;
    }
  } catch {
    todos.value = [];
  }
}

function persist() {
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(todos.value));
  } catch {
    /* ignore quota / private mode */
  }
}

onMounted(() => {
  load();
});

watch(todos, persist, { deep: true });

const openCount = computed(() => todos.value.filter((t) => !t.done).length);

function addTodo() {
  const title = newTitle.value.trim();
  if (!title) return;
  todos.value.unshift({
    id: crypto.randomUUID(),
    title,
    done: false,
    createdAt: new Date().toISOString()
  });
  newTitle.value = '';
}

function removeTodo(id) {
  todos.value = todos.value.filter((t) => t.id !== id);
}

function onKeydown(e) {
  if (e.key === 'Enter' && !e.shiftKey) {
    e.preventDefault();
    addTodo();
  }
}
</script>

<template>
  <div class="grid grid-cols-12 gap-4">
    <div class="col-span-12">
      <div class="card">
        <div class="flex flex-col gap-1 sm:flex-row sm:items-center sm:justify-between mb-6">
          <div>
            <h1 class="font-semibold text-2xl text-surface-900 dark:text-surface-0">Productivity Base</h1>
            <p class="text-muted-color mt-1">Track your todos — stored in this browser only.</p>
          </div>
          <span class="text-sm text-muted-color whitespace-nowrap">{{ openCount }} open</span>
        </div>

        <div class="flex flex-col sm:flex-row gap-3 mb-6">
          <InputText
            v-model="newTitle"
            class="flex-1"
            placeholder="Add a todo…"
            @keydown="onKeydown"
          />
          <Button label="Add" icon="pi pi-plus" @click="addTodo" />
        </div>

        <ul v-if="todos.length" class="flex flex-col gap-2 list-none p-0 m-0">
          <li
            v-for="t in todos"
            :key="t.id"
            class="flex items-center gap-3 rounded-lg border border-surface-200 dark:border-surface-700 px-4 py-3 bg-surface-0 dark:bg-surface-900"
          >
            <Checkbox v-model="t.done" binary :input-id="`todo-${t.id}`" />
            <label :for="`todo-${t.id}`" class="flex-1 cursor-pointer select-none">
              <span :class="{ 'line-through text-muted-color': t.done }">{{ t.title }}</span>
            </label>
            <Button icon="pi pi-trash" severity="danger" text rounded aria-label="Remove" @click="removeTodo(t.id)" />
          </li>
        </ul>
        <p v-else class="text-muted-color text-center py-10">No todos yet. Add one above.</p>
      </div>
    </div>
  </div>
</template>
