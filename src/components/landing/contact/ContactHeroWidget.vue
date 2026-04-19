<script setup>
import CustomersLogoWidget from '@/components/landing/CustomersLogoWidget.vue';
import { ref } from 'vue';
import HorizontalGridWidget from '../HorizontalGridWidget.vue';

const first_name = ref('');
const last_name = ref('');
const email = ref('');
const phone = ref('');
const message = ref('');
const selectedSubject = ref('Design');
const subjects = ref([
    { name: 'Design', key: 'design' },
    { name: 'Devoloper', key: 'developer' },
    { name: 'Components', key: 'components' },
    { name: 'Theme', key: 'theme' },
    { name: 'Template', key: 'template' }
]);
const socials = ref([
    {
        icon: 'pi pi-youtube',
        href: '#'
    },
    {
        icon: 'pi pi-twitter',
        href: '#'
    },
    {
        icon: 'pi pi-discord',
        href: '#'
    }
]);
</script>

<template>
    <section class="animate-fadein animate-duration-300 animate-ease-in relative lg:pb-14 lg:pt-52 pt-36 pb-10">
        <HorizontalGridWidget class="top-[24rem] lg:top-[26rem]" />
        <div class="landing-container mx-auto relative z-10">
            <h1 class="title-h4 lg:title-h1">
                Connect with Our<br />
                <span class="text-primary-600">Customer Support Team</span>
            </h1>
            <p class="body-small lg:body-medium mt-4 lg:mt-6 max-w-xs sm:max-w-lg lg:max-w-xl mx-auto">Our dedicated customer support team is here to assist you with any inquiries or assistance you may need.</p>
            <div
                class="mt-12 lg:mt-28 mb-16 lg:mb-24 max-w-xl lg:max-w-6xl mx-auto flex lg:flex-row flex-col-reverse rounded-2xl overflow-hidden border border-surface-200 dark:border-surface-800 shadow-[0px_12px_24px_0px_rgba(0,0,0,0.04),0px_1px_2px_0px_rgba(18,18,23,0.05)]"
            >
                <div class="overflow-hidden relative min-h-[30rem] lg:max-w-md w-full flex flex-col justify-between bg-primary-600 px-10 lg:px-11 py-10">
                    <img src="/demo/images/landing/pattern-c.png" class="absolute top-[20rem] lg:top-[26rem] -left-[16rem] lg:-left-[16rem] w-[42rem] rotate-180 z-0 select-none" />
                    <img src="/demo/images/landing/pattern-c.png" class="absolute rotate-45 -top-[28rem] lg:-top-[18rem] left-[18rem] w-[42rem] z-0 select-none" />
                    <div class="relative z-10">
                        <h6 class="title-h6 text-left text-surface-0">Contact Information</h6>
                        <p class="mt-2 body-large text-left text-surface-0/80">Say something to start a live chat!</p>
                        <div class="mt-10 flex flex-col gap-6">
                            <div class="flex items-center gap-3 text-surface-0">
                                <i class="pi pi-phone text-lg! leading-none!" />
                                <span class="body-small text-surface-0">+1000 0000 000</span>
                            </div>
                            <div class="flex items-center gap-3 text-surface-0">
                                <i class="pi pi-envelope text-lg! leading-none!" />
                                <span class="body-small text-surface-0">contact@primetek.com.tr</span>
                            </div>
                            <div class="flex items-center gap-3 text-surface-0">
                                <i class="pi pi-map-marker text-lg! leading-none!" />
                                <span class="body-small text-surface-0">0123 Peach Pl, Deceitdale, IL, 77777</span>
                            </div>
                        </div>
                    </div>
                    <div class="relative z-10 flex items-center gap-2">
                        <a v-for="(s, i) of socials" :key="i" :href="s.href" class="px-4 py-2 rounded-full border border-surface-0/50 text-surface-0 hover:bg-surface-0/15 transition-all flex items-center justify-center">
                            <i :class="s.icon" class="text-md" />
                        </a>
                    </div>
                </div>
                <div class="flex-1 p-6 lg:p-14 bg-surface-0 dark:bg-surface-950">
                    <form class="flex flex-col gap-10">
                        <div class="grid grid-cols-2 gap-3.5 lg:gap-7">
                            <InputText placeholder="First Name" type="text" v-model="first_name" />
                            <InputText placeholder="Last Name" type="text" v-model="last_name" />
                            <InputText placeholder="Email Address" type="email" v-model="email" />
                            <InputText placeholder="Phone Number" type="number" v-model="phone" />
                        </div>
                        <div>
                            <label class="label-medium">Select Subject?</label>
                            <div class="flex items-center flex-wrap gap-4 mt-4">
                                <div v-for="s in subjects" :key="s.key" class="flex items-center">
                                    <RadioButton variant="filled" v-model="selectedSubject" :inputId="s.key" name="dynamic" :value="s.name" />
                                    <label :for="s.key" class="ml-2 flex-1 text-sm text-surface-950 dark:text-surface-0">{{ s.name }}</label>
                                </div>
                            </div>
                        </div>
                        <Textarea placeholder="Message" v-model="message" rows="5" cols="30" class="resize-none" />
                        <button class="body-button w-full" type="submit">Get Started</button>
                    </form>
                </div>
            </div>
            <CustomersLogoWidget />
        </div>
    </section>
</template>
