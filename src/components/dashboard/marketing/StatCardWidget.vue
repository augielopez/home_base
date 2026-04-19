<script setup>
import LineChart from '@/components/dashboard/charts/LineChart.vue';
import { generateRandomData } from '@/lib/utils';
import 'chartjs-adapter-date-fns';
import { ref } from 'vue';

const ranges = [
    { name: 'Daily', unit: 'day' },
    { name: 'Weekly', unit: 'week' },
    { name: 'Monthly', unit: 'month' },
    { name: 'Yearly', unit: 'year' }
];

const selectedRange = ref([ranges[0], ranges[0], ranges[0]]);

const datasets = ref([
    {
        className: 'pb-6 xl:pb-0 xl:pr-6',
        cardData: {
            title: 'Sales Revenue',
            value: '$7,460.47',
            percent: '64',
            positive: true
        },
        datasets: generateRandomData('2020-10-27T00:00:00', '2023-11-03T00:00:00', 4, 2000, 3000)
    },
    {
        className: 'py-6 xl:py-0 xl:px-6',
        cardData: {
            title: 'AVG. order value',
            value: '$2,460.34',
            percent: '12',
            positive: false
        },
        borderColor: 'rgb(190,18,60)',
        bgColor: ['rgba(190,18,60,0.1)', 'rgba(190,18,60,0)'],
        datasets: generateRandomData('2023-10-27T00:00:00', '2024-11-03T00:00:00', 4, 1500, 3200)
    },
    {
        className: 'pt-6 xl:pt-0 xl:pl-6',
        cardData: {
            title: 'Total Visitor ',
            value: '27.329',
            percent: '32',
            positive: true
        },
        borderColor: 'rgb(21,128,61)',
        currency: '',
        bgColor: ['rgba(21,128,61,0.1)', 'rgba(21,128,61,0)'],
        datasets: generateRandomData('2000-10-27T00:00:00', '2023-11-03T00:00:00', 4, 1400, 5000)
    }
]);
</script>

<template>
    <template v-for="(data, index) of datasets" :key="index">
        <div :class="data.className" class="min-w-96">
            <div class="flex items-start justify-between gap-2 mb-2">
                <div>
                    <span class="label-medium text-surface-500">{{ data.cardData.title }}</span>
                    <div class="flex items-center gap-3.5 mt-2">
                        <span class="title-h7">{{ data.cardData.value }}</span>
                        <Tag
                            :severity="data.cardData.positive ? 'success' : 'danger'"
                            :value="data.cardData.percent + '%'"
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
                </div>
                <Select
                    v-model="selectedRange[index]"
                    :options="ranges"
                    optionLabel="name"
                    placeholder="Select a Month"
                    class="w-24"
                    :pt="{
                        root: {
                            class: 'pr-1.5 rounded-lg!'
                        },
                        label: {
                            class: 'pl-2! pr-1! py-1! font-medium! text-sm! text-surface-950! dark:text-surface-0!'
                        },
                        dropdown: {
                            class: 'w-3! [&>svg]:w-3! text-surface-950! dark:text-surface-0!'
                        },
                        option: {
                            class: 'pl-2! py-1.5! text-sm font-medium!'
                        }
                    }"
                />
            </div>
            <LineChart :datasets="data.datasets" :bgColor="data.bgColor" :borderColor="data.borderColor" :option="selectedRange[index]?.unit" tooltipPrefix="$" class="max-h-40!" />
        </div>
    </template>
</template>
