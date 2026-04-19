<script setup>
import { ref } from 'vue';

const faqs = ref([
    {
        question: 'How do I become a webmaster?',
        answer: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.'
    },
    {
        question: 'What is web traffic?',
        answer: 'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam.'
    },
    {
        question: 'What is an easy way to make a website?',
        answer: 'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Curabitur pretium tincidunt lacus. Nulla gravida orci a odio. Nullam varius, turpis et commodo pharetra, est eros bibendum elit, nec luctus magna felis sollicitudin mauris. Integer in mauris eu nibh euismod gravida. Duis ac tellus et risus vulputate vehicula. Donec lobortis risus a elit. Etiam tempor. Ut ullamcorper, ligula eu tempor congue, eros est euismod turpis, id tincidunt sapien risus a quam.'
    },
    {
        question: 'How do you know if something is true?',
        answer: 'Cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.'
    }
]);
</script>

<template>
    <section class="py-10 lg:py-28 landing-container mx-auto">
        <div class="w-full">
            <h3 class="title-h5 lg:title-h3">Frequently Asked Questions</h3>
            <p class="mt-6 label-small lg:body-large max-w-md lg:max-w-none mx-auto">Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
            <div class="max-w-3xl lg:max-w-6xl mx-auto mt-10 p-4 lg:p-6 rounded-2xl border border-surface-200 dark:border-surface-800">
                <Accordion :value="0" expandIcon="pi pi-plus" collapseIcon="pi pi-minus">
                    <AccordionPanel
                        v-for="(faq, index) in faqs"
                        :key="index"
                        :value="index"
                        :pt="{
                            root: {
                                class: 'last:border-0 border-surface-200! dark:border-surface-800!'
                            }
                        }"
                    >
                        <AccordionHeader
                            :pt="{
                                root: {
                                    class: 'p-6! bg-transparent! hover:opacity-70 transition-all! data-[p-active=true]:pb-4! transition-all! duration-200!'
                                },
                                toggleIcon: {
                                    class: 'text-xl! text-surface-950! dark:text-surface-0!'
                                }
                            }"
                        >
                            <h5 class="label-medium">{{ faq.question }}</h5>
                        </AccordionHeader>
                        <AccordionContent
                            :pt="{
                                content: {
                                    class: 'px-6! pb-6! body-small! bg-transparent!'
                                }
                            }"
                        >
                            <p class="m-0 body-small text-left">{{ faq.answer }}</p>
                        </AccordionContent>
                    </AccordionPanel>
                </Accordion>
            </div>
        </div>
    </section>
</template>
