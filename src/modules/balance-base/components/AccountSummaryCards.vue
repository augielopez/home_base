<script setup lang="ts">
import TransactionSummaryCards from './TransactionSummaryCards.vue';
import type { FinancialTransaction, SyncRun } from '../types/balanceBase.types';

defineProps<{
    transactions?: FinancialTransaction[];
    syncRuns?: SyncRun[];
    loading?: boolean;
}>();
</script>

<template>
    <TransactionSummaryCards :transactions="transactions || []" :sync-runs="syncRuns || []" :loading="loading" />
</template>
