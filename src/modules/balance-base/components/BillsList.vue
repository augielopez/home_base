<script setup lang="ts">
import { computed, ref } from 'vue';
import type { Bill } from '../types/balanceBase.types';

const props = defineProps<{
    bills: Bill[];
    loading?: boolean;
    saving?: boolean;
}>();

const emit = defineEmits<{
    add: [];
    edit: [bill: Bill];
    delete: [bill: Bill];
}>();

const search = ref('');
const statusFilter = ref<'all' | 'Active' | 'Inactive'>('all');

const filteredBills = computed(() => {
    const query = search.value.trim().toLowerCase();
    return props.bills.filter((bill) => {
        if (statusFilter.value !== 'all' && bill.status !== statusFilter.value) return false;
        if (!query) return true;
        return [bill.bill_name, bill.description, bill.due_date, bill.frequency_name, bill.status]
            .filter(Boolean)
            .some((value) => String(value).toLowerCase().includes(query));
    });
});

const activeTotal = computed(() =>
    filteredBills.value
        .filter((bill) => bill.status === 'Active')
        .reduce((sum, bill) => sum + (bill.amount_due ?? 0), 0)
);

function formatCurrency(value: number | null) {
    if (value === null || typeof value === 'undefined') return '—';
    return new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(Number(value));
}

function statusClass(status: string) {
    if (status === 'Active') return 'bg-green-50 text-green-700 dark:bg-green-500/10 dark:text-green-300';
    if (status === 'Inactive') return 'bg-surface-100 text-surface-600 dark:bg-surface-800 dark:text-surface-300';
    return 'bg-surface-100 text-surface-600 dark:bg-surface-800 dark:text-surface-300';
}
</script>

<template>
    <div class="card">
        <div class="flex flex-col gap-4 md:flex-row md:items-center md:justify-between mb-4">
            <div>
                <h3 class="text-lg font-semibold text-surface-900 dark:text-surface-0">Bills</h3>
                <p class="text-muted-color text-sm">
                    {{ filteredBills.length }} shown
                    <span v-if="activeTotal"> · Active total {{ formatCurrency(activeTotal) }}</span>
                </p>
            </div>
            <Button label="Add Bill" icon="pi pi-plus" class="whitespace-nowrap" @click="emit('add')" />
        </div>

        <div class="flex flex-col gap-3 sm:flex-row sm:items-center mb-4">
            <InputText v-model="search" placeholder="Search bills" class="w-full sm:max-w-xs" />
            <Select
                v-model="statusFilter"
                :options="[
                    { label: 'All statuses', value: 'all' },
                    { label: 'Active', value: 'Active' },
                    { label: 'Inactive', value: 'Inactive' }
                ]"
                option-label="label"
                option-value="value"
                class="w-full sm:w-48"
            />
        </div>

        <div v-if="loading" class="text-muted-color py-8 text-center">Loading bills...</div>
        <div v-else-if="!filteredBills.length" class="text-muted-color py-8 text-center">No bills found.</div>

        <div v-else class="overflow-x-auto">
            <table class="w-full border-collapse">
                <thead>
                    <tr class="text-left text-muted-color text-sm border-b border-surface-200 dark:border-surface-700">
                        <th class="py-3 pr-4 font-medium">Bill</th>
                        <th class="py-3 pr-4 font-medium">Due</th>
                        <th class="py-3 pr-4 font-medium">Frequency</th>
                        <th class="py-3 pr-4 font-medium">Status</th>
                        <th class="py-3 pr-4 font-medium text-right">Amount</th>
                        <th class="py-3 font-medium text-right">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="bill in filteredBills" :key="bill.id" class="border-b border-surface-100 dark:border-surface-800">
                        <td class="py-3 pr-4">
                            <div class="font-medium text-surface-900 dark:text-surface-0">{{ bill.bill_name }}</div>
                            <div v-if="bill.description" class="text-muted-color text-sm mt-0.5 line-clamp-1">{{ bill.description }}</div>
                            <div v-if="bill.is_fixed_bill" class="text-xs text-muted-color mt-1">Fixed amount</div>
                        </td>
                        <td class="py-3 pr-4 text-muted-color whitespace-nowrap">{{ bill.due_date || '—' }}</td>
                        <td class="py-3 pr-4 text-muted-color">{{ bill.frequency_name || '—' }}</td>
                        <td class="py-3 pr-4">
                            <span class="inline-flex rounded-border px-2 py-0.5 text-xs font-medium" :class="statusClass(bill.status)">
                                {{ bill.status }}
                            </span>
                        </td>
                        <td class="py-3 pr-4 text-right font-semibold text-surface-900 dark:text-surface-0 whitespace-nowrap">
                            {{ formatCurrency(bill.amount_due) }}
                        </td>
                        <td class="py-3 text-right whitespace-nowrap">
                            <Button
                                icon="pi pi-pencil"
                                severity="secondary"
                                text
                                rounded
                                aria-label="Edit bill"
                                :disabled="saving"
                                @click="emit('edit', bill)"
                            />
                            <Button
                                icon="pi pi-trash"
                                severity="danger"
                                text
                                rounded
                                aria-label="Delete bill"
                                :disabled="saving"
                                @click="emit('delete', bill)"
                            />
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</template>
