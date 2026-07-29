<script setup lang="ts">
import { computed } from 'vue';
import type { FinancialAccount } from '../types/balanceBase.types';

const props = defineProps<{
    accounts: FinancialAccount[];
    loading?: boolean;
}>();

const totalBalance = computed(() =>
    props.accounts.reduce((sum, account) => sum + (account.balance ?? 0), 0)
);

function formatCurrency(value: number | null, currency = 'USD') {
    if (value === null || typeof value === 'undefined') return '—';
    return new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency
    }).format(Number(value));
}

function formatBalanceDate(value: string | null) {
    if (!value) return '—';
    const date = new Date(value);
    if (Number.isNaN(date.getTime())) return '—';
    return new Intl.DateTimeFormat('en-US', { month: 'short', day: 'numeric', year: 'numeric' }).format(date);
}
</script>

<template>
    <div class="card">
        <div class="flex items-center justify-between mb-4">
            <div>
                <h3 class="text-lg font-semibold text-surface-900 dark:text-surface-0">Account Balances</h3>
                <p class="text-muted-color text-sm">Balances from the latest SimpleFIN sync.</p>
            </div>
        </div>

        <div v-if="loading" class="text-muted-color py-8 text-center">Loading accounts...</div>
        <div v-else-if="!accounts.length" class="text-muted-color py-8 text-center">No accounts synced yet. Run SimpleFIN Sync from Transactions.</div>

        <div v-else class="overflow-x-auto">
            <table class="w-full border-collapse">
                <thead>
                    <tr class="text-left text-muted-color text-sm border-b border-surface-200 dark:border-surface-700">
                        <th class="py-3 pr-4 font-medium">Account</th>
                        <th class="py-3 pr-4 font-medium">Bank</th>
                        <th class="py-3 pr-4 font-medium">Type</th>
                        <th class="py-3 pr-4 font-medium text-right">Balance</th>
                        <th class="py-3 pr-4 font-medium text-right">Available</th>
                        <th class="py-3 font-medium text-right">As of</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="account in accounts" :key="account.id" class="border-b border-surface-100 dark:border-surface-800">
                        <td class="py-3 pr-4">
                            <div class="font-medium text-surface-900 dark:text-surface-0">{{ account.name }}</div>
                        </td>
                        <td class="py-3 pr-4 text-muted-color">{{ account.bank_name || '—' }}</td>
                        <td class="py-3 pr-4 text-muted-color capitalize">{{ account.account_type || '—' }}</td>
                        <td class="py-3 pr-4 text-right font-semibold text-surface-900 dark:text-surface-0">
                            {{ formatCurrency(account.balance, account.currency) }}
                        </td>
                        <td class="py-3 pr-4 text-right text-muted-color">
                            {{ formatCurrency(account.available_balance, account.currency) }}
                        </td>
                        <td class="py-3 text-right text-muted-color whitespace-nowrap">
                            {{ formatBalanceDate(account.balance_date) }}
                        </td>
                    </tr>
                </tbody>
                <tfoot>
                    <tr class="border-t border-surface-200 dark:border-surface-700">
                        <td class="py-3 pr-4 font-semibold text-surface-900 dark:text-surface-0" colspan="3">Total</td>
                        <td class="py-3 pr-4 text-right font-semibold text-surface-900 dark:text-surface-0">
                            {{ formatCurrency(totalBalance, accounts[0]?.currency || 'USD') }}
                        </td>
                        <td class="py-3 pr-4" colspan="2"></td>
                    </tr>
                </tfoot>
            </table>
        </div>
    </div>
</template>
