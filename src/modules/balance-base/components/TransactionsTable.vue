<script setup lang="ts">
import type { FinancialTransaction, TransactionCategory } from '../types/balanceBase.types';

defineProps<{
    transactions: FinancialTransaction[];
    categories: TransactionCategory[];
    loading?: boolean;
    updatingId?: string | null;
}>();

const emit = defineEmits<{
    updateCategory: [payload: { transactionId: string; categoryId: string | null }];
}>();

function formatDate(value: string | null) {
    if (!value) return '-';
    return new Intl.DateTimeFormat('en-US', { month: 'short', day: 'numeric', year: 'numeric' }).format(new Date(value));
}

function formatCurrency(value: number, currency = 'USD') {
    return new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency
    }).format(Number(value || 0));
}

function onCategoryChange(transactionId: string, categoryId: string | null) {
    emit('updateCategory', { transactionId, categoryId: categoryId || null });
}

function matchMethodLabel(method: string | null | undefined) {
    const value = String(method || '').toLowerCase();
    if (value === 'manual') return 'Manual';
    if (value === 'auto') return 'Rules';
    if (value === 'ai') return 'AI';
    return null;
}

function matchMethodClass(method: string | null | undefined) {
    const value = String(method || '').toLowerCase();
    if (value === 'manual') return 'bg-surface-100 text-surface-700 dark:bg-surface-800 dark:text-surface-200';
    if (value === 'auto') return 'bg-blue-50 text-blue-700 dark:bg-blue-500/10 dark:text-blue-300';
    if (value === 'ai') return 'bg-violet-50 text-violet-700 dark:bg-violet-500/10 dark:text-violet-300';
    return '';
}
</script>

<template>
    <div class="card">
        <div class="flex items-center justify-between mb-4">
            <div>
                <h3 class="text-lg font-semibold text-surface-900 dark:text-surface-0">Recent Transactions</h3>
                <p class="text-muted-color text-sm">Latest activity imported from SimpleFIN Bridge.</p>
            </div>
        </div>

        <div v-if="loading" class="text-muted-color py-8 text-center">Loading transactions...</div>
        <div v-else-if="!transactions.length" class="text-muted-color py-8 text-center">No transactions synced yet.</div>

        <div v-else class="overflow-x-auto">
            <table class="w-full border-collapse">
                <thead>
                    <tr class="text-left text-muted-color text-sm border-b border-surface-200 dark:border-surface-700">
                        <th class="py-3 pr-4 font-medium">Date</th>
                        <th class="py-3 pr-4 font-medium">Description</th>
                        <th class="py-3 pr-4 font-medium">Payee</th>
                        <th class="py-3 pr-4 font-medium">Account</th>
                        <th class="py-3 pr-4 font-medium">Category</th>
                        <th class="py-3 text-right font-medium">Amount</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="transaction in transactions" :key="transaction.id" class="border-b border-surface-100 dark:border-surface-800">
                        <td class="py-3 pr-4 whitespace-nowrap">{{ formatDate(transaction.posted_date) }}</td>
                        <td class="py-3 pr-4">
                            <div class="font-medium text-surface-900 dark:text-surface-0">{{ transaction.description || 'Transaction' }}</div>
                        </td>
                        <td class="py-3 pr-4 text-muted-color">{{ transaction.payee || '-' }}</td>
                        <td class="py-3 pr-4 text-muted-color">{{ transaction.account?.name || '-' }}</td>
                        <td class="py-3 pr-4 min-w-[14rem]">
                            <div class="flex flex-col gap-1.5">
                                <Select
                                    :model-value="transaction.category_id"
                                    :options="categories"
                                    option-label="name"
                                    option-value="id"
                                    placeholder="Uncategorized"
                                    show-clear
                                    class="w-full"
                                    :disabled="updatingId === transaction.id"
                                    :loading="updatingId === transaction.id"
                                    @update:model-value="onCategoryChange(transaction.id, $event)"
                                />
                                <span
                                    v-if="matchMethodLabel(transaction.category_match_method) && transaction.category_id"
                                    class="inline-flex w-fit rounded-border px-1.5 py-0.5 text-[11px] font-medium"
                                    :class="matchMethodClass(transaction.category_match_method)"
                                    :title="
                                        transaction.category_confidence != null
                                            ? `Confidence ${Math.round(Number(transaction.category_confidence) * 100)}%`
                                            : undefined
                                    "
                                >
                                    {{ matchMethodLabel(transaction.category_match_method) }}
                                </span>
                            </div>
                        </td>
                        <td class="py-3 text-right font-semibold" :class="transaction.amount < 0 ? 'text-red-500' : 'text-green-500'">
                            {{ formatCurrency(transaction.amount, transaction.account?.currency || 'USD') }}
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</template>
