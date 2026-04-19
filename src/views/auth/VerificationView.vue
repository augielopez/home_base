<script setup>
import LazyImageWidget from '@/components/landing/LazyImageWidget.vue';
import LogoWidget from '@/components/landing/LogoWidget.vue';
import { ref } from 'vue';
import { useRouter } from 'vue-router';

const value = ref('');
const router = useRouter();

function closeModal() {
    router.push({ path: '/auth/register' });
}
</script>

<template>
    <section class="min-h-screen flex items-center lg:items-start lg:py-20 justify-center animate-fadein animate-duration-300 animate-ease-in max-w-[100rem] mx-auto">
        <div class="flex w-full h-full justify-center gap-12">
            <div class="flex flex-col py-20 lg:min-w-[30rem]">
                <router-link to="/" class="flex items-center justify-center lg:justify-start mb-8">
                    <LogoWidget />
                </router-link>
                <div class="flex flex-col justify-center grow">
                    <div class="max-w-md mx-auto w-full">
                        <h5 class="title-h5 text-center lg:text-left">Verification</h5>
                        <p class="body-small mt-3.5 text-center lg:text-left">We have sent a code to your email: <span class="text-primary">um******gn@gmail.com</span></p>
                        <form class="mt-8">
                            <InputOtp v-model="value" :length="6" class="w-full!" pt:pcInput:root:class="flex-1! xl:w-9! w-full!" />
                            <div class="flex items-center gap-4 mt-8">
                                <button @click="closeModal" type="button" class="body-button border border-surface-200 dark:border-surface-800 bg-transparent hover:bg-surface-100 dark:hover:bg-surface-800 text-surface-950 dark:text-surface-0 flex-1">
                                    Cancel
                                </button>
                                <button type="submit" class="body-button flex-1">Verify</button>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="mt-8 text-center lg:text-start block relative text-surface-400 dark:text-surface-500 text-sm">©{{ new Date().getFullYear() }} PrimeTek</div>
            </div>
            <div class="hidden lg:flex h-full py-20">
                <div class="h-full w-full lg:max-w-[32.5rem] xl:max-w-[60.5rem] mx-auto flex items-center justify-center shadow-[0px_1px_2px_0px_rgba(18,18,23,0.05)] rounded-3xl border border-surface overflow-hidden">
                    <LazyImageWidget class="w-auto h-full object-contain object-left" src="/demo/images/landing/auth-image.svg" alt="Auth Image" />
                </div>
            </div>
        </div>
    </section>
</template>
