<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue';
import { storeToRefs } from 'pinia';
import { useRoute, useRouter } from 'vue-router';
import { useBalanceBaseStore } from '../stores/balanceBaseStore';
import type { ReconTransaction } from '../types/balanceBase.types';

const store = useBalanceBaseStore();
const {
    reconYear,
    reconMonth,
    reconBills,
    reconUnmatched,
    reconMatched,
    reconExcluded,
    reconHighConfidence,
    loading,
    reconSaving,
    error
} = storeToRefs(store);

const router = useRouter();
const route = useRoute();
const acceptResult = ref<string | null>(null);
const selectedBillByTx = ref<Record<string, string | null>>({});
const focusedBillId = ref<string | null>(null);

const needsLogin = computed(() => Boolean(error.value && /sign in/i.test(error.value)));

const focusedBill = computed(() => reconBills.value.find((bill) => bill.id === focusedBillId.value) || null);

const monthValue = computed({
    get() {
        return `${reconYear.value}-${String(reconMonth.value).padStart(2, '0')}`;
    },
    set(value: string) {
        const [yearRaw, monthRaw] = String(value || '').split('-');
        const year = Number(yearRaw);
        const month = Number(monthRaw);
        if (!Number.isFinite(year) || !Number.isFinite(month)) return;
        store.refreshBillsReconPage(year, month);
    }
});

const highConfidenceCount = computed(
    () => reconUnmatched.value.filter((row) => (row.suggestion?.confidence || 0) >= reconHighConfidence.value).length
);

const focusedMatchedCount = computed(() => {
    if (!focusedBillId.value) return 0;
    return reconMatched.value.filter((row) => row.bill_id === focusedBillId.value).length;
});

function applyRouteFocus() {
    const billId = typeof route.query.billId === 'string' ? route.query.billId : null;
    focusedBillId.value = billId;

    const year = Number(route.query.year);
    const month = Number(route.query.month);
    if (Number.isFinite(year) && Number.isFinite(month) && month >= 1 && month <= 12) {
        return store.refreshBillsReconPage(year, month);
    }
    return store.refreshBillsReconPage();
}

onMounted(() => {
    applyRouteFocus();
});

watch(
    () => [route.query.billId, route.query.year, route.query.month],
    () => {
        applyRouteFocus();
    }
);

function formatCurrency(value: number) {
    return new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(Number(value || 0));
}

function formatDate(value: string) {
    if (!value) return '—';
    return new Intl.DateTimeFormat('en-US', { month: 'short', day: 'numeric', year: 'numeric' }).format(new Date(value));
}

function selectedBillId(row: ReconTransaction) {
    if (Object.prototype.hasOwnProperty.call(selectedBillByTx.value, row.id)) {
        return selectedBillByTx.value[row.id];
    }
    if (focusedBillId.value) return focusedBillId.value;
    return row.suggestion?.bill_id || null;
}

function setSelectedBill(transactionId: string, billId: string | null) {
    selectedBillByTx.value = { ...selectedBillByTx.value, [transactionId]: billId };
}

async function acceptSuggestion(row: ReconTransaction) {
    if (!row.suggestion) return;
    acceptResult.value = null;
    await store.matchReconTransaction(row.id, row.suggestion.bill_id, {
        matchMethod: 'auto',
        confidence: row.suggestion.confidence
    });
}

async function linkSelected(row: ReconTransaction) {
    const billId = selectedBillId(row);
    if (!billId) return;
    acceptResult.value = null;
    await store.matchReconTransaction(row.id, billId, {
        matchMethod: 'manual',
        confidence: 100
    });
}

async function excludeRow(row: ReconTransaction) {
    acceptResult.value = null;
    await store.excludeReconTransaction(row.id);
}

async function unmatchRow(row: ReconTransaction) {
    acceptResult.value = null;
    await store.unmatchReconTransaction(row.id);
}

async function includeRow(row: ReconTransaction) {
    acceptResult.value = null;
    await store.includeReconTransaction(row.id);
}

async function acceptHighConfidence() {
    acceptResult.value = null;
    const result = await store.acceptHighConfidenceReconMatches();
    acceptResult.value = `Accepted ${result.updated} high-confidence matches (${result.examined} examined, threshold ${result.minConfidence}%).`;
}

function clearFocus() {
    focusedBillId.value = null;
    router.replace({ query: { ...route.query, billId: undefined } });
}

function goToLogin() {
    router.push({ name: 'login', query: { redirect: route.fullPath } });
}

function confidenceClass(confidence: number) {
    if (confidence >= reconHighConfidence.value) return 'text-green-700 dark:text-green-300';
    if (confidence >= 50) return 'text-amber-700 dark:text-amber-300';
    return 'text-muted-color';
}
</script>

<template>
    <section>
        <div class="flex flex-col gap-6">
            <div class="card">
                <div class="flex flex-col gap-3 md:flex-row md:items-center md:justify-between">
                    <div>
                        <h1 class="font-semibold text-2xl text-surface-900 dark:text-surface-0">Bills Recon</h1>
                        <p class="text-muted-color mt-1">
                            Review description suggestions, then manually link transactions to bills. Calendar lives on the Dashboard.
                        </p>
                    </div>
                    <div class="flex flex-col sm:flex-row gap-2 sm:items-center">
                        <input
                            v-model="monthValue"
                            type="month"
                            class="rounded-border border border-surface-300 dark:border-surface-600 bg-surface-0 dark:bg-surface-900 px-3 py-2 text-sm"
                        />
                        <Button label="Calendar" icon="pi pi-calendar" severity="secondary" @click="router.push({ name: 'balance-base-dashboard' })" />
                        <Button :loading="loading" label="Refresh" icon="pi pi-sync" severity="secondary" @click="store.refreshBillsReconPage()" />
                    </div>
                </div>
            </div>

            <div
                v-if="error"
                class="rounded-border bg-red-50 text-red-700 dark:bg-red-500/10 dark:text-red-300 p-4 text-sm flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between"
            >
                <span>{{ error }}</span>
                <Button v-if="needsLogin" label="Login" icon="pi pi-sign-in" class="whitespace-nowrap" @click="goToLogin" />
            </div>

            <div v-if="acceptResult" class="rounded-border bg-green-50 text-green-700 dark:bg-green-500/10 dark:text-green-300 p-4 text-sm">
                {{ acceptResult }}
            </div>

            <div
                v-if="focusedBill"
                class="rounded-border bg-blue-50 text-blue-800 dark:bg-blue-500/10 dark:text-blue-200 p-4 text-sm flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between"
            >
                <span>
                    Focusing <strong>{{ focusedBill.bill_name }}</strong>
                    (due {{ focusedBill.due_date || '—' }}) ·
                    {{ focusedMatchedCount ? 'Paid this month' : 'Unpaid this month' }}.
                    Bill is preselected when linking below.
                </span>
                <Button label="Clear focus" size="small" severity="secondary" text @click="clearFocus" />
            </div>

            <div class="card">
                <div class="flex flex-col gap-3 md:flex-row md:items-center md:justify-between">
                    <div>
                        <h3 class="text-lg font-semibold text-surface-900 dark:text-surface-0">Unmatched transactions</h3>
                        <p class="text-muted-color text-sm">
                            {{ reconUnmatched.length }} unmatched · {{ highConfidenceCount }} at ≥{{ reconHighConfidence }}% confidence
                        </p>
                    </div>
                    <Button
                        label="Accept high confidence"
                        icon="pi pi-check-circle"
                        :loading="reconSaving"
                        :disabled="!highConfidenceCount"
                        @click="acceptHighConfidence"
                    />
                </div>

                <div v-if="loading" class="text-muted-color py-8 text-center">Loading recon...</div>
                <div v-else-if="!reconUnmatched.length" class="text-muted-color py-8 text-center">No unmatched transactions for this month.</div>

                <div v-else class="mt-4 overflow-x-auto">
                    <table class="w-full border-collapse">
                        <thead>
                            <tr class="text-left text-muted-color text-sm border-b border-surface-200 dark:border-surface-700">
                                <th class="py-3 pr-4 font-medium">Date</th>
                                <th class="py-3 pr-4 font-medium">Transaction</th>
                                <th class="py-3 pr-4 font-medium">Suggestion</th>
                                <th class="py-3 pr-4 font-medium">Link to bill</th>
                                <th class="py-3 pr-4 font-medium text-right">Amount</th>
                                <th class="py-3 font-medium text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="row in reconUnmatched" :key="row.id" class="border-b border-surface-100 dark:border-surface-800 align-top">
                                <td class="py-3 pr-4 whitespace-nowrap">{{ formatDate(row.date) }}</td>
                                <td class="py-3 pr-4">
                                    <div class="font-medium text-surface-900 dark:text-surface-0">{{ row.description || 'Transaction' }}</div>
                                    <div v-if="row.payee" class="text-muted-color text-sm">{{ row.payee }}</div>
                                </td>
                                <td class="py-3 pr-4 min-w-[12rem]">
                                    <template v-if="row.suggestion">
                                        <div class="font-medium">{{ row.suggestion.bill_name }}</div>
                                        <div class="text-sm font-semibold" :class="confidenceClass(row.suggestion.confidence)">
                                            {{ row.suggestion.confidence }}% confidence
                                        </div>
                                        <div class="text-muted-color text-xs mt-1">{{ row.suggestion.reasons.join(' · ') }}</div>
                                    </template>
                                    <span v-else class="text-muted-color text-sm">No strong match</span>
                                </td>
                                <td class="py-3 pr-4 min-w-[14rem]">
                                    <Select
                                        :model-value="selectedBillId(row)"
                                        :options="reconBills"
                                        option-label="bill_name"
                                        option-value="id"
                                        placeholder="Pick a bill"
                                        show-clear
                                        class="w-full"
                                        :disabled="reconSaving"
                                        @update:model-value="setSelectedBill(row.id, $event)"
                                    />
                                </td>
                                <td class="py-3 pr-4 text-right font-semibold whitespace-nowrap" :class="row.amount < 0 ? 'text-red-500' : 'text-green-500'">
                                    {{ formatCurrency(row.amount) }}
                                </td>
                                <td class="py-3 text-right whitespace-nowrap">
                                    <Button
                                        v-if="row.suggestion"
                                        label="Accept"
                                        size="small"
                                        class="mr-1 mb-1"
                                        :disabled="reconSaving"
                                        @click="acceptSuggestion(row)"
                                    />
                                    <Button
                                        label="Link"
                                        size="small"
                                        severity="secondary"
                                        class="mr-1 mb-1"
                                        :disabled="reconSaving || !selectedBillId(row)"
                                        @click="linkSelected(row)"
                                    />
                                    <Button label="Exclude" size="small" severity="danger" text class="mb-1" :disabled="reconSaving" @click="excludeRow(row)" />
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="card">
                <h3 class="text-lg font-semibold text-surface-900 dark:text-surface-0 mb-1">Matched this month</h3>
                <p class="text-muted-color text-sm mb-4">{{ reconMatched.length }} linked transactions</p>

                <div v-if="!loading && !reconMatched.length" class="text-muted-color py-6 text-center">No matched transactions yet.</div>
                <div v-else-if="reconMatched.length" class="overflow-x-auto">
                    <table class="w-full border-collapse">
                        <thead>
                            <tr class="text-left text-muted-color text-sm border-b border-surface-200 dark:border-surface-700">
                                <th class="py-3 pr-4 font-medium">Date</th>
                                <th class="py-3 pr-4 font-medium">Transaction</th>
                                <th class="py-3 pr-4 font-medium">Bill</th>
                                <th class="py-3 pr-4 font-medium">How</th>
                                <th class="py-3 pr-4 font-medium text-right">Amount</th>
                                <th class="py-3 font-medium text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="row in reconMatched" :key="row.id" class="border-b border-surface-100 dark:border-surface-800">
                                <td class="py-3 pr-4 whitespace-nowrap">{{ formatDate(row.date) }}</td>
                                <td class="py-3 pr-4">
                                    <div class="font-medium text-surface-900 dark:text-surface-0">{{ row.description || 'Transaction' }}</div>
                                </td>
                                <td class="py-3 pr-4">{{ row.bill_name || '—' }}</td>
                                <td class="py-3 pr-4 text-muted-color text-sm">
                                    {{ row.match_method || '—' }}
                                    <span v-if="row.match_confidence != null"> · {{ row.match_confidence }}%</span>
                                </td>
                                <td class="py-3 pr-4 text-right font-semibold whitespace-nowrap">{{ formatCurrency(row.amount) }}</td>
                                <td class="py-3 text-right">
                                    <Button label="Unlink" size="small" severity="secondary" text :disabled="reconSaving" @click="unmatchRow(row)" />
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <div v-if="reconExcluded.length" class="card">
                <h3 class="text-lg font-semibold text-surface-900 dark:text-surface-0 mb-1">Excluded</h3>
                <p class="text-muted-color text-sm mb-4">Hidden from the unmatched queue for this month.</p>
                <div class="overflow-x-auto">
                    <table class="w-full border-collapse">
                        <tbody>
                            <tr v-for="row in reconExcluded" :key="row.id" class="border-b border-surface-100 dark:border-surface-800">
                                <td class="py-3 pr-4 whitespace-nowrap">{{ formatDate(row.date) }}</td>
                                <td class="py-3 pr-4">{{ row.description || 'Transaction' }}</td>
                                <td class="py-3 pr-4 text-right font-semibold">{{ formatCurrency(row.amount) }}</td>
                                <td class="py-3 text-right">
                                    <Button label="Restore" size="small" text :disabled="reconSaving" @click="includeRow(row)" />
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </section>
</template>
