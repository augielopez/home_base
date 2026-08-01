<script setup lang="ts">
import { computed, onMounted, ref } from 'vue';
import { storeToRefs } from 'pinia';
import { useRoute, useRouter } from 'vue-router';
import TransactionFilters from '../components/TransactionFilters.vue';
import TransactionSummaryCards from '../components/TransactionSummaryCards.vue';
import TransactionsTable from '../components/TransactionsTable.vue';
import { useBalanceBaseStore } from '../stores/balanceBaseStore';
import type { TransactionFilters as TransactionFiltersType } from '../types/balanceBase.types';

const store = useBalanceBaseStore();
const {
    accounts,
    categories,
    transactions,
    syncRuns,
    loading,
    syncing,
    categorizing,
    aiClassifying,
    updatingCategoryId,
    error,
    lastSyncResult,
    lastCategorizeResult,
    lastAiResult,
    filters
} = storeToRefs(store);
const router = useRouter();
const route = useRoute();
const categoryError = ref<string | null>(null);
const toolsMenu = ref();

const needsLogin = computed(() => {
    if (!error.value) return false;
    return /sign in/i.test(error.value);
});

const toolsBusy = computed(() => syncing.value || categorizing.value || aiClassifying.value);

const toolsMenuItems = computed(() => [
    {
        label: 'SimpleFIN',
        items: [
            {
                label: syncing.value ? 'Syncing…' : 'Sync Transactions',
                icon: 'pi pi-refresh',
                disabled: toolsBusy.value,
                command: () => handleSync()
            },
            {
                label: categorizing.value ? 'Applying rules…' : 'Apply Rules',
                icon: 'pi pi-sitemap',
                disabled: toolsBusy.value,
                command: () => handleApplyRules()
            }
        ]
    },
    {
        label: 'AI',
        items: [
            {
                label: aiClassifying.value ? 'Classifying…' : 'Run AI Classify',
                icon: 'pi pi-sparkles',
                disabled: toolsBusy.value,
                command: () => handleAiClassify()
            }
        ]
    }
]);

const statusMessage = computed(() => {
    if (lastAiResult.value) {
        return `AI updated ${lastAiResult.value.updated} items (${lastAiResult.value.examined} examined, ${lastAiResult.value.skipped} skipped${
            lastAiResult.value.lowConfidence != null ? `, ${lastAiResult.value.lowConfidence} low-confidence` : ''
        }).`;
    }
    if (lastCategorizeResult.value) {
        return `Applied rules to ${lastCategorizeResult.value.updated} transactions (${lastCategorizeResult.value.examined} examined, ${lastCategorizeResult.value.skipped} skipped).`;
    }
    if (lastSyncResult.value) {
        const base = `Synced ${lastSyncResult.value.accountsProcessed} accounts and ${lastSyncResult.value.transactionsProcessed} transactions.`;
        const categorized = lastSyncResult.value.categorized
            ? ` Auto-categorized ${lastSyncResult.value.categorized.updated} of ${lastSyncResult.value.categorized.examined} reviewed.`
            : '';
        const warnings = lastSyncResult.value.warnings?.length ? ` Warnings: ${lastSyncResult.value.warnings.join('; ')}` : '';
        return `${base}${categorized}${warnings}`;
    }
    return null;
});

onMounted(() => {
    store.refreshTransactionsPage();
});

function toggleToolsMenu(event: Event) {
    toolsMenu.value?.toggle(event);
}

async function handleSync() {
    await store.syncSimplefin();
}

async function handleApplyRules() {
    await store.applyCategoryRules();
}

async function handleAiClassify() {
    await store.applyAiClassification('transactions');
}

async function handleFilterUpdate(nextFilters: Partial<TransactionFiltersType>) {
    store.setFilters(nextFilters);
    await store.fetchTransactions();
}

async function handleClearFilters() {
    store.clearFilters();
    await store.fetchTransactions();
}

async function handleCategoryUpdate(payload: { transactionId: string; categoryId: string | null }) {
    categoryError.value = null;
    try {
        await store.updateTransactionCategory(payload.transactionId, payload.categoryId);
    } catch (err) {
        categoryError.value = err instanceof Error ? err.message : 'Failed to update category.';
    }
}

function goToLogin() {
    router.push({ name: 'login', query: { redirect: route.fullPath } });
}
</script>

<template>
    <section>
        <div class="flex flex-col gap-6">
            <div class="card">
                <div class="flex flex-col gap-3 md:flex-row md:items-center md:justify-between">
                    <div>
                        <h1 class="font-semibold text-2xl text-surface-900 dark:text-surface-0">Transactions</h1>
                        <p class="text-muted-color mt-1">Review imported transactions from SimpleFIN Bridge.</p>
                    </div>
                    <div class="flex items-center gap-2">
                        <Button
                            icon="pi pi-cog"
                            severity="secondary"
                            outlined
                            aria-label="Transaction tools"
                            :loading="toolsBusy"
                            @click="toggleToolsMenu"
                        />
                        <Menu ref="toolsMenu" :model="toolsMenuItems" :popup="true" />
                        <Button :loading="loading" label="Refresh" icon="pi pi-sync" severity="secondary" @click="store.refreshTransactionsPage" />
                    </div>
                </div>
            </div>

            <TransactionSummaryCards :transactions="transactions" :sync-runs="syncRuns" :loading="loading" />

            <div
                v-if="statusMessage"
                class="rounded-border bg-surface-50 text-surface-700 dark:bg-surface-800 dark:text-surface-200 p-3 text-sm"
            >
                {{ statusMessage }}
            </div>

            <TransactionFilters :filters="filters" :accounts="accounts" :categories="categories" @update="handleFilterUpdate" @clear="handleClearFilters" />

            <div
                v-if="error || categoryError"
                class="rounded-border bg-red-50 text-red-700 dark:bg-red-500/10 dark:text-red-300 p-4 text-sm flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between"
            >
                <span>{{ categoryError || error }}</span>
                <Button v-if="needsLogin" label="Login" icon="pi pi-sign-in" class="whitespace-nowrap" @click="goToLogin" />
            </div>

            <TransactionsTable
                :transactions="transactions"
                :categories="categories"
                :loading="loading"
                :updating-id="updatingCategoryId"
                @update-category="handleCategoryUpdate"
            />
        </div>
    </section>
</template>
