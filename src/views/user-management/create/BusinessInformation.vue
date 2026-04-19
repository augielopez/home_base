<script setup>
import { inject, ref } from 'vue';
import { useRouter } from 'vue-router';

const router = useRouter();
const formState = inject('formState');

const departmentOptions = ref([
    { name: 'Sales', code: 'sales' },
    { name: 'HR', code: 'hr' },
    { name: 'Marketing', code: 'marketing' },
    { name: 'Engineering', code: 'engineering' },
    { name: 'Finance', code: 'finance' }
]);

const positionOptions = ref(['Admin', 'Manager', 'Employee']);

// Initialize default values if not set
if (!formState.position) formState.position = 'Admin';
if (!formState.salaryRange) formState.salaryRange = [5000, 15000];

const cancel = () => {
    router.push('/profile/list');
};

const next = () => {
    router.push('/profile/create/location-information');
};
</script>

<template>
    <div class="flex-1 self-stretch xl:rounded-tr-3xl xl:rounded-br-3xl flex flex-col overflow-hidden">
        <div class="self-stretch px-4 sm:px-6 xl:pl-8 xl:pr-6 pt-6 pb-4 flex items-center gap-4">
            <div class="flex-1 text-surface-950 dark:text-surface-0 text-xl font-medium leading-7">Business Information</div>
        </div>

        <div class="self-stretch px-4 sm:px-6 flex flex-col gap-[9.14px]">
            <div class="self-stretch h-0 border-t border-dashed border-surface-200 dark:border-surface-700" />
        </div>

        <div class="self-stretch p-4 sm:p-6 xl:p-8 flex flex-col items-end gap-6">
            <div class="self-stretch flex flex-col md:flex-row items-start gap-4 md:gap-8">
                <div class="w-full md:w-[283px] flex flex-col gap-2">
                    <div class="self-stretch text-surface-950 dark:text-surface-0 text-lg font-medium leading-7">Department Selection</div>
                    <div class="self-stretch text-surface-500 dark:text-surface-400 text-base font-normal leading-normal">The department you work in</div>
                </div>

                <div class="flex-1 w-full flex flex-col gap-2">
                    <MultiSelect v-model="formState.department" :options="departmentOptions" optionLabel="name" placeholder="" class="w-full !rounded-[6px]" />
                </div>
            </div>

            <div class="self-stretch h-0 border-t border-dashed border-surface-200 dark:border-surface-700" />

            <div class="self-stretch flex flex-col md:flex-row items-start gap-4 md:gap-8">
                <div class="w-full md:w-[283px] flex flex-col gap-2">
                    <div class="self-stretch text-surface-950 dark:text-surface-0 text-lg font-medium leading-7">Position/Role</div>
                    <div class="self-stretch text-surface-500 dark:text-surface-400 text-base font-normal leading-normal">Your current job title</div>
                </div>

                <div class="flex-1 w-full">
                    <SelectButton v-model="formState.position" :options="positionOptions" class="w-full" />
                </div>
            </div>

            <!-- Divider -->
            <div class="self-stretch h-0 border-t border-dashed border-surface-200 dark:border-surface-700" />

            <!-- Employed -->
            <div class="self-stretch flex flex-col md:flex-row items-start gap-4 md:gap-8">
                <div class="w-full md:w-[283px] flex flex-col gap-2">
                    <div class="self-stretch text-surface-950 dark:text-surface-0 text-lg font-medium leading-7">Employed</div>
                    <div class="self-stretch text-surface-500 dark:text-surface-400 text-base font-normal leading-normal">Your work status</div>
                </div>

                <div class="flex-1 w-full">
                    <ToggleSwitch v-model="formState.employed" />
                </div>
            </div>

            <!-- Divider -->
            <div class="self-stretch h-0 border-t border-dashed border-surface-200 dark:border-surface-700" />

            <!-- Hybrid Work -->
            <div class="self-stretch flex flex-col md:flex-row items-start gap-4 md:gap-8">
                <div class="w-full md:w-[283px] flex flex-col gap-2">
                    <div class="self-stretch text-surface-950 dark:text-surface-0 text-lg font-medium leading-7">Does the hybrid work?</div>
                    <div class="self-stretch text-surface-500 dark:text-surface-400 text-base font-normal leading-normal">Whether hybrid work is available</div>
                </div>

                <div class="flex-1 w-full">
                    <ToggleSwitch v-model="formState.hybridWork" />
                </div>
            </div>

            <!-- Divider -->
            <div class="self-stretch h-0 border-t border-dashed border-surface-200 dark:border-surface-700" />

            <!-- Office Location -->
            <div class="self-stretch flex flex-col md:flex-row items-start gap-4 md:gap-8">
                <div class="w-full md:w-[283px] flex flex-col gap-2">
                    <div class="self-stretch text-surface-950 dark:text-surface-0 text-lg font-medium leading-7">Office Location</div>
                    <div class="self-stretch text-surface-500 dark:text-surface-400 text-base font-normal leading-normal">Office address or location</div>
                </div>

                <div class="flex-1 w-full flex flex-col gap-2">
                    <InputText v-model="formState.officeLocation" placeholder="" class="w-full !rounded-[6px]" />
                </div>
            </div>

            <!-- Divider -->
            <div class="self-stretch h-0 border-t border-dashed border-surface-200 dark:border-surface-700" />

            <!-- Salary Range -->
            <div class="self-stretch flex flex-col md:flex-row items-start gap-4 md:gap-8">
                <div class="w-full md:w-[283px] flex flex-col gap-2">
                    <div class="self-stretch text-surface-950 dark:text-surface-0 text-lg font-medium leading-7">Salary Range</div>
                    <div class="self-stretch text-surface-500 dark:text-surface-400 text-base font-normal leading-normal">Your salary range</div>
                </div>

                <div class="flex-1 w-full flex flex-col gap-4">
                    <InputText :value="`${formState.salaryRange[0].toLocaleString()}-${formState.salaryRange[1].toLocaleString()}`" readonly class="w-full !rounded-[6px]" />
                    <Slider v-model="formState.salaryRange" :min="0" :max="50000" :step="1000" range class="w-full" />
                </div>
            </div>

            <div class="flex flex-col sm:flex-row items-stretch sm:items-start gap-3 sm:gap-4 w-full sm:w-auto">
                <Button label="Cancel" severity="secondary" outlined @click="cancel" class="cursor-pointer !rounded-xl w-full sm:w-auto" />
                <Button label="Continue" severity="primary" @click="next" class="cursor-pointer !rounded-xl w-full sm:w-auto" />
            </div>
        </div>
    </div>
</template>
