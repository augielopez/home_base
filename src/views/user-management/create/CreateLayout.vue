<script setup>
import { onMounted, provide, reactive } from 'vue';
import { useRoute, useRouter } from 'vue-router';

const router = useRouter();
const route = useRoute();

const formState = reactive({
    profilePhoto: null,
    profilePhotoUrl: null,
    name: '',
    email: '',
    phone: '',
    biography: '',
    department: null,
    position: 'Admin',
    employed: false,
    hybridWork: false,
    officeLocation: '',
    salaryRange: [5000, 15000],
    country: null,
    state: '',
    city: '',
    postalCode: '',
    addressLine1: '',
    addressLine2: '',
    authorizationLevel: 'member',
    authorizations: [],
    userManagement: false,
    salesManagement: false,
    financeDisplay: false,
    status: 'active',
    sendInvitation: false,
    notes: ''
});

provide('formState', formState);

onMounted(async () => {
    const response = await fetch('/demo/data/formState.json');
    const data = await response.json();
    Object.assign(formState, data);
});

const menuItems = [
    {
        label: 'Basic Information',
        shortLabel: 'Basic',
        icon: 'pi pi-user',
        route: '/profile/create/basic-information'
    },
    {
        label: 'Business Information',
        shortLabel: 'Business',
        icon: 'pi pi-briefcase',
        route: '/profile/create/business-information'
    },
    {
        label: 'Location Information',
        shortLabel: 'Location',
        icon: 'pi pi-map-marker',
        route: '/profile/create/location-information'
    },
    {
        label: 'Authorization and Access',
        shortLabel: 'Access',
        icon: 'pi pi-key',
        route: '/profile/create/authorization'
    },
    {
        label: 'Account Status',
        shortLabel: 'Status',
        icon: 'pi pi-shield',
        route: '/profile/create/account-status'
    }
];

const isActive = (menuRoute) => {
    return route.path === menuRoute;
};

const navigateTo = (menuRoute) => {
    router.push(menuRoute);
};
</script>

<template>
    <div class="flex flex-col xl:flex-row h-full card overflow-hidden !p-0">
        <div class="hidden xl:flex w-80 bg-surface-0 dark:bg-surface-900 flex-col overflow-hidden border-r border-surface-200 dark:border-surface-700">
            <div class="px-6 py-5 border-b border-surface-200 dark:border-surface-700">
                <h1 class="text-surface-950 dark:text-surface-0 text-lg font-medium leading-7">Create User</h1>
            </div>

            <div class="p-6 flex flex-col gap-4">
                <span class="text-surface-500 dark:text-surface-400 text-sm font-medium leading-tight">Menu</span>

                <button
                    v-for="item in menuItems"
                    :key="item.route"
                    @click="navigateTo(item.route)"
                    :class="[
                        'pl-3 pr-2 py-2 rounded-xl flex items-center gap-2 transition-colors cursor-pointer',
                        isActive(item.route) ? 'bg-primary text-surface-0 dark:text-surface-900 shadow-sm' : 'text-surface-500 dark:text-surface-400 hover:bg-surface-100 dark:hover:bg-surface-700'
                    ]"
                >
                    <i :class="[item.icon, 'text-base']" />
                    <span :class="['flex-1 text-left text-base', isActive(item.route) ? 'font-medium' : 'font-normal']">{{ item.label }}</span>
                </button>
            </div>
        </div>

        <!-- Mobile Tab Menu -->
        <div class="xl:hidden bg-surface-0 dark:bg-surface-900 border-b border-surface-200 dark:border-surface-700">
            <div class="px-4 py-3 border-b border-surface-200 dark:border-surface-700">
                <h1 class="text-surface-950 dark:text-surface-0 text-lg font-medium leading-7">Create User</h1>
            </div>

            <div class="overflow-x-auto">
                <div class="flex gap-2 p-4 min-w-max">
                    <button
                        v-for="item in menuItems"
                        :key="item.route"
                        @click="navigateTo(item.route)"
                        :class="[
                            'px-4 py-2 rounded-xl flex items-center gap-2 transition-colors cursor-pointer whitespace-nowrap',
                            isActive(item.route) ? 'bg-primary text-surface-0 dark:text-surface-900 shadow-sm' : 'bg-surface-100 dark:bg-surface-800 text-surface-500 dark:text-surface-400 hover:bg-surface-200 dark:hover:bg-surface-700'
                        ]"
                    >
                        <i :class="[item.icon, 'text-sm']" />
                        <span :class="['text-sm', isActive(item.route) ? 'font-medium' : 'font-normal']">{{ item.shortLabel }}</span>
                    </button>
                </div>
            </div>
        </div>

        <!-- Content Area -->
        <div class="flex-1 bg-surface-0 dark:bg-surface-900 overflow-auto">
            <router-view />
        </div>
    </div>
</template>
