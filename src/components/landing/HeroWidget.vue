<script setup>
import CustomersLogoWidget from '@/components/landing/CustomersLogoWidget.vue';
import HorizontalGridWidget from '@/components/landing/HorizontalGridWidget.vue';
import LazyImageWidget from '@/components/landing/LazyImageWidget.vue';
import { useLayout } from '@/layout/composables/layout';

const { isDarkTheme } = useLayout();
</script>

<template>
    <section class="animate-fadein animate-duration-300 animate-ease-in relative lg:pb-14 lg:pt-52 pt-36 pb-10">
        <HorizontalGridWidget class="top-[27rem] lg:top-[26rem]" />
        <div class="relative z-10 mx-auto landing-container overflow-hidden">
            <div class="flex flex-col items-center">
                <h1 class="title-h4 lg:title-h1">
                    Shaping the Future <br />
                    <span class="text-primary-600">with Innovative Ideas</span>
                </h1>
                <p class="body-small lg:body-medium mt-4 lg:mt-6 max-w-lg">Through innovative ideas, we shape the future with creativity and foresight, driving progress forward.</p>
                <router-link to="/" class="body-button mt-6 lg:mt-8">Get Started</router-link>
            </div>
            <div class="mb-20 lg:mb-28">
                <LazyImageWidget
                    :src="'/demo/images/landing/' + (isDarkTheme ? 'hero-dashboard-dark.png' : 'hero-dashboard.png')"
                    alt="Hero Image"
                    className="mt-16 min-w-[42rem] max-w-[71rem]! w-full h-auto mx-auto rounded-xl lg:rounded-3xl shadow-[0px_4px_16px_0px_rgba(18,18,23,0.08),0px_0px_0px_8px_#E3E8EF] dark:shadow-[0px_4px_16px_0px_rgba(18,18,23,0.08),0px_0px_0px_8px_#27272A]"
                />
            </div>
            <CustomersLogoWidget />
        </div>
    </section>
</template>
