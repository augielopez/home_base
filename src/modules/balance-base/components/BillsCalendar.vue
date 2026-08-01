<script setup lang="ts">
import { computed } from 'vue';
import type { Bill, ReconTransaction } from '../types/balanceBase.types';
import { buildCalendarBillItems, buildMonthGrid, type CalendarBillItem } from '../utils/billDueDate';

const props = defineProps<{
    year: number;
    month: number;
    bills: Bill[];
    matched: ReconTransaction[];
    loading?: boolean;
}>();

const emit = defineEmits<{
    selectBill: [bill: Bill];
}>();

const monthLabel = computed(() =>
    new Intl.DateTimeFormat('en-US', { month: 'long', year: 'numeric' }).format(new Date(props.year, props.month - 1, 1))
);

const grid = computed(() => buildMonthGrid(props.year, props.month));

const calendarData = computed(() => buildCalendarBillItems(props.bills, props.matched, props.year, props.month));

function countByStatus(status: CalendarBillItem['status']) {
    const seen = new Set<string>();
    let count = 0;
    const visit = (item: CalendarBillItem) => {
        if (seen.has(item.bill.id)) return;
        seen.add(item.bill.id);
        if (item.status === status) count += 1;
    };
    for (const items of Object.values(calendarData.value.byDay)) {
        for (const item of items) visit(item);
    }
    for (const item of calendarData.value.unscheduled) visit(item);
    return count;
}

const paidCount = computed(() => countByStatus('paid'));
const amberCount = computed(() => countByStatus('amber'));
const unpaidCount = computed(() => countByStatus('unpaid'));

function formatCurrency(value: number | null) {
    if (value == null) return '';
    return new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: 'USD',
        maximumFractionDigits: 0
    }).format(Number(value));
}

function chipClass(item: CalendarBillItem) {
    if (item.status === 'paid') {
        return 'bg-green-100 text-green-800 border-green-200 dark:bg-green-500/20 dark:text-green-200 dark:border-green-500/30';
    }
    if (item.status === 'amber') {
        return 'bg-amber-100 text-amber-900 border-amber-200 dark:bg-amber-500/20 dark:text-amber-200 dark:border-amber-500/30';
    }
    return 'bg-red-100 text-red-800 border-red-200 dark:bg-red-500/20 dark:text-red-200 dark:border-red-500/30';
}

function statusLabel(item: CalendarBillItem) {
    if (item.status === 'paid') return 'Paid';
    if (item.status === 'amber') return item.warnings.length ? `Review: ${item.warnings.join('; ')}` : 'Needs review';
    return 'Unpaid';
}

function itemsForDay(day: number | null) {
    if (!day) return [];
    return calendarData.value.byDay[day] || [];
}
</script>

<template>
    <div class="card">
        <div class="flex flex-col gap-2 sm:flex-row sm:items-end sm:justify-between mb-4">
            <div>
                <h3 class="text-lg font-semibold text-surface-900 dark:text-surface-0">Bills calendar</h3>
                <p class="text-muted-color text-sm">
                    {{ monthLabel }} ·
                    <span class="text-green-700 dark:text-green-300">{{ paidCount }} paid</span>
                    ·
                    <span class="text-amber-700 dark:text-amber-300">{{ amberCount }} review</span>
                    ·
                    <span class="text-red-700 dark:text-red-300">{{ unpaidCount }} unpaid</span>
                </p>
            </div>
            <div class="flex flex-wrap items-center gap-3 text-xs">
                <span class="inline-flex items-center gap-1.5">
                    <span class="h-2.5 w-2.5 rounded-full bg-green-500"></span> Paid (amount + date OK)
                </span>
                <span class="inline-flex items-center gap-1.5">
                    <span class="h-2.5 w-2.5 rounded-full bg-amber-500"></span> Matched, amount/date off
                </span>
                <span class="inline-flex items-center gap-1.5">
                    <span class="h-2.5 w-2.5 rounded-full bg-red-500"></span> Unpaid
                </span>
            </div>
        </div>

        <div v-if="loading" class="text-muted-color py-8 text-center">Loading calendar...</div>

        <template v-else>
            <div class="grid grid-cols-7 gap-1 text-xs text-muted-color mb-1">
                <div v-for="label in ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']" :key="label" class="px-1 py-1 font-medium">
                    {{ label }}
                </div>
            </div>

            <div class="grid grid-cols-7 gap-1">
                <div
                    v-for="(cell, index) in grid"
                    :key="`${year}-${month}-${index}`"
                    class="min-h-24 rounded-border border border-surface-200 dark:border-surface-700 p-1.5"
                    :class="cell.day ? 'bg-surface-0 dark:bg-surface-900' : 'bg-surface-50 dark:bg-surface-800/40'"
                >
                    <div v-if="cell.day" class="text-xs font-medium text-surface-700 dark:text-surface-200 mb-1">{{ cell.day }}</div>
                    <div class="flex flex-col gap-1">
                        <button
                            v-for="item in itemsForDay(cell.day)"
                            :key="`${item.bill.id}-${item.day}`"
                            type="button"
                            class="w-full text-left rounded-border border px-1.5 py-1 text-[11px] leading-tight hover:opacity-90"
                            :class="chipClass(item)"
                            :title="`${item.bill.bill_name} · due ${item.bill.due_date || '—'} · ${statusLabel(item)}`"
                            @click="emit('selectBill', item.bill)"
                        >
                            <div class="font-semibold truncate">{{ item.bill.bill_name }}</div>
                            <div v-if="item.bill.amount_due != null" class="opacity-80">{{ formatCurrency(item.bill.amount_due) }}</div>
                        </button>
                    </div>
                </div>
            </div>

            <div v-if="calendarData.unscheduled.length" class="mt-4">
                <h4 class="text-sm font-semibold text-surface-900 dark:text-surface-0 mb-2">Unscheduled / unclear due date</h4>
                <div class="flex flex-wrap gap-2">
                    <button
                        v-for="item in calendarData.unscheduled"
                        :key="item.bill.id"
                        type="button"
                        class="rounded-border border px-2 py-1 text-xs"
                        :class="chipClass(item)"
                        :title="statusLabel(item)"
                        @click="emit('selectBill', item.bill)"
                    >
                        {{ item.bill.bill_name }}
                        <span v-if="item.bill.due_date" class="opacity-70"> · {{ item.bill.due_date }}</span>
                    </button>
                </div>
            </div>
        </template>
    </div>
</template>
