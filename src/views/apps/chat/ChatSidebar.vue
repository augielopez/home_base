<script setup>
defineProps({
    showContactInfo: {
        type: Boolean,
        default: false
    },
    showUserProfile: {
        type: Boolean,
        default: false
    },
    activeChat: {
        type: Object,
        default: null
    },
    selectedUser: {
        type: Object,
        default: null
    }
});

const emit = defineEmits(['openUserProfile', 'closeUserProfile', 'toggleContactInfo']);

const getAvatarInitials = (name) => {
    return name
        .split(' ')
        .map((n) => n[0])
        .join('')
        .toUpperCase();
};

const openUserProfile = (userId) => {
    emit('openUserProfile', userId);
};

const closeUserProfile = () => {
    emit('closeUserProfile');
};

const toggleContactInfo = () => {
    emit('toggleContactInfo');
};
</script>

<template>
    <div class="h-full">
        <!-- Contact Info Panel (Collapsible) -->
        <div v-if="showContactInfo" class="h-full">
            <!-- Backdrop for mobile/tablet -->
            <div class="xl:hidden! absolute inset-0 bg-black/50 z-40" @click="toggleContactInfo" />

            <!-- Sidebar Content -->
            <div
                :class="[
                    'h-full bg-surface-0 dark:bg-surface-900 flex flex-col overflow-hidden',
                    'w-full xl:w-80',
                    'fixed xl:relative inset-y-0 right-0 xl:inset-auto z-50 xl:z-auto',
                    'border-l-0 xl:border-l border-surface-200 dark:border-surface-700',
                    'shadow-none'
                ]"
            >
                <!-- Header with Close Button -->
                <div class="p-6 border-b border-surface-200 dark:border-surface-700 shrink-0">
                    <!-- Close Button -->
                    <Button icon="pi pi-times" text severity="secondary" size="small" class="absolute! top-4 right-4 z-10" rounded @click="toggleContactInfo" />
                    <h3 class="text-lg font-medium text-surface-900 dark:text-surface-0">Group Info</h3>
                </div>

                <!-- Scrollable Content -->
                <div class="flex-1 overflow-y-auto p-6">
                    <div class="space-y-4">
                        <div v-for="participant in activeChat?.participants" :key="participant.id" class="flex items-center gap-3">
                            <Avatar v-if="participant.avatar" :image="`/demo/images/avatar/${participant.avatar}`" size="normal" shape="circle" class="w-10 h-10 cursor-pointer" @click="openUserProfile(participant.id)" />
                            <Avatar v-else :label="getAvatarInitials(participant.name)" size="normal" shape="circle" class="w-10 h-10 bg-primary-100 text-primary-600 cursor-pointer" @click="openUserProfile(participant.id)" />
                            <div class="flex-1">
                                <p class="text-base font-medium text-surface-900 dark:text-surface-0">{{ participant.name }}</p>
                                <p class="text-sm text-surface-500 dark:text-surface-400 capitalize">{{ participant.status }}</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- User Profile Panel -->
        <div v-if="showUserProfile && selectedUser" class="h-full">
            <!-- Backdrop for mobile/tablet -->
            <div class="xl:hidden! absolute inset-0 bg-black/50 z-40" @click="closeUserProfile" />

            <!-- Sidebar Content -->
            <div
                :class="[
                    'h-full bg-surface-0 dark:bg-surface-900 flex flex-col overflow-hidden',
                    'w-full xl:w-80',
                    'fixed xl:relative inset-y-0 right-0 xl:inset-auto z-50 xl:z-auto',
                    'border-l-0 xl:border-l border-surface-200 dark:border-surface-700',
                    'shadow-none'
                ]"
            >
                <!-- Profile Header -->
                <div class="p-6 border-b border-surface-200 dark:border-surface-700 flex flex-col items-center gap-6">
                    <!-- Close Button -->
                    <Button icon="pi pi-times" text severity="secondary" size="small" class="absolute! top-4 right-4 z-10" rounded @click="closeUserProfile" />

                    <div class="flex flex-col items-center gap-4">
                        <Avatar v-if="selectedUser.avatar" :image="`/demo/images/avatar/${selectedUser.avatar}`" size="large" shape="circle" class="w-16 h-16" />
                        <Avatar v-else :label="getAvatarInitials(selectedUser.name)" size="large" shape="circle" class="w-16 h-16 bg-primary-100 text-primary-600" />
                        <h3 class="text-xl font-medium text-surface-900 dark:text-surface-0">{{ selectedUser.name }}</h3>
                    </div>

                    <!-- Action Buttons -->
                    <div class="flex items-center justify-center gap-2 w-full">
                        <Button icon="pi pi-phone" severity="secondary" rounded />
                        <Button icon="pi pi-video" severity="secondary" rounded />
                        <Button icon="pi pi-ellipsis-h" severity="secondary" rounded />
                    </div>
                </div>

                <!-- Main Info Section -->
                <div class="px-4 pt-4">
                    <h4 class="text-base font-medium text-surface-900 dark:text-surface-0">Main info</h4>
                </div>

                <!-- Info Items -->
                <div class="flex-1 overflow-y-auto">
                    <!-- Company -->
                    <div class="px-4 py-4 flex items-center gap-2">
                        <i class="pi pi-building text-surface-500 dark:text-surface-400 text-xs" />
                        <span class="flex-1 text-sm text-surface-500 dark:text-surface-400">Company</span>
                        <span class="text-sm font-medium text-surface-900 dark:text-surface-0">{{ selectedUser.company }}</span>
                    </div>
                    <div class="mx-4 h-px bg-surface-200 dark:bg-surface-700" />

                    <!-- Role -->
                    <div class="px-4 py-4 flex items-center gap-2">
                        <i class="pi pi-user text-surface-500 dark:text-surface-400 text-xs" />
                        <span class="flex-1 text-sm text-surface-500 dark:text-surface-400">Role</span>
                        <span class="text-sm font-medium text-surface-900 dark:text-surface-0">{{ selectedUser.role }}</span>
                    </div>
                    <div class="mx-4 h-px bg-surface-200 dark:bg-surface-700" />

                    <!-- Phone -->
                    <div class="px-4 py-4 flex items-center gap-2">
                        <i class="pi pi-phone text-surface-500 dark:text-surface-400 text-xs" />
                        <span class="flex-1 text-sm text-surface-500 dark:text-surface-400">Phone</span>
                        <span class="text-sm font-medium text-surface-900 dark:text-surface-0">{{ selectedUser.phone }}</span>
                    </div>
                    <div class="mx-4 h-px bg-surface-200 dark:bg-surface-700" />

                    <!-- Email -->
                    <div class="px-4 py-4 flex items-center gap-2">
                        <i class="pi pi-envelope text-surface-500 dark:text-surface-400 text-xs" />
                        <span class="flex-1 text-sm text-surface-500 dark:text-surface-400">Email</span>
                        <span class="text-sm font-medium text-surface-900 dark:text-surface-0">{{ selectedUser.email }}</span>
                    </div>
                    <div class="mx-4 h-px bg-surface-200 dark:bg-surface-700" />

                    <!-- First Contact -->
                    <div class="px-4 py-4 flex items-center gap-2">
                        <i class="pi pi-calendar text-surface-500 dark:text-surface-400 text-xs" />
                        <span class="flex-1 text-sm text-surface-500 dark:text-surface-400">First contact</span>
                        <span class="text-sm font-medium text-surface-900 dark:text-surface-0">{{ selectedUser.firstContact }}</span>
                    </div>
                    <div class="mx-4 h-px bg-surface-200 dark:bg-surface-700" />

                    <!-- Created By -->
                    <div class="px-4 py-4 flex items-center gap-2">
                        <i class="pi pi-user-plus text-surface-500 dark:text-surface-400 text-xs" />
                        <span class="flex-1 text-sm text-surface-500 dark:text-surface-400">Created by</span>
                        <span class="text-sm font-medium text-surface-900 dark:text-surface-0">{{ selectedUser.createdBy }}</span>
                    </div>
                    <div class="mx-4 h-px bg-surface-200 dark:bg-surface-700" />

                    <!-- Status -->
                    <div class="px-4 py-4 flex items-center gap-2">
                        <i class="pi pi-circle text-surface-500 dark:text-surface-400 text-xs" />
                        <span class="flex-1 text-sm text-surface-500 dark:text-surface-400">Status</span>
                        <Tag :value="selectedUser.statusTag" :severity="selectedUser.statusTag === 'Active' ? 'success' : 'secondary'" />
                    </div>
                    <div class="mx-4 h-px bg-surface-200 dark:bg-surface-700" />

                    <!-- Access -->
                    <div class="px-4 py-4 flex items-center gap-2">
                        <i class="pi pi-lock text-surface-500 dark:text-surface-400 text-xs" />
                        <span class="flex-1 text-sm text-surface-500 dark:text-surface-400">Access</span>
                        <Tag :value="selectedUser.access" severity="secondary" />
                    </div>

                    <!-- Linked Threads Section -->
                    <div class="px-4 pt-4 pb-2">
                        <h4 class="text-base font-medium text-surface-900 dark:text-surface-0">Linked threads</h4>
                    </div>

                    <!-- Linked Threads Items -->
                    <div v-for="thread in selectedUser.linkedThreads" :key="thread" class="px-4 py-2 flex items-center gap-2">
                        <i class="pi pi-link text-surface-500 dark:text-surface-400 text-xs" />
                        <span class="text-sm text-surface-500 dark:text-surface-400">{{ thread }}</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
