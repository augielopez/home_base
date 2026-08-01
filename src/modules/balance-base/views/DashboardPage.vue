<script setup lang="ts">
import { computed, onMounted, ref } from 'vue';
import { storeToRefs } from 'pinia';
import { useRoute, useRouter } from 'vue-router';
import BillsCalendar from '../components/BillsCalendar.vue';
import { useBalanceBaseStore } from '../stores/balanceBaseStore';
import type { Bill } from '../types/balanceBase.types';

const store = useBalanceBaseStore();
const { reconYear, reconMonth, reconBills, reconMatched, loading, error } = storeToRefs(store);
const router = useRouter();
const route = useRoute();

const needsLogin = computed(() => Boolean(error.value && /sign in/i.test(error.value)));

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

onMounted(() => {
    store.refreshBillsReconPage();
});

function goToLogin() {
    router.push({ name: 'login', query: { redirect: route.fullPath } });
}

function onSelectBill(bill: Bill) {
    router.push({
        name: 'balance-base-bills-recon',
        query: { billId: bill.id, year: String(reconYear.value), month: String(reconMonth.value) }
    });
}
</script>

<template>
    <section>
        <div class="flex flex-col gap-6">
            <div class="card">
                <div class="flex flex-col gap-3 md:flex-row md:items-center md:justify-between">
                    <div>
                        <h1 class="font-semibold text-2xl text-surface-900 dark:text-surface-0">Balance Base</h1>
                        <p class="text-muted-color mt-1">Paid vs unpaid bills for the month at a glance.</p>
                    </div>
                    <div class="flex flex-col sm:flex-row gap-2 sm:items-center">
                        <input
                            v-model="monthValue"
                            type="month"
                            class="rounded-border border border-surface-300 dark:border-surface-600 bg-surface-0 dark:bg-surface-900 px-3 py-2 text-sm"
                        />
                        <Button :loading="loading" label="Refresh" icon="pi pi-sync" severity="secondary" @click="store.refreshBillsReconPage()" />
                        <Button label="Open Recon" icon="pi pi-check-square" @click="router.push({ name: 'balance-base-bills-recon' })" />
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

            <BillsCalendar
                :year="reconYear"
                :month="reconMonth"
                :bills="reconBills"
                :matched="reconMatched"
                :loading="loading"
                @select-bill="onSelectBill"
            />
        </div>
    </section>
</template>
