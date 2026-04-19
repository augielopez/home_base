<script setup>
import { generateRandomMultiData } from '@/lib/utils';
import { onBeforeMount, ref } from 'vue';
import MultiLineChart from '../charts/MultiLineChart.vue';

const randomData = ref(null);

onBeforeMount(() => {
    randomData.value = generateRandomMultiData('2020-10-27T00:00:00', '2023-11-03T00:00:00', 4, 2000, 3000, 2, true);
});

const select = ref({ name: 'Weekly', value: 'week' });
const options = ref([
    { name: 'Weekly', value: 'week' },
    { name: 'Monthly', value: 'month' },
    { name: 'Yearly', value: 'year' }
]);
</script>

<template>
    <div class="card w-full xl:w-auto xl:flex-1 mb-0! px-7! pb-7! pt-6! border rounded-3xl border-surface flex flex-col justify-between overflow-hidden">
        <div class="flex items-start justify-between mb-4">
            <div class="label-medium">Income and Expenditure</div>
            <SelectButton v-model="select" :options="options" optionLabel="name" aria-labelledby="basic" />
        </div>
        <div class="flex-1 w-full overflow-auto">
            <MultiLineChart :datasets="randomData" :labels="['Income', 'Expenditure']" :bgColors="[undefined, ['rgba(165,243,252,0.4)', 'rgba(165,243,252,0)']]" :borderColors="[undefined, 'rgb(8,145,178)']" :option="select.value" />
        </div>
    </div>
</template>
