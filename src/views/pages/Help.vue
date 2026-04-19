<script setup>
import { ref } from 'vue';

const search = ref();

const helps = ref([
    {
        icon: 'pi pi-power-off',
        title: 'Getting Started',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna.',
        to: ''
    },
    {
        icon: 'pi pi-arrows-h',
        title: 'Transactions',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna.',
        to: ''
    },
    {
        icon: 'pi pi-user',
        title: 'Profile',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna.',
        to: ''
    },
    {
        icon: 'pi pi-money-bill',
        title: 'Billing',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna.',
        to: ''
    },
    {
        icon: 'pi pi-database',
        title: 'Integrations',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna.',
        to: ''
    },
    {
        icon: 'pi pi-shield',
        title: 'Security',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna.',
        to: ''
    }
]);

const faqs = ref([
    {
        title: 'How do I become a webmaster?',
        description: 'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. '
    },
    {
        title: 'What is web traffic?',
        description: 'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. '
    },
    {
        title: 'What is an easy way to make a website?',
        description: 'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. '
    },
    {
        title: 'How do you know if something is true?',
        description: 'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. '
    }
]);
</script>
<template>
    <div>
        <div class="flex flex-col items-center py-11">
            <h1 class="title-h5 md:title-h4">
                Advice and answers<br />
                from the <span class="text-primary">Diamond team</span>
            </h1>
            <p class="mt-3 body-small">Get valuable advice and expert answers directly from the Genesis team.</p>
            <IconField class="mt-7">
                <InputIcon class="pi pi-search" />
                <InputText v-model="search" placeholder="Search" />
            </IconField>
        </div>
        <div class="grid sm:grid-cols-2 lg:grid-cols-3 gap-6 max-w-6xl mx-auto">
            <template v-for="(item, index) of helps" :key="index">
                <div class="card mb-0!">
                    <i :class="item.icon" class="text-3xl! text-primary" />
                    <h5 class="title-h7 text-left mt-4">{{ item.title }}</h5>
                    <p class="body-small text-left mt-2">{{ item.description }}</p>
                    <a class="inline-flex items-center justify-between w-full mt-5 cursor-pointer">
                        <span class="label-small flex-1 text-primary text-left">View all</span>
                        <span><i class="pi pi-arrow-right text-lg! text-primary" /></span>
                    </a>
                </div>
            </template>
        </div>
        <div class="max-w-6xl mx-auto card mt-6">
            <Accordion value="0">
                <AccordionPanel v-for="(item, index) of faqs" :key="item.title" :value="String(index)">
                    <AccordionHeader>{{ item.title }}</AccordionHeader>
                    <AccordionContent>
                        <p class="m-0">{{ item.description }}</p>
                    </AccordionContent>
                </AccordionPanel>
            </Accordion>
        </div>
    </div>
</template>
