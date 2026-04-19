<script setup>
import { inject, ref } from 'vue';
import { useRouter } from 'vue-router';

const router = useRouter();
const fileInput = ref(null);
const formState = inject('formState');

const triggerFileUpload = () => {
    fileInput.value?.click();
};

const handleFileUpload = (event) => {
    const file = event.target.files[0];
    if (file) {
        formState.profilePhoto = file;
        formState.profilePhotoUrl = URL.createObjectURL(file);
    }
};

const cancel = () => {
    router.push('/profile/list');
};

const next = () => {
    router.push('/profile/create/business-information');
};
</script>

<template>
    <div class="flex-1 self-stretch xl:rounded-tr-3xl xl:rounded-br-3xl flex flex-col overflow-hidden">
        <div class="self-stretch px-4 sm:px-6 xl:pl-8 xl:pr-6 pt-6 pb-4 flex items-center gap-4">
            <div class="flex-1 text-surface-950 dark:text-surface-0 text-xl font-medium leading-7">Basic Information</div>
        </div>

        <div class="self-stretch px-4 sm:px-6 flex flex-col gap-[9.14px]">
            <div class="self-stretch h-0 border-t border-dashed border-surface-200 dark:border-surface-700" />
        </div>

        <div class="self-stretch p-4 sm:p-6 xl:p-8 flex flex-col items-end gap-6">
            <div class="self-stretch flex flex-col md:flex-row items-start gap-4 md:gap-8">
                <div class="w-full md:w-[283px] flex flex-col gap-2">
                    <div class="self-stretch text-surface-950 dark:text-surface-0 text-lg font-medium leading-7">Profile Photo</div>
                    <div class="self-stretch text-surface-500 dark:text-surface-400 text-base font-normal leading-normal">Upload your profile image</div>
                </div>

                <div class="w-full md:w-[296px] flex items-center gap-4">
                    <div class="w-[46px] h-[46px] bg-surface-0 dark:bg-surface-900 rounded-full border-[1.5px] border-surface-200 dark:border-surface-700 flex items-center justify-center overflow-hidden shrink-0">
                        <i v-if="!formState.profilePhotoUrl" class="pi pi-user text-surface-500 dark:text-surface-400 text-sm" />
                        <img v-else :src="formState.profilePhotoUrl" alt="Profile" class="w-full h-full object-cover" />
                    </div>

                    <div class="flex-1 flex flex-col justify-center gap-2">
                        <div class="self-stretch text-surface-500 dark:text-surface-400 text-base font-normal leading-normal">Drop or select a cover image</div>
                        <button @click="triggerFileUpload" class="text-primary-600 dark:text-primary-400 text-sm font-medium underline leading-4 text-left cursor-pointer bg-transparent border-0 p-0">Upload Image</button>
                        <input ref="fileInput" type="file" @change="handleFileUpload" accept="image/*" class="hidden" />
                    </div>
                </div>
            </div>

            <div class="self-stretch h-0 border-t border-dashed border-surface-200 dark:border-surface-700" />

            <div class="self-stretch flex flex-col md:flex-row items-start gap-4 md:gap-8">
                <div class="w-full md:w-[283px] flex flex-col gap-2">
                    <div class="self-stretch text-surface-950 dark:text-surface-0 text-lg font-medium leading-7">Name and Surname</div>
                    <div class="self-stretch text-surface-500 dark:text-surface-400 text-base font-normal leading-normal">Your full legal name and last name</div>
                </div>

                <div class="flex-1 w-full flex flex-col gap-2">
                    <InputText v-model="formState.name" placeholder="" class="w-full rounded-[6px]!" />
                </div>
            </div>

            <!-- Divider -->
            <div class="self-stretch h-0 border-t border-dashed border-surface-200 dark:border-surface-700" />

            <!-- Email Address -->
            <div class="self-stretch flex flex-col md:flex-row items-start gap-4 md:gap-8">
                <div class="w-full md:w-[283px] flex flex-col gap-2">
                    <div class="self-stretch text-surface-950 dark:text-surface-0 text-lg font-medium leading-7">Email Address</div>
                    <div class="self-stretch text-surface-500 dark:text-surface-400 text-base font-normal leading-normal">Provide a valid email</div>
                </div>

                <div class="flex-1 w-full flex flex-col gap-2">
                    <InputText v-model="formState.email" type="email" placeholder="" class="w-full rounded-[6px]!" />
                </div>
            </div>

            <!-- Divider -->
            <div class="self-stretch h-0 border-t border-dashed border-surface-200 dark:border-surface-700" />

            <!-- Phone Number -->
            <div class="self-stretch flex flex-col md:flex-row items-start gap-4 md:gap-8">
                <div class="w-full md:w-[283px] flex flex-col gap-2">
                    <div class="self-stretch text-surface-950 dark:text-surface-0 text-lg font-medium leading-7">Phone Number</div>
                    <div class="self-stretch text-surface-500 dark:text-surface-400 text-base font-normal leading-normal">Include country code</div>
                </div>

                <div class="flex-1 w-full flex flex-col gap-2">
                    <InputText v-model="formState.phone" type="tel" placeholder="" class="w-full rounded-[6px]!" />
                </div>
            </div>

            <!-- Divider -->
            <div class="self-stretch h-0 border-t border-dashed border-surface-200 dark:border-surface-700" />

            <!-- Biography -->
            <div class="self-stretch flex flex-col md:flex-row items-start gap-4 md:gap-8">
                <div class="w-full md:w-[283px] flex flex-col gap-2">
                    <div class="self-stretch text-surface-950 dark:text-surface-0 text-lg font-medium leading-7">Biography</div>
                    <div class="self-stretch text-surface-500 dark:text-surface-400 text-base font-normal leading-normal">Short personal description</div>
                </div>

                <div class="flex-1 w-full flex flex-col gap-2">
                    <Textarea v-model="formState.biography" rows="5" placeholder="" class="w-full rounded-[6px]!" />
                </div>
            </div>

            <div class="flex flex-col sm:flex-row items-stretch sm:items-start gap-3 sm:gap-4 w-full sm:w-auto">
                <Button label="Cancel" severity="secondary" outlined @click="cancel" class="cursor-pointer w-full sm:w-auto" />
                <Button label="Continue" severity="primary" @click="next" class="cursor-pointer w-full sm:w-auto" />
            </div>
        </div>
    </div>
</template>
