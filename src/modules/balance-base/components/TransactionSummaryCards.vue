<script setup lang="ts">
import { computed } from 'vue';
import type { FinancialTransaction, SyncRun } from '../types/balanceBase.types';

const props = defineProps<{
    transactions: FinancialTransaction[];
    syncRuns: SyncRun[];
    loading?: boolean;
}>();

const totalInflows = computed(() => props.transactions.filter((transaction) => transaction.amount > 0).reduce((sum, transaction) => sum + Number(transaction.amount || 0), 0));
const totalOutflows = computed(() =>
    Math.abs(props.transactions.filter((transaction) => transaction.amount < 0).reduce((sum, transaction) => sum + Number(transaction.amount || 0), 0))
);
const lastSync = computed(() => props.syncRuns[0] || null);

function formatCurrency(value: number) {
    return new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: 'USD'
    }).format(value);
}

function formatDate(value: string | null | undefined) {
    if (!value) return 'Never';
    return new Intl.DateTimeFormat('en-US', {
        month: 'short',
        day: 'numeric',
        hour: 'numeric',
        minute: '2-digit'
    }).format(new Date(value));
}
</script>

<template>
    <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-4">
        <div class="card mb-0">
            <span class="block text-muted-color font-medium mb-2">Total Transactions</span>
            <div class="flex items-center justify-between">
                <div class="text-surface-900 dark:text-surface-0 font-semibold text-2xl">{{ loading ? '-' : transactions.length }}</div>
                <i class="pi pi-list text-primary text-xl" />
            </div>
        </div>

        <div class="card mb-0">
            <span class="block text-muted-color font-medium mb-2">Total Inflows</span>
            <div class="flex items-center justify-between">
                <div class="text-green-500 font-semibold text-2xl">{{ loading ? '-' : formatCurrency(totalInflows) }}</div>
                <i class="pi pi-arrow-down-left text-green-500 text-xl" />
            </div>
        </div>

        <div class="card mb-0">
            <span class="block text-muted-color font-medium mb-2">Total Outflows</span>
            <div class="flex items-center justify-between">
                <div class="text-red-500 font-semibold text-2xl">{{ loading ? '-' : formatCurrency(totalOutflows) }}</div>
                <i class="pi pi-arrow-up-right text-red-500 text-xl" />
            </div>
        </div>

        <div class="card mb-0">
            <span class="block text-muted-color font-medium mb-2">Last Sync</span>
            <div class="text-surface-900 dark:text-surface-0 font-semibold text-xl">{{ formatDate(lastSync?.finished_at || lastSync?.started_at) }}</div>
            <span class="text-muted-color text-sm">{{ lastSync?.status || 'No sync runs yet' }}</span>
        </div>
    </div>
</template>
