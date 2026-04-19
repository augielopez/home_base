<script setup>
import { generateRandomData } from '@/lib/utils';
import { ref } from 'vue';
import MeterChart from '../charts/MeterChart.vue';

const ranges = [
    { name: 'Hourly', unit: 'hour' },
    { name: 'Daily', unit: 'day' },
    { name: 'Weekly', unit: 'week' },
    { name: 'Monthly', unit: 'month' },
    { name: 'Yearly', unit: 'year' }
];

const selectedRange = ref([ranges[0], ranges[0], ranges[0]]);

const datasets = ref([
    {
        cardData: {
            title: 'Sales Rate ',
            value: '$256,137.48'
        },
        currency: '$',
        meterOptionsProps: {
            max: null,
            bgColors: null,
            labels: null,
            showX: false,
            showY: false,
            yAxis: null,
            xAxisPosition: 'bottom',
            timeUnit: 'week',
            data: generateRandomData('2020-10-27T00:00:00', '2023-11-03T00:00:00', 4, 400, 800)
        },
        percentage: '+24%',
        show: 6
    },
    {
        cardData: {
            title: 'New Customer ',
            value: '17.435'
        },
        currency: '',
        meterOptionsProps: {
            max: null,
            bgColors: ['#A855F7'],
            labels: null,
            showX: false,
            showY: false,
            yAxis: null,
            xAxisPosition: 'bottom',
            timeUnit: 'week',
            data: generateRandomData('2020-10-27T00:00:00', '2023-11-03T00:00:00', 4, 500, 700)
        },
        percentage: '+12%',
        show: 6
    },
    {
        cardData: {
            title: 'AVG. Monthly Order ',
            value: '32.048'
        },
        currency: '',
        meterOptionsProps: {
            max: null,
            bgColors: ['#3B82F6'],
            labels: null,
            showX: false,
            showY: false,
            yAxis: null,
            xAxisPosition: 'bottom',
            timeUnit: 'week',
            data: generateRandomData('2000-10-27T00:00:00', '2023-11-03T00:00:00', 4, 100, 500)
        },
        percentage: '+40%',
        show: 6
    }
]);
</script>

<template>
    <template v-for="(data, index) of datasets" :key="index">
        <div class="card h-72 flex-1 mb-0! p-0! min-w-96 flex flex-col border border-surface rounded-2xl">
            <div class="flex-1 flex flex-col p-6">
                <div class="flex items-start justify-between gap-2 mb-6">
                    <div>
                        <span class="label-medium text-surface-500">{{ data.cardData.title }}</span>
                        <div class="flex items-center gap-3.5 mt-2">
                            <span class="title-h7">{{ data.cardData.value }}</span>
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
                <MeterChart
                    :show="data.show"
                    :currency="data.currency"
                    :meterOptionsProps="{
                        ...data.meterOptionsProps,
                        timeUnit: selectedRange[index]?.unit
                    }"
                />
            </div>
            <p class="p-4 border-t border-surface-200 dark:border-surface-800 body-xsmall text-left">
                <span class="label-xsmall text-green-600">{{ data.percentage }}</span>
                total orders compared last month
            </p>
        </div>
    </template>
</template>
