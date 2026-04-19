<script setup>
import CreditScoreWidget from '@/components/dashboard/banking/CreditScoreWidget.vue';
import CurrencyCardWidget from '@/components/dashboard/banking/CurrencyCardWidget.vue';
import IncomeExpenditureWidget from '@/components/dashboard/banking/IncomeExpenditureWidget.vue';
import SpendingLimitWidget from '@/components/dashboard/banking/SpendingLimitWidget.vue';
import TransactionsHistoryWidget from '@/components/dashboard/banking/TransactionsHistoryWidget.vue';
</script>

<template>
    <section>
        <div class="flex flex-col gap-7">
            <div class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-7">
                <CurrencyCardWidget />
            </div>
            <div class="w-full flex xl:flex-row flex-col gap-6">
                <IncomeExpenditureWidget />
                <SpendingLimitWidget />
            </div>
            <div class="flex xl:flex-row flex-col gap-6">
                <CreditScoreWidget />
                <TransactionsHistoryWidget />
            </div>
        </div>
    </section>
</template>
