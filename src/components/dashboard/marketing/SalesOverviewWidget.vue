<script setup>
import MultiLineChart from '@/components/dashboard/charts/MultiLineChart.vue';
import { generateRandomMultiData } from '@/lib/utils';
import 'chartjs-adapter-date-fns';
import { ref } from 'vue';

const ranges = [
    { name: 'Weekly', unit: 'week' },
    { name: 'Monthly', unit: 'month' },
    { name: 'Quarter', unit: 'quarter' },
    { name: 'Yearly', unit: 'year' }
];

const selectedRange = ref(ranges[0]);

const dataset = ref({
    cardData: {
        title: 'Total Visitor ',
        description: 'Sales trends summary, performance analysis'
    },
    currency: '$',
    labels: ['Income', 'Expenses'],
    datasets: generateRandomMultiData('2020-10-27T00:00:00', '2023-11-03T00:00:00', 4, 2000, 3000, 2, true),
    bgColors: [undefined, ['rgba(165,243,252,0.4)', 'rgba(165,243,252,0)']],
    borderColors: [undefined, 'rgb(8,145,178)']
});
</script>

<template>
    <div class="flex-1 xl:pr-6 pb-6 xl:pb-0 min-w-96 flex flex-col overflow-hidden">
        <div class="flex items-start justify-between gap-2 mb-2">
            <div>
                <h3 class="label-medium">{{ dataset.cardData.title }}</h3>
                <span class="body-xsmall">{{ dataset.cardData.description }}</span>
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
        <div class="w-full flex-1 overflow-auto">
            <MultiLineChart :datasets="dataset.datasets" :bgColors="dataset.bgColors" :borderColors="dataset.borderColors" :option="selectedRange.unit" class="!max-h-80 h-full w-full cursor-pointer" />
        </div>
    </div>
</template>
