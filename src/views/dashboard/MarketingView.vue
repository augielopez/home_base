<script setup>
import FollowerAnalyticsWidget from '@/components/dashboard/marketing/FollowerAnalyticsWidget.vue';
import OrderHistoryWidget from '@/components/dashboard/marketing/OrderHistoryWidget.vue';
import SalesOverviewWidget from '@/components/dashboard/marketing/SalesOverviewWidget.vue';
import StatCardWidget from '@/components/dashboard/marketing/StatCardWidget.vue';
</script>

<template>
    <section class="flex flex-col [&>*]:py-8 [&>*:first-child]:pt-0! [&>*:last-child]:pb-0! divide-y divide-[var(--surface-border)]">
        <div class="grid grid-cols-1 xl:grid-cols-3 divide-y xl:divide-y-0 xl:divide-x divide-[var(--surface-border)]">
            <StatCardWidget />
        </div>
        <div class="flex xl:flex-row flex-col xl:divide-y-0 divide-y xl:divide-x divide-[var(--surface-border)]">
            <SalesOverviewWidget />
            <FollowerAnalyticsWidget />
        </div>
        <OrderHistoryWidget />
    </section>
</template>
