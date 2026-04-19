<script setup>
import { inject, ref } from 'vue';
import { useRouter } from 'vue-router';

const router = useRouter();
const formState = inject('formState');

const authorizationOptions = ref(['Download Reports', 'Export Data', 'Edit Users', 'Access Custom Reports', 'Use API']);

const cancel = () => {
    router.push('/profile/list');
};

const next = () => {
    router.push('/profile/create/account-status');
};
</script>

<template>
    <div class="flex-1 self-stretch xl:rounded-tr-3xl xl:rounded-br-3xl flex flex-col overflow-hidden">
        <div class="self-stretch px-4 sm:px-6 xl:pl-8 xl:pr-6 pt-6 pb-4 flex items-center gap-4">
            <div class="flex-1 text-surface-950 dark:text-surface-0 text-xl font-medium leading-7">Authorization and Access</div>
        </div>

        <div class="self-stretch px-4 sm:px-6 flex flex-col gap-2">
            <div class="self-stretch h-0 border-t border-dashed border-surface-200 dark:border-surface-700" />
        </div>

        <div class="self-stretch p-4 sm:p-6 xl:p-8 flex flex-col items-end gap-6">
            <div class="self-stretch flex flex-col md:flex-row items-start gap-4 md:gap-8">
                <div class="w-full md:w-[283px] flex flex-col gap-2">
                    <div class="self-stretch text-surface-950 dark:text-surface-0 text-lg font-medium leading-7">Authorization Level</div>
                    <div class="self-stretch text-surface-500 dark:text-surface-400 text-base font-normal leading-normal">Select user's access permission level</div>
                </div>

                <div class="flex-1 w-full flex flex-col sm:flex-row items-start gap-4">
                    <div class="flex items-center gap-2">
                        <RadioButton v-model="formState.authorizationLevel" inputId="full-access" value="Full Access" />
                        <label for="full-access" class="text-surface-900 dark:text-surface-0 text-base font-normal">Full Access</label>
                    </div>
                    <div class="flex items-center gap-2">
                        <RadioButton v-model="formState.authorizationLevel" inputId="restricted-access" value="Restricted Access" />
                        <label for="restricted-access" class="text-surface-900 dark:text-surface-0 text-base font-normal">Restricted Access</label>
                    </div>
                    <div class="flex items-center gap-2">
                        <RadioButton v-model="formState.authorizationLevel" inputId="viewing-only" value="Viewing Only" />
                        <label for="viewing-only" class="text-surface-900 dark:text-surface-0 text-base font-normal">Viewing Only</label>
                    </div>
                </div>
            </div>

            <div class="self-stretch h-0 border-t border-dashed border-surface-200 dark:border-surface-700" />

            <div class="self-stretch flex flex-col md:flex-row items-start gap-4 md:gap-8">
                <div class="w-full md:w-[283px] flex flex-col gap-2">
                    <div class="self-stretch text-surface-950 dark:text-surface-0 text-lg font-medium leading-7">Authorizations</div>
                    <div class="self-stretch text-surface-500 dark:text-surface-400 text-base font-normal leading-normal">Select specific permissions and capabilities</div>
                </div>

                <div class="flex-1 w-full flex flex-col gap-4">
                    <div v-for="option in authorizationOptions" :key="option" class="flex items-center gap-2">
                        <Checkbox v-model="formState.authorizations" :inputId="option" :value="option" />
                        <label :for="option" class="text-surface-900 dark:text-surface-0 text-base font-normal">{{ option }}</label>
                    </div>
                </div>
            </div>

            <!-- Divider -->
            <div class="self-stretch h-0 border-t border-dashed border-surface-200 dark:border-surface-700" />

            <!-- User Management -->
            <div class="self-stretch flex flex-col md:flex-row items-start gap-4 md:gap-8">
                <div class="w-full md:w-[283px] flex flex-col gap-2">
                    <div class="self-stretch text-surface-950 dark:text-surface-0 text-lg font-medium leading-7">User Management</div>
                    <div class="self-stretch text-surface-500 dark:text-surface-400 text-base font-normal leading-normal">Enable or disable user management access</div>
                </div>

                <div class="flex-1 w-full">
                    <ToggleSwitch v-model="formState.userManagement" />
                </div>
            </div>

            <!-- Divider -->
            <div class="self-stretch h-0 border-t border-dashed border-surface-200 dark:border-surface-700" />

            <!-- Sales Management -->
            <div class="self-stretch flex flex-col md:flex-row items-start gap-4 md:gap-8">
                <div class="w-full md:w-[283px] flex flex-col gap-2">
                    <div class="self-stretch text-surface-950 dark:text-surface-0 text-lg font-medium leading-7">Sales Management</div>
                    <div class="self-stretch text-surface-500 dark:text-surface-400 text-base font-normal leading-normal">Enable or disable sales management access</div>
                </div>

                <div class="flex-1 w-full">
                    <ToggleSwitch v-model="formState.salesManagement" />
                </div>
            </div>

            <!-- Divider -->
            <div class="self-stretch h-0 border-t border-dashed border-surface-200 dark:border-surface-700" />

            <!-- Finance Display -->
            <div class="self-stretch flex flex-col md:flex-row items-start gap-4 md:gap-8">
                <div class="w-full md:w-[283px] flex flex-col gap-2">
                    <div class="self-stretch text-surface-950 dark:text-surface-0 text-lg font-medium leading-7">Finance Display</div>
                    <div class="self-stretch text-surface-500 dark:text-surface-400 text-base font-normal leading-normal">Enable or disable finance information visibility</div>
                </div>

                <div class="flex-1 w-full">
                    <ToggleSwitch v-model="formState.financeDisplay" />
                </div>
            </div>

            <div class="flex flex-col sm:flex-row items-stretch sm:items-start gap-3 sm:gap-4 w-full sm:w-auto">
                <Button label="Cancel" severity="secondary" outlined @click="cancel" class="cursor-pointer rounded-xl! w-full sm:w-auto" />
                <Button label="Continue" severity="primary" @click="next" class="cursor-pointer rounded-xl! w-full sm:w-auto" />
            </div>
        </div>
    </div>
</template>
