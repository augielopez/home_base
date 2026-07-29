<script setup lang="ts">
import { computed, onMounted, ref } from 'vue';
import { storeToRefs } from 'pinia';
import { useRoute, useRouter } from 'vue-router';
import SyncTransactionsButton from '../components/SyncTransactionsButton.vue';
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
    updatingCategoryId,
    error,
    lastSyncResult,
    lastCategorizeResult,
    filters
} = storeToRefs(store);
const router = useRouter();
const route = useRoute();
const categoryError = ref<string | null>(null);

const needsLogin = computed(() => {
    if (!error.value) return false;
    return /sign in/i.test(error.value);
});

onMounted(() => {
    store.refreshTransactionsPage();
});

async function handleSync() {
    await store.syncSimplefin();
}

async function handleApplyRules() {
    await store.applyCategoryRules();
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
                    <Button :loading="loading" label="Refresh" icon="pi pi-sync" severity="secondary" @click="store.refreshTransactionsPage" />
                </div>
            </div>

            <TransactionSummaryCards :transactions="transactions" :sync-runs="syncRuns" :loading="loading" />

            <SyncTransactionsButton
                :syncing="syncing"
                :categorizing="categorizing"
                :error="error"
                :last-sync-result="lastSyncResult"
                :last-categorize-result="lastCategorizeResult"
                @sync="handleSync"
                @apply-rules="handleApplyRules"
            />

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
