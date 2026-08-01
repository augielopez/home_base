<script setup lang="ts">
/**
 * Reusable AI classification action panel.
 * Used on Transactions now; Bills Recon can mount the same component later
 * with domain="bills-recon" once that backend path is implemented.
 */
import type { CategorizeResult } from '../types/balanceBase.types';

defineProps<{
    loading: boolean;
    disabled?: boolean;
    domain?: 'transactions' | 'bills-recon';
    title?: string;
    description?: string;
    buttonLabel?: string;
    lastResult?: CategorizeResult | null;
}>();

const emit = defineEmits<{
    run: [domain: 'transactions' | 'bills-recon'];
}>();
</script>

<template>
    <div class="card">
        <div class="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
            <div>
                <h3 class="text-lg font-semibold text-surface-900 dark:text-surface-0">
                    {{ title || 'AI Classification' }}
                </h3>
                <p class="text-muted-color text-sm">
                    {{
                        description ||
                        'Classify leftovers the keyword rules could not match. Manual categories are never overwritten.'
                    }}
                </p>
            </div>
            <Button
                :loading="loading"
                :disabled="disabled"
                :label="buttonLabel || 'Run AI Classify'"
                icon="pi pi-sparkles"
                class="whitespace-nowrap"
                @click="emit('run', domain || 'transactions')"
            />
        </div>

        <div
            v-if="lastResult"
            class="mt-4 rounded-border bg-violet-50 text-violet-700 dark:bg-violet-500/10 dark:text-violet-300 p-3 text-sm"
        >
            AI updated {{ lastResult.updated }} items ({{ lastResult.examined }} examined,
            {{ lastResult.skipped }} skipped<span v-if="lastResult.lowConfidence != null">,
                {{ lastResult.lowConfidence }} low-confidence</span
            >).
        </div>
    </div>
</template>
