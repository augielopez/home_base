<script setup>
import MiniStatCardWidget from '@/components/dashboard/ecommerce/MiniStatCardWidget.vue';
import OrdersWidget from '@/components/dashboard/ecommerce/OrdersWidget.vue';
import OverviewWidget from '@/components/dashboard/ecommerce/OverviewWidget.vue';
import SocialMediaRevenueWidget from '@/components/dashboard/ecommerce/SocialMediaRevenueWidget.vue';
import SocialMediaUsersWidget from '@/components/dashboard/ecommerce/SocialMediaUsersWidget.vue';
</script>

<template>
    <section>
        <div class="flex flex-col gap-7">
            <div class="flex flex-wrap gap-7">
                <MiniStatCardWidget />
            </div>
            <OverviewWidget />
            <div class="flex flex-wrap gap-7">
                <SocialMediaUsersWidget />
                <OrdersWidget />
                <SocialMediaRevenueWidget />
            </div>
        </div>
    </section>
</template>
