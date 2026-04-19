<script setup>
import { generateRandomMultiData } from '@/lib/utils';
import 'chartjs-adapter-date-fns';
import { onBeforeMount, ref } from 'vue';
import BarChart from '../charts/BarChart.vue';

const randomData = ref(null);

onBeforeMount(() => {
    randomData.value = generateRandomMultiData('2020-10-27T00:00:00', '2023-11-03T00:00:00', 4, 10, 150, 3);
});

const ranges = [
    { name: 'Weekly', unit: 'week' },
    { name: 'Monthly', unit: 'month' },
    { name: 'Quarter', unit: 'quarter' },
    { name: 'Yearly', unit: 'year' }
];

const selectedRange = ref(ranges[0]);
</script>

<template>
    <div class="card !mb-0 h-96 min-w-96 flex flex-col p-6 border border-surface rounded-2xl overflow-hidden">
        <div class="flex items-start justify-between gap-2 mb-4">
            <div>
                <h3 class="label-medium">E-Commerce Overview</h3>
                <span class="body-xsmall">Trends summary, performance analysis </span>
            </div>
            <Select
                v-model="selectedRange"
                :options="ranges"
                optionLabel="name"
                placeholder="Select a Month"
                class="w-24"
                :pt="{
                    root: {
                        class: 'pr-1.5 !rounded-lg'
                    },
                    label: {
                        class: '!pl-2 !pr-1 !py-1 !font-medium !text-sm !text-surface-950 dark:!text-surface-0'
                    },
                    dropdown: {
                        class: '!w-3 [&>svg]:!w-3 !text-surface-950 dark:!text-surface-0'
                    },
                    option: {
                        class: '!pl-2 !py-1.5 text-sm !font-medium'
                    }
                }"
            />
        </div>
        <div class="flex-1 w-full h-full overflow-x-auto">
            <BarChart
                :labels="['Fashion', 'Electronics', 'Home']"
                :datasets="randomData"
                :bgColors="['rgba(151,163,182,1)', 'rgba(205,213,224,1)', 'rgba(227,232,239,1)']"
                :option="selectedRange.unit"
                class="min-w-[640px] flex-1 h-full w-full cursor-pointer"
            />
        </div>
    </div>
</template>
