<script setup>
import LazyImageWidget from '@/components/landing/LazyImageWidget.vue';
import { ref } from 'vue';
const visibleMember = ref(null);

function setVisibleMember(member) {
    visibleMember.value = member;
}
</script>

<template>
    <div>
        <LazyImageWidget class-name="max-w-[80rem] mx-auto max-h-[32rem] h-full w-full object-cover rounded-2xl" src="/demo/images/dashboard/about-us-image.jfif" />
        <div class="mt-12 max-w-[52rem] mx-auto pb-12">
            <h3 class="title-h4 text-left">About us</h3>
            <p class="body-large text-left font-normal mt-6">
                Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
                Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.<br />
                Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam
                voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit,
                sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.<br />
                Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae
                consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?
            </p>
        </div>
        <div class="mt-4 md:mt-20">
            <span class="block text-surface-900 dark:text-surface-0 font-bold text-3xl mb-4 text-center">Our Team</span>
            <div class="text-center text-lg leading-normal mb-12">Faucibus ornare suspendisse sed nisi. Nisl rhoncus mattis rhoncus urna neque viverra justo nec.</div>
            <div class="grid grid-cols-12 gap-4">
                <div class="col-span-12 lg:col-span-6 xl:col-span-3 p-4">
                    <div class="relative overflow-hidden" @mouseenter="setVisibleMember(0)" @mouseleave="setVisibleMember(-1)">
                        <img src="/demo/images/blocks/team/team-1.png" class="w-full block" alt="Team 1" />

                        <div v-if="visibleMember === 0" class="absolute top-0 left-0 h-full w-full rounded animate-fadein animate-duration-300 select-none" :style="{ backgroundColor: 'rgba(0,0,0,0.7)' }">
                            <div class="flex flex-col p-8 h-full">
                                <span class="block font-medium text-white text-xl mb-4">Jeff Davies</span>
                                <span class="font-medium text-surface-400 dark:text-surface-400">Software Developer</span>
                                <div class="mt-auto">
                                    <a tabindex="0" class="cursor-pointer text-white">
                                        <i class="pi pi-twitter text-surface-200 dark:text-surface-200 text-xl mr-4" />
                                    </a>
                                    <a tabindex="0" class="cursor-pointer text-white">
                                        <i class="pi pi-github text-surface-200 dark:text-surface-200 text-xl mr-4" />
                                    </a>
                                    <a tabindex="0" class="cursor-pointer text-white">
                                        <i class="pi pi-facebook text-surface-200 dark:text-surface-200 text-xl" />
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-span-12 lg:col-span-6 xl:col-span-3 p-4">
                    <div class="relative overflow-hidden" @mouseenter="setVisibleMember(1)" @mouseleave="setVisibleMember(-1)">
                        <img src="/demo/images/blocks/team/team-2.png" class="w-full block" alt="Team 2" />

                        <div v-if="visibleMember === 1" class="absolute top-0 left-0 h-full w-full rounded animate-fadein animate-duration-300 select-none" :style="{ backgroundColor: 'rgba(0,0,0,0.7)' }">
                            <div class="flex flex-col p-8 h-full">
                                <span class="block font-medium text-white text-xl mb-4">Kristin Watson</span>
                                <span class="font-medium text-surface-400 dark:text-surface-400">UI/UX Designer</span>
                                <div class="mt-auto">
                                    <a tabindex="0" class="cursor-pointer text-white">
                                        <i class="pi pi-twitter text-surface-200 dark:text-surface-200 text-xl mr-4" />
                                    </a>
                                    <a tabindex="0" class="cursor-pointer text-white">
                                        <i class="pi pi-github text-surface-200 dark:text-surface-200 text-xl mr-4" />
                                    </a>
                                    <a tabindex="0" class="cursor-pointer text-white">
                                        <i class="pi pi-facebook text-surface-200 dark:text-surface-200 text-xl" />
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-span-12 lg:col-span-6 xl:col-span-3 p-4">
                    <div class="relative overflow-hidden" @mouseenter="setVisibleMember(2)" @mouseleave="setVisibleMember(-1)">
                        <img src="/demo/images/blocks/team/team-3.png" class="w-full block" alt="Team 3" />

                        <div v-if="visibleMember === 2" class="absolute top-0 left-0 h-full w-full rounded animate-fadein animate-duration-300 select-none" :style="{ backgroundColor: 'rgba(0,0,0,0.7)' }">
                            <div class="flex flex-col p-8 h-full">
                                <span class="block font-medium text-white text-xl mb-4">Jenna Williams</span>
                                <span class="font-medium text-surface-400 dark:text-surface-400">Marketing Specialist</span>
                                <div class="mt-auto">
                                    <a tabindex="0" class="cursor-pointer text-white">
                                        <i class="pi pi-twitter text-surface-200 dark:text-surface-200 text-xl mr-4" />
                                    </a>
                                    <a tabindex="0" class="cursor-pointer text-white">
                                        <i class="pi pi-github text-surface-200 dark:text-surface-200 text-xl mr-4" />
                                    </a>
                                    <a tabindex="0" class="cursor-pointer text-white">
                                        <i class="pi pi-facebook text-surface-200 dark:text-surface-200 text-xl" />
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-span-12 lg:col-span-6 xl:col-span-3 p-4">
                    <div class="relative overflow-hidden" @mouseenter="setVisibleMember(3)" @mouseleave="setVisibleMember(-1)">
                        <img src="/demo/images/blocks/team/team-4.png" class="w-full block" alt="Team 4" />

                        <div v-if="visibleMember === 3" class="absolute top-0 left-0 h-full w-full rounded animate-fadein animate-duration-300 select-none" :style="{ backgroundColor: 'rgba(0,0,0,0.7)' }">
                            <div class="flex flex-col p-8 h-full">
                                <span class="block font-medium text-white text-xl mb-4">Joe Clifford</span>
                                <span class="font-medium text-surface-400 dark:text-surface-400">Customer Relations</span>
                                <div class="mt-auto">
                                    <a tabindex="0" class="cursor-pointer text-white">
                                        <i class="pi pi-twitter text-surface-200 dark:text-surface-200 text-xl mr-4" />
                                    </a>
                                    <a tabindex="0" class="cursor-pointer text-white">
                                        <i class="pi pi-github text-surface-200 dark:text-surface-200 text-xl mr-4" />
                                    </a>
                                    <a tabindex="0" class="cursor-pointer text-white">
                                        <i class="pi pi-facebook text-surface-200 dark:text-surface-200 text-xl" />
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
