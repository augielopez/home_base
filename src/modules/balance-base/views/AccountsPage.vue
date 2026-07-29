<script setup lang="ts">
import { onMounted } from 'vue';
import { storeToRefs } from 'pinia';
import AccountsTable from '../components/AccountsTable.vue';
import { useBalanceBaseStore } from '../stores/balanceBaseStore';

const store = useBalanceBaseStore();
const { accounts, loading, error } = storeToRefs(store);

onMounted(() => {
    store.refreshAccountsPage();
});
</script>

<template>
    <section>
        <div class="flex flex-col gap-6">
            <div class="card">
                <div class="flex flex-col gap-3 md:flex-row md:items-center md:justify-between">
                    <div>
                        <h1 class="font-semibold text-2xl text-surface-900 dark:text-surface-0">Accounts</h1>
                        <p class="text-muted-color mt-1">Balances for each account synced from SimpleFIN Bridge.</p>
                    </div>
                    <Button :loading="loading" label="Refresh" icon="pi pi-sync" severity="secondary" @click="store.refreshAccountsPage" />
                </div>
            </div>

            <div v-if="error" class="rounded-border bg-red-50 text-red-700 dark:bg-red-500/10 dark:text-red-300 p-4 text-sm">
                {{ error }}
            </div>

            <AccountsTable :accounts="accounts" :loading="loading" />
        </div>
    </section>
</template>
