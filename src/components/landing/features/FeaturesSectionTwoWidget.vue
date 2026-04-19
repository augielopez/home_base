<script setup>
import LazyImageWidget from '@/components/landing/LazyImageWidget.vue';
import { useLayout } from '@/layout/composables/layout';

const { isDarkTheme } = useLayout();
</script>

<template>
    <section class="landing-container relative py-12 lg:py-24">
        <div class="max-w-[68rem] mx-auto flex items-center flex-col lg:flex-row-reverse gap-14 xl:gap-20">
            <div class="relative lg:flex-1 w-full h-[28rem] lg:h-[40rem] max-w-[25rem] lg:max-w-[36rem]">
                <LazyImageWidget
                    class="w-[17.5rem] lg:w-[25rem] z-0 rounded-2xl delay-300 h-auto absolute rotate-[20deg] bottom-10 lg:bottom-16 left-[4.5rem] lg:left-24 shadow-[0px_20px_52px_0px_rgba(0,0,0,0.04),0px_112px_31px_0px_rgba(0,0,0,0.00),0px_72px_29px_0px_rgba(0,0,0,0.01)]"
                    :src="'/demo/images/landing/boxes/' + (isDarkTheme ? 'social-media-users-dark.png' : 'social-media-users.png')"
                    alt="Features Section One Box Image"
                />
                <LazyImageWidget
                    class="w-[17.5rem] lg:w-[25rem] rounded-2xl z-10 h-auto absolute bottom-0 left-0 shadow-[0px_20px_52px_0px_rgba(0,0,0,0.04),0px_112px_31px_0px_rgba(0,0,0,0.00),0px_72px_29px_0px_rgba(0,0,0,0.01)]"
                    :src="'/demo/images/landing/boxes/' + (isDarkTheme ? 'social-media-revenue-dark.png' : 'social-media-revenue.png')"
                    alt="Features Section One Box Image"
                />
            </div>
            <div class="max-w-[25rem] mx-auto lg:max-w-md w-full flex flex-col items-center lg:items-start">
                <div class="badge mx-0">Feature</div>
                <h4 class="title-h5 lg:title-h4 text-center lg:text-left mt-4">Interactive Finance Tracking Tool</h4>
                <p class="body-medium text-center lg:text-left mt-6">
                    This tool is designed to track your expenses, create budgets, set savings goals, and understand your financial situation. Equipped with comprehensive analysis tools and customizable reports, this platform is here to help you
                    effectively manage your personal finances.
                </p>
                <ul class="list-disc mt-8 body-medium text-center lg:text-left list-inside space-y-3.5">
                    <li>Expense Tracking</li>
                    <li>Customizable Budget Planning</li>
                    <li>Financial Reports</li>
                </ul>
            </div>
        </div>
    </section>
</template>
