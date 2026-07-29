<script setup lang="ts">
defineProps<{
    title: string;
    description?: string;
}>();
</script>

<template>
    <section>
        <div class="card">
            <h1 class="font-semibold text-2xl text-surface-900 dark:text-surface-0">{{ title }}</h1>
            <p class="text-muted-color mt-2">{{ description || 'This page is coming soon.' }}</p>
        </div>
    </section>
</template>
