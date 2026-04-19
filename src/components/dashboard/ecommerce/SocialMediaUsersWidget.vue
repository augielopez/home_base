<script setup>
import { useLayout } from '@/layout/composables/layout';
import { generateRandomMultiData } from '@/lib/utils';
import { onBeforeMount, ref } from 'vue';
import MeterChart from '../charts/MeterChart.vue';

defineProps({
    class: {
        type: String,
        default: ''
    }
});

const randomData = ref(null);
const computedData = ref(null);
const bgColors = ['var(--p-primary-color)'];
const dataLabels = [
    { title: 'Facebook', logo: '/demo/images/dashboard/logo-facebook.svg' },
    { title: 'Instagram', logo: '/demo/images/dashboard/logo-instagram.svg' },
    { title: 'X.com', logo: '/demo/images/dashboard/logo-x.svg', darkLogo: '/demo/images/dashboard/logo-x-dark.svg' },
    { title: 'Reddit', logo: '/demo/images/dashboard/logo-reddit.svg' }
];
const { isDarkTheme } = useLayout();
function handleComputedValue(value) {
    if (value.length === 0) return [];

    const result = new Array(value[0].y.length).fill(0);

    value.forEach((item) => {
        item.y.forEach((val, index) => {
            result[index] += val;
        });
    });
    computedData.value = result;
}

onBeforeMount(() => {
    randomData.value = generateRandomMultiData('2020-10-27T00:00:00', '2023-11-03T00:00:00', 4, 50, 700, 4);
});
</script>

<template>
    <div class="card mb-0! flex-1 min-w-[25rem] p-6! border border-surface rounded-2xl">
        <div class="flex items-center justify-between">
            <span class="label-medium text-surface-950 dark:text-surface-0">Social media users</span>
            <Button
                label="See All"
                severity="secondary"
                outlined
                icon="pi pi-chevron-right"
                iconPos="right"
                class="text-surface-950! dark:text-surface-0! px-2! py-1.5! rounded-lg! label-xsmall!"
                :pt="{
                    icon: {
                        class: 'text-xs!'
                    }
                }"
            />
        </div>
        <div class="flex items-center gap-3.5 mt-4">
            <span class="title-h6">72.742,74 </span>
            <Tag
                severity="success"
                value="12%"
                :pt="{
                    root: {
                        class: 'py-0.5! px-2!'
                    },
                    label: {
                        class: 'text-sm! font-semibold! leading-normal!'
                    }
                }"
            />
        </div>
        <MeterChart
            currency=""
            class="h-48 mt-8"
            :meterOptionsProps="{
                data: randomData,
                timeUnit: 'day',
                showY: false,
                showX: true,
                bgColors,
                xAxisPosition: 'top'
            }"
            @computedData="handleComputedValue"
        />
        <div class="mt-6 flex flex-col">
            <template v-for="(item, index) of dataLabels" :key="index">
                <div class="flex items-center gap-3.5">
                    <img class="w-4 h-4 object-cover" :src="isDarkTheme && item?.darkLogo ? item?.darkLogo : item.logo" />
                    <span class="flex-1 body-small text-left text-surface-950 dark:text-surface-0">{{ item.title }}</span>
                    <span class="label-small text-surface-950 dark:text-surface-0">{{ computedData?.[index].toFixed(0) }}</span>
                </div>
                <Divider v-if="dataLabels.length - 1 > index" class="my-3" />
            </template>
        </div>
    </div>
</template>
