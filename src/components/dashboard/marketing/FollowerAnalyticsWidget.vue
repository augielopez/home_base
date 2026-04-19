<script setup>
import { ref } from 'vue';
import CustomMeter from '../charts/CustomMeter.vue';

const ranges = ref([
    { name: 'Weekly', code: 'wk' },
    { name: 'Monthly', code: 'mn' },
    { name: 'Yearly', code: 'yr' }
]);
const selectedRange = ref({ name: 'Weekly', code: 'wk' });
</script>

<template>
    <div class="xl:w-auto w-full xl:pl-6 pt-6 xl:pt-0 min-w-96 flex flex-col justify-between gap-10">
        <div class="flex flex-col gap-8">
            <div class="flex items-start gap-2">
                <div class="flex-1 flex items-center gap-3">
                    <div class="w-12 h-12 rounded-lg border border-surface flex items-center justify-center">
                        <svg width="21" height="24" viewBox="0 0 21 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M15.3444 10.8275L13.7197 10.4666L14.9834 12.2711V17.8653L19.3159 14.2562V8.12061L17.3302 8.84244L15.3444 10.8275Z" fill="#41B883" />
                            <path d="M5.23517 10.8275L6.85986 10.4666L5.59621 12.2711V17.8653L1.26369 14.2562V8.12061L3.24943 8.84244L5.23517 10.8275Z" fill="#41B883" />
                            <path
                                fill-rule="evenodd"
                                clip-rule="evenodd"
                                d="M6.1377 12.632L7.58187 10.4666L8.48448 11.0079H12.0949L12.9975 10.4666L14.4417 12.632V20.7527L13.3586 22.3768L12.0949 23.64H8.48448L7.22083 22.3768L6.1377 20.7527V12.632Z"
                                fill="#41B883"
                            />
                            <path d="M14.9834 21.294L17.3302 18.9481V16.6021L14.9834 18.5871V21.294Z" fill="#41B883" />
                            <path d="M5.59619 21.294L3.24941 18.9481V16.6021L5.59619 18.5871V21.294Z" fill="#41B883" />
                            <path
                                fill-rule="evenodd"
                                clip-rule="evenodd"
                                d="M12.6365 0H12.095V3.47928L13.0885 1.07305L12.6365 0ZM11.7457 4.32509L11.3729 4.51145V0H10.6508V6.97689L11.7457 4.32509ZM10.6508 8.54901L13.4163 1.8513L14.0807 3.4287L11.9144 10.2861H10.6508V8.54901ZM9.92869 7.00309V0H9.2066V4.51145L8.90603 4.36122L9.92869 7.00309ZM8.48452 3.27231V0H7.94295L7.56509 0.897113L8.48452 3.27231ZM7.22982 1.69309L9.92869 8.66517V10.2861H8.84556L6.49878 3.4287L7.22982 1.69309Z"
                                fill="#455C71"
                            />
                            <path
                                fill-rule="evenodd"
                                clip-rule="evenodd"
                                d="M1.08313 7.39878L8.84556 10.2861H9.02609L6.6793 3.4287L0 2.88733L1.08313 7.39878ZM19.6769 7.39878L11.9144 10.2861H11.7339L13.9002 3.4287L20.76 2.88733L19.6769 7.39878Z"
                                fill="#41B883"
                            />
                            <path d="M14.4416 2.88733L18.2326 2.52641L15.7053 0H13.178L14.4416 2.88733Z" fill="#455C71" />
                            <path d="M6.13772 2.88733L2.34676 2.52641L4.87406 0H7.40137L6.13772 2.88733Z" fill="#455C71" />
                            <path d="M2.82007 3.12L6.72007 3.42L9.06007 10.29H8.82007L6.30007 9.35999L2.82007 3.12Z" fill="#455C71" />
                            <path d="M17.8799 3.12L13.8599 3.42L11.6399 10.29L11.9399 10.284L14.2799 9.41999L17.8799 3.12Z" fill="#455C71" />
                            <path d="M7.26001 10.92L7.56001 10.44L8.58001 10.92H12.18L12.96 10.44L13.32 10.92L10.29 16.08L7.26001 10.92Z" fill="#455C71" />
                            <path fill-rule="evenodd" clip-rule="evenodd" d="M7.21777 0L10.2728 7.89218L13.5315 0H7.21777Z" fill="#41B883" />
                        </svg>
                    </div>
                    <div>
                        <div class="label-medium">PrimeVue</div>
                        <span class="body-xsmall">UI Library</span>
                    </div>
                </div>
                <Select
                    v-model="selectedRange"
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
            <div>
                <div class="flex items-center gap-3.5">
                    <span class="title-h6">273.167</span>
                    <Tag severity="success" value="12%" />
                </div>
                <span class="body-xsmall mt-1">Compared to last week</span>
            </div>
            <CustomMeter
                title="Follower analytics"
                :value="[
                    { label: 'Followers', title: '17.243', colorClass: 'bg-surface-950 dark:bg-surface-0', value: 17243 },
                    { label: 'Unfollow-up', title: '2.757', colorClass: 'bg-surface-200 dark:bg-surface-800', value: 2757 }
                ]"
            />
        </div>
        <Button class="mt-6 w-full text-surface-950! dark:text-surface-0! rounded-lg!" label="See all analytics " outlined severity="secondary" />
    </div>
</template>
