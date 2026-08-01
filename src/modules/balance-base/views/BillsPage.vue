<script setup lang="ts">
import { computed, onMounted, ref } from 'vue';
import { storeToRefs } from 'pinia';
import { useRoute, useRouter } from 'vue-router';
import BillFormDialog from '../components/BillFormDialog.vue';
import BillsList from '../components/BillsList.vue';
import { useBalanceBaseStore } from '../stores/balanceBaseStore';
import type { Bill, BillInput } from '../types/balanceBase.types';

const store = useBalanceBaseStore();
const { bills, billFrequencies, loading, savingBill, error } = storeToRefs(store);
const router = useRouter();
const route = useRoute();

const dialogVisible = ref(false);
const editingBill = ref<Bill | null>(null);
const formError = ref<string | null>(null);

const needsLogin = computed(() => {
    if (!error.value) return false;
    return /sign in/i.test(error.value);
});

onMounted(() => {
    store.refreshBillsPage();
});

function openCreate() {
    editingBill.value = null;
    formError.value = null;
    dialogVisible.value = true;
}

function openEdit(bill: Bill) {
    editingBill.value = bill;
    formError.value = null;
    dialogVisible.value = true;
}

async function handleSave(input: BillInput) {
    formError.value = null;
    try {
        if (editingBill.value) {
            await store.updateBill(editingBill.value.id, input);
        } else {
            await store.createBill(input);
        }
        dialogVisible.value = false;
        editingBill.value = null;
    } catch (err) {
        formError.value = err instanceof Error ? err.message : 'Failed to save bill.';
    }
}

async function handleDelete(bill: Bill) {
    const confirmed = window.confirm(`Delete "${bill.bill_name}"? Linked transaction matches will be cleared.`);
    if (!confirmed) return;

    formError.value = null;
    try {
        await store.deleteBill(bill.id);
    } catch (err) {
        formError.value = err instanceof Error ? err.message : 'Failed to delete bill.';
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
                        <h1 class="font-semibold text-2xl text-surface-900 dark:text-surface-0">Bills</h1>
                        <p class="text-muted-color mt-1">Track recurring and one-off bills before reconciling payments.</p>
                    </div>
                    <Button :loading="loading" label="Refresh" icon="pi pi-sync" severity="secondary" @click="store.refreshBillsPage" />
                </div>
            </div>

            <div
                v-if="error || formError"
                class="rounded-border bg-red-50 text-red-700 dark:bg-red-500/10 dark:text-red-300 p-4 text-sm flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between"
            >
                <span>{{ formError || error }}</span>
                <Button v-if="needsLogin" label="Login" icon="pi pi-sign-in" class="whitespace-nowrap" @click="goToLogin" />
            </div>

            <BillsList
                :bills="bills"
                :loading="loading"
                :saving="savingBill"
                @add="openCreate"
                @edit="openEdit"
                @delete="handleDelete"
            />

            <BillFormDialog
                v-model:visible="dialogVisible"
                :bill="editingBill"
                :frequencies="billFrequencies"
                :saving="savingBill"
                @save="handleSave"
            />
        </div>
    </section>
</template>
