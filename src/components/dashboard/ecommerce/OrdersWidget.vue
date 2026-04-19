<script setup>
import { ref } from 'vue';

const orders = ref([
    { title: 'iPhone 15 Pro 1T', date: 'Feb 20, 2024', image: '/demo/images/dashboard/order-1.png', status: 'pending', id: '3543867' },
    { title: 'iPhone 13 Pro 256GB', date: 'Feb 16, 2024', image: '/demo/images/dashboard/order-2.png', status: 'pending', id: '6243789' },
    { title: 'Apple Watch 7 41mm', date: 'Feb 11, 2024', image: '/demo/images/dashboard/order-3.png', status: 'sent', id: '9763474' },
    { title: 'AirPods Pro', date: 'Feb 09, 2024', image: '/demo/images/dashboard/order-4.png', status: 'sent', id: '2538268' },
    { title: 'Apple Watch 8 44mm', date: 'Feb 08, 2024', image: '/demo/images/dashboard/order-5.png', status: 'sent', id: '9572345' },
    { title: 'iPhone 13 Pro 128GB', date: 'Feb 07, 2024', image: '/demo/images/dashboard/order-6.png', status: 'sent', id: '12471247' }
]);
</script>

<template>
    <div class="card !mb-0 flex-1 min-w-[25rem] !p-6 border border-surface rounded-2xl">
        <div class="flex items-center justify-between">
            <span class="label-medium text-surface-950 dark:text-surface-0">Orders</span>
            <Button
                label="See All"
                severity="secondary"
                outlined
                icon="pi pi-chevron-right"
                iconPos="right"
                class="!text-surface-950 dark:!text-surface-0 !px-2 !py-1.5 !rounded-lg !label-xsmall"
                :pt="{
                    icon: {
                        class: '!text-xs'
                    }
                }"
            />
        </div>
        <div class="flex flex-col mt-8">
            <template v-for="(item, index) of orders" :key="index">
                <div class="flex items-center gap-2">
                    <img class="w-13 h-13 rounded-lg object-cover border border-surface-200 dark:border-surface-800" :src="item.image" alt="Order Image" />
                    <div class="flex-1">
                        <div class="label-small text-left text-surface-950 dark:text-surface-0">{{ item.title }}</div>
                        <time class="mt-1 body-xsmall">{{ item.date }}</time>
                    </div>
                    <div class="flex flex-col items-end">
                        <Tag
                            :severity="item.status === 'pending' ? 'warn' : 'success'"
                            :value="item.status"
                            :pt="{
                                root: {
                                    class: '!py-0.5 !px-2'
                                },
                                label: {
                                    class: '!text-sm !font-semibold !leading-normal !capitalize'
                                }
                            }"
                        />
                        <span class="mt-1 body-xsmall">{{ item.id }}</span>
                    </div>
                </div>
                <Divider v-if="index < orders.length - 1" class="my-3.5" />
            </template>
        </div>
    </div>
</template>
