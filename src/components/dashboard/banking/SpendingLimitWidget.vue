<script setup>
import CustomMeter from '@/components/dashboard/charts/CustomMeter.vue';
import { ref } from 'vue';

const selectedMonth1 = ref({ name: 'January', code: 'Jan' });
const selectedMonth2 = ref({ name: 'January', code: 'Jan' });
const months = ref([
    { name: 'January', code: 'Jan' },
    { name: 'February', code: 'Feb' },
    { name: 'March', code: 'Mar' },
    { name: 'April', code: 'Apr' },
    { name: 'May', code: 'May' },
    { name: 'June', code: 'Jun' },
    { name: 'July', code: 'Jul' },
    { name: 'August', code: 'Aug' },
    { name: 'September', code: 'Sep' },
    { name: 'October', code: 'Oct' },
    { name: 'November', code: 'Nov' },
    { name: 'December', code: 'Dec' }
]);
</script>

<template>
    <div class="card w-full xl:w-[25rem] mb-0! p-0! rounded-3xl border border-surface shadow-[0px_1px_2px_0px_rgba(18,18,23,0.05)]">
        <div class="p-6">
            <div class="mb-6 flex items-center justify-between gap-6">
                <div class="label-medium">Spending Limit</div>
                <Select
                    v-model="selectedMonth1"
                    :options="months"
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
            <CustomMeter
                title="Monthly spending limit"
                :value="[
                    { label: 'Spent', title: '$7.243', colorClass: 'bg-surface-950 dark:bg-surface-0', value: 7243 },
                    { label: 'Remaining', title: '$2.757', colorClass: 'bg-surface-200 dark:bg-surface-800', value: 2757 }
                ]"
            />
        </div>
        <Divider class="m-0!" />
        <div class="p-6">
            <div class="mb-6 flex items-center justify-between gap-6">
                <div class="label-medium">Expenditure</div>
                <Select
                    v-model="selectedMonth2"
                    :options="months"
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
            <CustomMeter
                :value="[
                    { label: 'Food', title: '$3.243', colorClass: 'bg-violet-400', value: 3243 },
                    { label: 'Clothing', title: '$2.111', colorClass: 'bg-yellow-400', value: 2111 },
                    { label: 'Other', title: '$2.485', colorClass: 'bg-sky-400', value: 2485 }
                ]"
            />
            <Button class="w-full mt-6 text-surface-950! dark:text-surface-0! rounded-lg!" label="View account detail" outlined severity="secondary" />
        </div>
    </div>
</template>
