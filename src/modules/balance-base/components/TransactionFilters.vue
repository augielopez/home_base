<script setup lang="ts">
import type { FinancialAccount, TransactionCategory, TransactionFilters } from '../types/balanceBase.types';

defineProps<{
    filters: TransactionFilters;
    accounts: FinancialAccount[];
    categories: TransactionCategory[];
}>();

const emit = defineEmits<{
    update: [filters: Partial<TransactionFilters>];
    clear: [];
}>();

function updateFilter<K extends keyof TransactionFilters>(key: K, value: TransactionFilters[K]) {
    emit('update', { [key]: value } as Partial<TransactionFilters>);
}

function inputValue(event: Event) {
    return (event.target as HTMLInputElement | HTMLSelectElement).value;
}
</script>

<template>
    <div class="card">
        <div class="flex items-center justify-between mb-4">
            <div>
                <h3 class="text-lg font-semibold text-surface-900 dark:text-surface-0">Filters</h3>
                <p class="text-muted-color text-sm">Narrow transactions by account, category, and date.</p>
            </div>
            <Button label="Clear" severity="secondary" text @click="emit('clear')" />
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-4">
            <label class="flex flex-col gap-2">
                <span class="text-sm font-medium text-surface-900 dark:text-surface-0">Search</span>
                <InputText :model-value="filters.search" placeholder="Description, payee" @update:model-value="updateFilter('search', String($event || ''))" />
            </label>

            <label class="flex flex-col gap-2">
                <span class="text-sm font-medium text-surface-900 dark:text-surface-0">Account</span>
                <select class="p-inputtext p-component w-full" :value="filters.accountId || ''" @change="updateFilter('accountId', inputValue($event) || null)">
                    <option value="">All accounts</option>
                    <option v-for="account in accounts" :key="account.id" :value="account.simplefin_account_id || account.id">
                        {{ account.name }}
                    </option>
                </select>
            </label>

            <label class="flex flex-col gap-2">
                <span class="text-sm font-medium text-surface-900 dark:text-surface-0">Category</span>
                <select class="p-inputtext p-component w-full" :value="filters.categoryId || ''" @change="updateFilter('categoryId', inputValue($event) || null)">
                    <option value="">All categories</option>
                    <option value="uncategorized">Uncategorized</option>
                    <option v-for="category in categories" :key="category.id" :value="category.id">{{ category.name }}</option>
                </select>
            </label>

            <label class="flex flex-col gap-2">
                <span class="text-sm font-medium text-surface-900 dark:text-surface-0">Start Date</span>
                <input class="p-inputtext p-component w-full" type="date" :value="filters.startDate || ''" @input="updateFilter('startDate', inputValue($event) || null)" />
            </label>

            <label class="flex flex-col gap-2">
                <span class="text-sm font-medium text-surface-900 dark:text-surface-0">End Date</span>
                <input class="p-inputtext p-component w-full" type="date" :value="filters.endDate || ''" @input="updateFilter('endDate', inputValue($event) || null)" />
            </label>
        </div>
    </div>
</template>
