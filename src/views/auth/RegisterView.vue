<script setup>
import AppleWidget from '@/components/auth/AppleWidget.vue';
import GoogleWidget from '@/components/auth/GoogleWidget.vue';
import LazyImageWidget from '@/components/landing/LazyImageWidget.vue';
import LogoWidget from '@/components/landing/LogoWidget.vue';
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import * as auth from '@/lib/api/auth';

const username = ref('');
const email = ref('');
const password = ref('');
const remember = ref(false);

const router = useRouter();

async function onRegister() {
  try {
    await auth.signup(username.value, email.value, password.value);
    router.push({ path: '/' });
  } catch (err) {
    console.error('Signup failed', err);
    alert(err?.body?.error || 'Registration failed');
  }
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
                        <h5 class="title-h5 text-center lg:text-left">Register</h5>
                        <p class="body-small mt-3.5 text-center lg:text-left">Let's get started</p>
                        <button class="social-button mt-8"><GoogleWidget /> Register with Google</button>
                        <button class="social-button mt-4"><AppleWidget /> Register with Apple</button>
                        <div class="flex items-center gap-3.5 my-7">
                            <span class="flex-1 h-[1px] bg-surface-200 dark:bg-surface-800" />
                            <span class="body-small text-surface-400 dark:text-surface-600">or</span>
                            <span class="flex-1 h-[1px] bg-surface-200 dark:bg-surface-800" />
                        </div>
                        <InputText type="text" v-model="username" class="w-full" placeholder="Username" />
                        <InputText type="text" v-model="email" class="w-full mt-4" placeholder="Email" />
                        <InputText type="password" v-model="password" class="w-full mt-4" placeholder="Password" />
                        <div class="my-8 flex items-center justify-between">
                            <div class="flex items-center gap-2">
                                <Checkbox inputId="remember" v-model="remember" :binary="true" />
                                <label for="remember" class="body-small"> <span class="label-small text-surface-950 dark:text-surface-0">I have read the </span>Terms and Conditions </label>
                            </div>
                        </div>
                        <button @click="onRegister" type="button" class="body-button w-full">Register</button>
                        <div class="mt-8 body-small text-center lg:text-left">Already have an account? <router-link to="/auth/login" class="text-primary-500 hover:underline"> Login</router-link></div>
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
