<script setup lang="ts">
import { computed } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import type { CategorizeResult, SimpleFinSyncResult } from '../types/balanceBase.types';

const props = defineProps<{
    syncing: boolean;
    categorizing: boolean;
    error: string | null;
    lastSyncResult: SimpleFinSyncResult | null;
    lastCategorizeResult: CategorizeResult | null;
}>();

const emit = defineEmits<{
    sync: [];
    applyRules: [];
}>();

const router = useRouter();
const route = useRoute();

const needsLogin = computed(() => {
    if (!props.error) return false;
    return /sign in/i.test(props.error);
});

function goToLogin() {
    router.push({ name: 'login', query: { redirect: route.fullPath } });
}
</script>

<template>
    <div class="card">
        <div class="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
            <div>
                <h3 class="text-lg font-semibold text-surface-900 dark:text-surface-0">SimpleFIN Sync</h3>
                <p class="text-muted-color text-sm">
                    Pull the latest accounts and transactions, then apply keyword category rules.
                </p>
            </div>
            <div class="flex flex-col sm:flex-row gap-2">
                <Button
                    :loading="categorizing"
                    label="Apply Rules"
                    icon="pi pi-sitemap"
                    severity="secondary"
                    class="whitespace-nowrap"
                    @click="emit('applyRules')"
                />
                <Button :loading="syncing" label="Sync Transactions" icon="pi pi-refresh" class="whitespace-nowrap" @click="emit('sync')" />
            </div>
        </div>

        <div v-if="lastSyncResult" class="mt-4 rounded-border bg-green-50 text-green-700 dark:bg-green-500/10 dark:text-green-300 p-3 text-sm">
            Synced {{ lastSyncResult.accountsProcessed }} accounts and {{ lastSyncResult.transactionsProcessed }} transactions.
            <span v-if="lastSyncResult.categorized">
                Auto-categorized {{ lastSyncResult.categorized.updated }} of {{ lastSyncResult.categorized.examined }} reviewed.
            </span>
            <div v-if="lastSyncResult.warnings?.length" class="mt-2 text-amber-700 dark:text-amber-300">
                Warnings: {{ lastSyncResult.warnings.join('; ') }}
            </div>
        </div>

        <div
            v-if="lastCategorizeResult"
            class="mt-4 rounded-border bg-blue-50 text-blue-700 dark:bg-blue-500/10 dark:text-blue-300 p-3 text-sm"
        >
            Applied rules to {{ lastCategorizeResult.updated }} transactions ({{ lastCategorizeResult.examined }} examined,
            {{ lastCategorizeResult.skipped }} skipped).
        </div>

        <div
            v-if="error"
            class="mt-4 rounded-border bg-red-50 text-red-700 dark:bg-red-500/10 dark:text-red-300 p-3 text-sm flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between"
        >
            <span>{{ error }}</span>
            <Button v-if="needsLogin" label="Login" icon="pi pi-sign-in" class="whitespace-nowrap" @click="goToLogin" />
        </div>
    </div>
</template>
