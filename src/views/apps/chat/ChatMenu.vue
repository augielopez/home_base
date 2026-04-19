<script setup>
import { computed, onMounted, ref } from 'vue';

const props = defineProps({
    chatRooms: {
        type: Array,
        default: () => []
    },
    activeChatId: {
        type: Number,
        default: null
    }
});

const emit = defineEmits(['selectChat', 'newChat']);

const activeTabIndex = ref(0);
const showNewChatDialog = ref(false);
const searchQuery = ref('');
const userData = ref({});

const onlineUsers = ref([
    { id: 1, name: 'Amy Elsner', avatar: 'amyelsner.png', isViewed: false },
    { id: 2, name: 'Anna Fali', avatar: 'annafali.png', isViewed: false },
    { id: 3, name: 'Asiya Javayant', avatar: 'asiyajavayant.png', isViewed: false },
    { id: 4, name: 'Bernardo Dominic', avatar: 'bernardodominic.png', isViewed: false },
    { id: 5, name: 'Elwin Sharvill', avatar: 'elwinsharvill.png', isViewed: true },
    { id: 6, name: 'Ioni Bowcher', avatar: 'ionibowcher.png', isViewed: true },
    { id: 7, name: 'Ivan Magalhaes', avatar: 'ivanmagalhaes.png', isViewed: true }
]);

const getAvatarInitials = (name) => {
    return name
        .split(' ')
        .map((n) => n[0])
        .join('')
        .toUpperCase();
};

const selectChat = (chat) => {
    emit('selectChat', chat.id);
};

const openNewChatDialog = () => {
    showNewChatDialog.value = true;
};

const selectContact = (contact) => {
    // Check if chat already exists with this contact
    const existingChat = props.chatRooms.find((chat) => chat.type === 'individual' && chat.name === contact.name);

    if (existingChat) {
        // Open existing chat
        emit('selectChat', existingChat.id);
    } else {
        // Create new chat
        emit('newChat', contact);
    }

    showNewChatDialog.value = false;
};

// Filter function for search
const filterChatsBySearch = (chats) => {
    if (!searchQuery.value.trim()) return chats;
    const query = searchQuery.value.toLowerCase().trim();
    return chats.filter((chat) => chat.name.toLowerCase().includes(query));
};

const pinnedChats = computed(() => {
    const pinnedChatsList = props.chatRooms.filter((chat) => chat.pinned && !chat.archived);
    return filterChatsBySearch(pinnedChatsList);
});

const allChats = computed(() => {
    const nonArchivedChats = props.chatRooms.filter((chat) => !chat.archived);
    return filterChatsBySearch(nonArchivedChats);
});

const groupChats = computed(() => {
    const nonArchivedGroupChats = props.chatRooms.filter((chat) => chat.type === 'group' && !chat.archived);
    return filterChatsBySearch(nonArchivedGroupChats);
});

const unreadChats = computed(() => {
    const nonArchivedUnreadChats = props.chatRooms.filter((chat) => chat.unreadCount > 0 && !chat.archived);
    return filterChatsBySearch(nonArchivedUnreadChats);
});

const archivedChats = computed(() => {
    const archivedChatList = props.chatRooms.filter((chat) => chat.archived);
    return filterChatsBySearch(archivedChatList);
});

const hasArchivedChats = computed(() => archivedChats.value.length > 0);

// Get available contacts (all users from userData)
const availableContacts = computed(() => {
    return Object.values(userData.value);
});

onMounted(async () => {
    const response = await fetch('/demo/data/chatData.json');
    const data = await response.json();
    userData.value = data.userData;
});

// Get the last message from a chat
const getLastMessage = (chat) => {
    if (!chat.messages || chat.messages.length === 0) {
        return 'Start conversation';
    }
    const lastMessage = chat.messages[chat.messages.length - 1];
    return lastMessage.content;
};

// Get the last message sender from a chat
const getLastMessageSender = (chat) => {
    if (!chat.messages || chat.messages.length === 0) {
        return '';
    }
    const lastMessage = chat.messages[chat.messages.length - 1];
    return lastMessage.senderId === 'me' ? 'You' : lastMessage.senderName;
};

// Get the last message time from a chat
const getLastMessageTime = (chat) => {
    if (!chat.messages || chat.messages.length === 0) {
        return '';
    }
    const lastMessage = chat.messages[chat.messages.length - 1];
    return lastMessage.time;
};
</script>

<template>
    <div class="w-full md:w-[320px] h-full bg-surface-0 dark:bg-surface-900 md:border-r border-surface-200 dark:border-surface-700 flex flex-col overflow-hidden">
        <div class="flex-1 flex flex-col min-h-0">
            <!-- Online Users Stories Section -->
            <div class="border-b border-surface-200 dark:border-surface-700">
                <div class="px-4 pt-4 pb-2 flex flex-col gap-4">
                    <!-- Header -->
                    <div class="flex justify-between items-center">
                        <h3 class="text-base font-medium text-surface-900 dark:text-surface-0">Online</h3>
                        <button class="text-base font-medium text-primary-600 dark:text-primary-400 cursor-pointer">See All</button>
                    </div>

                    <!-- Stories Avatars -->
                    <div class="flex gap-3 overflow-x-auto scrollbar-none py-1 px-1">
                        <div
                            v-for="user in onlineUsers"
                            :key="user.id"
                            :class="['shrink-0 p-0.5 rounded-full outline outline-2 outline-offset-[-1px] cursor-pointer', user.isViewed ? 'outline-surface-300 dark:outline-surface-600' : 'outline-primary-600 dark:outline-primary-400']"
                        >
                            <img :src="`/demo/images/avatar/${user.avatar}`" :alt="user.name" class="w-10 h-10 rounded-full" />
                        </div>
                    </div>
                </div>

                <!-- Search and New Message Button -->
                <div class="p-4 flex gap-2">
                    <IconField class="flex-1">
                        <InputIcon class="pi pi-search" />
                        <InputText v-model="searchQuery" placeholder="Search" class="w-full" />
                    </IconField>

                    <Button icon="pi pi-plus" severity="secondary" outlined class="shrink-0" aria-label="New Message" @click="openNewChatDialog" />
                </div>
            </div>

            <!-- Custom Tabs -->
            <div class="border-b border-surface-200 dark:border-surface-700">
                <div class="flex">
                    <div :class="['flex-1 px-4 py-2 cursor-pointer transition-colors', activeTabIndex === 0 ? 'border-b-2 border-primary-500' : '']" @click="activeTabIndex = 0">
                        <div class="text-center">
                            <span :class="['text-base font-medium', activeTabIndex === 0 ? 'text-primary-500' : 'text-surface-500 dark:text-surface-400']"> All </span>
                        </div>
                    </div>
                    <div :class="['flex-1 px-4 py-2 cursor-pointer transition-colors', activeTabIndex === 1 ? 'border-b-2 border-primary-500' : '']" @click="activeTabIndex = 1">
                        <div class="text-center">
                            <span :class="['text-base font-medium', activeTabIndex === 1 ? 'text-primary-500' : 'text-surface-500 dark:text-surface-400']"> Group </span>
                        </div>
                    </div>
                    <div :class="['flex-1 px-4 py-2 cursor-pointer transition-colors', activeTabIndex === 2 ? 'border-b-2 border-primary-500' : '']" @click="activeTabIndex = 2">
                        <div class="text-center">
                            <span :class="['text-base font-medium', activeTabIndex === 2 ? 'text-primary-500' : 'text-surface-500 dark:text-surface-400']"> Unread </span>
                        </div>
                    </div>
                    <div v-if="hasArchivedChats" :class="['flex-1 px-4 py-2 cursor-pointer transition-colors', activeTabIndex === 3 ? 'border-b-2 border-primary-500' : '']" @click="activeTabIndex = 3">
                        <div class="text-center">
                            <span :class="['text-base font-medium', activeTabIndex === 3 ? 'text-primary-500' : 'text-surface-500 dark:text-surface-400']"> Archived </span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Tab Content -->
            <div class="flex-1 overflow-y-auto min-h-0 overscroll-contain">
                <!-- All Tab -->
                <div v-if="activeTabIndex === 0" class="p-4 space-y-6">
                    <!-- Pinned Conversations Section -->
                    <div v-if="pinnedChats.length > 0">
                        <h3 class="text-base font-medium text-surface-900 dark:text-surface-0 mb-3">Pinned</h3>

                        <div class="space-y-2">
                            <div
                                v-for="chat in pinnedChats"
                                :key="chat.id"
                                :class="[
                                    'p-4 relative rounded-2xl flex gap-3 cursor-pointer transition-colors',
                                    activeChatId === chat.id ? 'bg-surface-100 dark:bg-surface-700' : 'bg-surface-0 dark:bg-surface-900 hover:bg-surface-100 dark:hover:bg-surface-700'
                                ]"
                                @click="selectChat(chat)"
                            >
                                <div class="relative">
                                    <!-- Group Chat Avatar -->
                                    <div v-if="chat.type === 'group' && chat.avatar" class="w-10 h-10">
                                        <img :src="`/demo/images/chat/${encodeURIComponent(chat.avatar)}`" :alt="chat.name" class="w-full h-full rounded-full object-contain" />
                                    </div>
                                    <!-- Fallback Group Chat Avatar -->
                                    <div v-else-if="chat.type === 'group'" class="w-10 h-10 bg-surface-900 dark:bg-surface-100 rounded-full flex items-center justify-center">
                                        <div class="grid grid-cols-2 gap-px">
                                            <div class="w-2 h-2 bg-emerald-500 rounded-sm" />
                                            <div class="w-2 h-2 bg-red-400 rounded-sm" />
                                            <div class="w-2 h-2 bg-purple-500 rounded-sm" />
                                            <div class="w-2 h-2 bg-cyan-400 rounded-sm" />
                                        </div>
                                    </div>
                                    <!-- Individual Chat Avatar -->
                                    <div v-else class="w-10 h-10">
                                        <OverlayBadge class="inline-flex">
                                            <Avatar v-if="chat.avatar" :image="`/demo/images/avatar/${chat.avatar}`" size="normal" shape="circle" class="p-overlay-badge w-10 h-10" />
                                            <Avatar v-else :label="getAvatarInitials(chat.name)" size="normal" shape="circle" class="p-overlay-badge w-10 h-10 bg-primary-100 text-primary-600" />
                                            <template #badge>
                                                <div class="w-2.5 h-2.5 bg-surface-300 dark:bg-surface-600 rounded-full" />
                                            </template>
                                        </OverlayBadge>
                                    </div>
                                </div>

                                <div class="flex-1 min-w-0">
                                    <div class="flex items-center justify-between mb-1">
                                        <span class="text-base font-medium text-surface-900 dark:text-surface-0 truncate">{{ chat.name }}</span>
                                        <span class="text-sm text-surface-500 dark:text-surface-400">{{ getLastMessageTime(chat) }}</span>
                                    </div>
                                    <div class="flex items-center gap-1">
                                        <p class="text-sm text-surface-500 dark:text-surface-400 truncate flex-1">{{ chat.type === 'group' ? getLastMessageSender(chat) + ': ' : '' }}{{ getLastMessage(chat) }}</p>
                                        <div v-if="chat.unreadCount > 0" class="min-w-5 h-5 bg-primary-500 rounded-full flex items-center justify-center">
                                            <span class="text-xs font-bold text-white">{{ chat.unreadCount }}</span>
                                        </div>
                                        <i v-if="chat.pinned" class="pi pi-thumbtack text-surface-400 dark:text-surface-500 text-xs shrink-0" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- All Messages Section -->
                    <div>
                        <h3 class="text-base font-medium text-surface-900 dark:text-surface-0 mb-3">All Messages</h3>

                        <div v-if="allChats.length > 0" class="space-y-2">
                            <div
                                v-for="chat in allChats"
                                :key="chat.id"
                                :class="[
                                    'p-4 relative rounded-2xl flex gap-3 cursor-pointer transition-colors',
                                    activeChatId === chat.id ? 'bg-surface-100 dark:bg-surface-700' : 'bg-surface-0 dark:bg-surface-900 hover:bg-surface-100 dark:hover:bg-surface-700'
                                ]"
                                @click="selectChat(chat)"
                            >
                                <div class="relative">
                                    <!-- Group Chat Avatar -->
                                    <div v-if="chat.type === 'group' && chat.avatar" class="w-10 h-10">
                                        <img :src="`/demo/images/chat/${encodeURIComponent(chat.avatar)}`" :alt="chat.name" class="w-full h-full rounded-full object-contain" />
                                    </div>
                                    <!-- Fallback Group Chat Avatar -->
                                    <div v-else-if="chat.type === 'group'" class="w-10 h-10 bg-surface-900 dark:bg-surface-100 rounded-full flex items-center justify-center">
                                        <div class="grid grid-cols-2 gap-px">
                                            <div class="w-2 h-2 bg-emerald-500 rounded-sm" />
                                            <div class="w-2 h-2 bg-red-400 rounded-sm" />
                                            <div class="w-2 h-2 bg-purple-500 rounded-sm" />
                                            <div class="w-2 h-2 bg-cyan-400 rounded-sm" />
                                        </div>
                                    </div>
                                    <!-- Individual Chat Avatar -->
                                    <div v-else class="w-10 h-10">
                                        <OverlayBadge class="inline-flex">
                                            <Avatar v-if="chat.avatar" :image="`/demo/images/avatar/${chat.avatar}`" size="normal" shape="circle" class="p-overlay-badge w-10 h-10" />
                                            <Avatar v-else :label="getAvatarInitials(chat.name)" size="normal" shape="circle" class="p-overlay-badge w-10 h-10 bg-primary-100 text-primary-600" />
                                            <template #badge>
                                                <div class="w-2.5 h-2.5 bg-surface-300 dark:bg-surface-600 rounded-full" />
                                            </template>
                                        </OverlayBadge>
                                    </div>
                                </div>

                                <div class="flex-1 min-w-0">
                                    <div class="flex items-center justify-between mb-1">
                                        <span class="text-base font-medium text-surface-900 dark:text-surface-0 truncate">{{ chat.name }}</span>
                                        <span class="text-sm text-surface-500 dark:text-surface-400">{{ getLastMessageTime(chat) }}</span>
                                    </div>
                                    <div class="flex items-center gap-1">
                                        <p class="text-sm text-surface-500 dark:text-surface-400 truncate flex-1">{{ chat.type === 'group' ? getLastMessageSender(chat) + ': ' : '' }}{{ getLastMessage(chat) }}</p>
                                        <i v-if="chat.pinned" class="pi pi-thumbtack text-surface-400 dark:text-surface-500 text-xs shrink-0" />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- No results message -->
                        <div v-else-if="searchQuery.trim()" class="text-center py-8">
                            <i class="pi pi-search text-surface-400 dark:text-surface-500 text-2xl mb-2" />
                            <p class="text-surface-500 dark:text-surface-400 text-sm">No chats found for "{{ searchQuery }}"</p>
                        </div>
                    </div>
                </div>

                <!-- Group Tab -->
                <div v-if="activeTabIndex === 1" class="p-4">
                    <div v-if="groupChats.length > 0" class="space-y-2">
                        <div
                            v-for="chat in groupChats"
                            :key="chat.id"
                            :class="[
                                'p-4 relative rounded-2xl flex gap-3 cursor-pointer transition-colors',
                                activeChatId === chat.id ? 'bg-surface-100 dark:bg-surface-700' : 'bg-surface-0 dark:bg-surface-900 hover:bg-surface-100 dark:hover:bg-surface-700'
                            ]"
                            @click="selectChat(chat)"
                        >
                            <!-- Group Chat Avatar -->
                            <div v-if="chat.avatar" class="w-10 h-10">
                                <img :src="`/demo/images/chat/${encodeURIComponent(chat.avatar)}`" :alt="chat.name" class="w-full h-full rounded-full object-contain" />
                            </div>
                            <!-- Fallback Group Chat Avatar -->
                            <div v-else class="w-10 h-10 bg-surface-900 dark:bg-surface-100 rounded-full flex items-center justify-center">
                                <div class="grid grid-cols-2 gap-px">
                                    <div class="w-2 h-2 bg-emerald-500 rounded-sm" />
                                    <div class="w-2 h-2 bg-red-400 rounded-sm" />
                                    <div class="w-2 h-2 bg-purple-500 rounded-sm" />
                                    <div class="w-2 h-2 bg-cyan-400 rounded-sm" />
                                </div>
                            </div>

                            <div class="flex-1 min-w-0">
                                <div class="flex items-center justify-between mb-1">
                                    <span class="text-base font-medium text-surface-900 dark:text-surface-0 truncate">{{ chat.name }}</span>
                                    <span class="text-sm text-surface-500 dark:text-surface-400">{{ getLastMessageTime(chat) }}</span>
                                </div>
                                <div class="flex items-center gap-1">
                                    <p class="text-sm text-surface-500 dark:text-surface-400 truncate flex-1">{{ getLastMessageSender(chat) }}: {{ getLastMessage(chat) }}</p>
                                    <i v-if="chat.pinned" class="pi pi-thumbtack text-surface-400 dark:text-surface-500 text-xs shrink-0" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- No results message for Group tab -->
                    <div v-else-if="searchQuery.trim()" class="text-center py-8">
                        <i class="pi pi-search text-surface-400 dark:text-surface-500 text-2xl mb-2" />
                        <p class="text-surface-500 dark:text-surface-400 text-sm">No group chats found for "{{ searchQuery }}"</p>
                    </div>
                </div>

                <!-- Unread Tab -->
                <div v-if="activeTabIndex === 2" class="p-4">
                    <div v-if="unreadChats.length > 0" class="space-y-2">
                        <div
                            v-for="chat in unreadChats"
                            :key="chat.id"
                            :class="[
                                'p-4 relative rounded-2xl flex gap-3 cursor-pointer transition-colors',
                                activeChatId === chat.id ? 'bg-surface-100 dark:bg-surface-700' : 'bg-surface-0 dark:bg-surface-900 hover:bg-surface-100 dark:hover:bg-surface-700'
                            ]"
                            @click="selectChat(chat)"
                        >
                            <div class="relative">
                                <!-- Group Chat Avatar -->
                                <div v-if="chat.type === 'group' && chat.avatar" class="w-10 h-10">
                                    <img :src="`/demo/images/chat/${encodeURIComponent(chat.avatar)}`" :alt="chat.name" class="w-full h-full rounded-full object-contain" />
                                </div>
                                <!-- Fallback Group Chat Avatar -->
                                <div v-else-if="chat.type === 'group'" class="w-10 h-10 bg-surface-900 dark:bg-surface-100 rounded-full flex items-center justify-center">
                                    <div class="grid grid-cols-2 gap-px">
                                        <div class="w-2 h-2 bg-emerald-500 rounded-sm" />
                                        <div class="w-2 h-2 bg-red-400 rounded-sm" />
                                        <div class="w-2 h-2 bg-purple-500 rounded-sm" />
                                        <div class="w-2 h-2 bg-cyan-400 rounded-sm" />
                                    </div>
                                </div>
                                <div v-else>
                                    <OverlayBadge class="inline-flex">
                                        <Avatar v-if="chat.avatar" :image="`/demo/images/avatar/${chat.avatar}`" size="normal" shape="circle" class="p-overlay-badge w-10 h-10" />
                                        <Avatar v-else :label="getAvatarInitials(chat.name)" size="normal" shape="circle" class="p-overlay-badge w-10 h-10 bg-primary-100 text-primary-600" />
                                        <template #badge>
                                            <div class="w-2.5 h-2.5 bg-surface-300 dark:bg-surface-600 rounded-full" />
                                        </template>
                                    </OverlayBadge>
                                </div>
                            </div>

                            <div class="flex-1 min-w-0">
                                <div class="flex items-center justify-between mb-1">
                                    <span class="text-base font-medium text-surface-900 dark:text-surface-0 truncate">{{ chat.name }}</span>
                                    <span class="text-sm text-surface-500 dark:text-surface-400">{{ getLastMessageTime(chat) }}</span>
                                </div>
                                <div class="flex items-center gap-1">
                                    <p class="text-sm text-surface-500 dark:text-surface-400 truncate flex-1">{{ chat.type === 'group' ? getLastMessageSender(chat) + ': ' : '' }}{{ getLastMessage(chat) }}</p>
                                    <i v-if="chat.pinned" class="pi pi-thumbtack text-surface-400 dark:text-surface-500 text-xs shrink-0" />
                                    <div v-if="chat.unreadCount > 0" class="min-w-5 h-5 bg-primary-500 rounded-full flex items-center justify-center">
                                        <span class="text-xs font-bold text-white">{{ chat.unreadCount }}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- No results message for Unread tab -->
                    <div v-else-if="searchQuery.trim()" class="text-center py-8">
                        <i class="pi pi-search text-surface-400 dark:text-surface-500 text-2xl mb-2" />
                        <p class="text-surface-500 dark:text-surface-400 text-sm">No unread chats found for "{{ searchQuery }}"</p>
                    </div>
                </div>

                <!-- Archived Tab -->
                <div v-if="activeTabIndex === 3" class="p-4">
                    <div v-if="archivedChats.length > 0" class="space-y-2">
                        <div
                            v-for="chat in archivedChats"
                            :key="chat.id"
                            :class="[
                                'p-4 relative rounded-2xl flex gap-3 cursor-pointer transition-colors',
                                activeChatId === chat.id ? 'bg-surface-100 dark:bg-surface-700' : 'bg-surface-0 dark:bg-surface-900 hover:bg-surface-100 dark:hover:bg-surface-700'
                            ]"
                            @click="selectChat(chat)"
                        >
                            <div class="relative">
                                <!-- Group Chat Avatar -->
                                <div v-if="chat.type === 'group' && chat.avatar" class="w-10 h-10">
                                    <img :src="`/demo/images/chat/${encodeURIComponent(chat.avatar)}`" :alt="chat.name" class="w-full h-full rounded-full object-contain" />
                                </div>
                                <!-- Fallback Group Chat Avatar -->
                                <div v-else-if="chat.type === 'group'" class="w-10 h-10 bg-surface-900 dark:bg-surface-100 rounded-full flex items-center justify-center">
                                    <div class="grid grid-cols-2 gap-px">
                                        <div class="w-2 h-2 bg-emerald-500 rounded-sm" />
                                        <div class="w-2 h-2 bg-red-400 rounded-sm" />
                                        <div class="w-2 h-2 bg-purple-500 rounded-sm" />
                                        <div class="w-2 h-2 bg-cyan-400 rounded-sm" />
                                    </div>
                                </div>
                                <!-- Individual Chat Avatar -->
                                <div v-else>
                                    <OverlayBadge class="inline-flex">
                                        <Avatar v-if="chat.avatar" :image="`/demo/images/avatar/${chat.avatar}`" size="normal" shape="circle" class="p-overlay-badge w-10 h-10" />
                                        <Avatar v-else :label="getAvatarInitials(chat.name)" size="normal" shape="circle" class="p-overlay-badge w-10 h-10 bg-primary-100 text-primary-600" />
                                        <template #badge>
                                            <div class="w-2.5 h-2.5 bg-surface-300 dark:bg-surface-600 rounded-full" />
                                        </template>
                                    </OverlayBadge>
                                </div>
                            </div>

                            <div class="flex-1 min-w-0">
                                <div class="flex items-center justify-between mb-1">
                                    <span class="text-base font-medium text-surface-900 dark:text-surface-0 truncate">{{ chat.name }}</span>
                                    <span class="text-sm text-surface-500 dark:text-surface-400">{{ getLastMessageTime(chat) }}</span>
                                </div>
                                <div class="flex items-center gap-1">
                                    <i class="pi pi-inbox text-surface-400 dark:text-surface-500 text-xs" />
                                    <p class="text-sm text-surface-500 dark:text-surface-400 truncate flex-1">{{ chat.type === 'group' ? getLastMessageSender(chat) + ': ' : '' }}{{ getLastMessage(chat) }}</p>
                                    <i v-if="chat.pinned" class="pi pi-thumbtack text-surface-400 dark:text-surface-500 text-xs shrink-0" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- No results message for Archived tab -->
                    <div v-else-if="searchQuery.trim()" class="text-center py-8">
                        <i class="pi pi-search text-surface-400 dark:text-surface-500 text-2xl mb-2" />
                        <p class="text-surface-500 dark:text-surface-400 text-sm">No archived chats found for "{{ searchQuery }}"</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- New Chat Dialog -->
        <Dialog v-model:visible="showNewChatDialog" modal header="New Message" :style="{ width: '25rem' }">
            <div class="space-y-4">
                <div class="text-sm text-surface-500 dark:text-surface-400 mb-4">Select a contact to start a conversation</div>

                <div class="space-y-2 max-h-96 overflow-y-auto">
                    <div v-for="contact in availableContacts" :key="contact.id" class="p-3 rounded-xl flex items-center gap-3 cursor-pointer hover:bg-surface-100 dark:hover:bg-surface-700 transition-colors" @click="selectContact(contact)">
                        <Avatar v-if="contact.avatar" :image="`/demo/images/avatar/${contact.avatar}`" size="normal" shape="circle" class="w-10 h-10" />
                        <Avatar v-else :label="getAvatarInitials(contact.name)" size="normal" shape="circle" class="w-10 h-10 bg-primary-100 text-primary-600" />

                        <div class="flex-1">
                            <div class="text-base font-medium text-surface-900 dark:text-surface-0">{{ contact.name }}</div>
                            <div class="text-sm text-surface-500 dark:text-surface-400">{{ contact.role }} at {{ contact.company }}</div>
                        </div>

                        <div class="text-xs text-surface-500 dark:text-surface-400 capitalize">{{ contact.status }}</div>
                    </div>
                </div>
            </div>
        </Dialog>
    </div>
</template>
