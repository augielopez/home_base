<script setup>
import { useConfirm } from 'primevue/useconfirm';
import { computed, onMounted, ref } from 'vue';
import ChatBox from './ChatBox.vue';
import ChatMenu from './ChatMenu.vue';
import ChatSidebar from './ChatSidebar.vue';

const chatRooms = ref([]);
const currentUser = ref({});
const userData = ref({});
const activeChatId = ref(1);
const showContactInfo = ref(false);
const showUserProfile = ref(false);
const selectedUserId = ref(null);
const menu = ref();
const showChatView = ref(false);
const confirm = useConfirm();

const deleteChat = () => {
    confirm.require({
        message: `Are you sure you want to delete "${activeChat.value?.name}"? This action cannot be undone.`,
        header: 'Delete Chat',
        rejectProps: {
            label: 'Cancel',
            severity: 'secondary',
            outlined: true
        },
        acceptProps: {
            label: 'Delete',
            severity: 'danger'
        },
        accept: () => {
            const chatIndex = chatRooms.value.findIndex((chat) => chat.id === activeChatId.value);
            if (chatIndex !== -1) {
                chatRooms.value.splice(chatIndex, 1);
                if (chatRooms.value.length > 0) {
                    activeChatId.value = chatRooms.value[0].id;
                } else {
                    activeChatId.value = null;
                    showChatView.value = false;
                }
            }
        }
    });
};

const archiveChat = () => {
    const chat = chatRooms.value.find((chat) => chat.id === activeChatId.value);
    if (chat) {
        chat.archived = true;
        const availableChats = chatRooms.value.filter((c) => !c.archived);
        if (availableChats.length > 0) {
            activeChatId.value = availableChats[0].id;
        } else {
            activeChatId.value = null;
            showChatView.value = false;
        }
    }
};

const restoreChat = () => {
    const chat = chatRooms.value.find((chat) => chat.id === activeChatId.value);
    if (chat) {
        chat.archived = false;
    }
};

const togglePin = () => {
    const chat = chatRooms.value.find((chat) => chat.id === activeChatId.value);
    if (chat) {
        chat.pinned = !chat.pinned;
    }
};

const menuItems = computed(() => [
    {
        label: activeChat.value?.pinned ? 'Unpin Chat' : 'Pin Chat',
        icon: 'pi pi-thumbtack',
        command: togglePin
    },
    {
        label: 'Delete Chat',
        icon: 'pi pi-trash',
        command: deleteChat
    },
    {
        label: activeChat.value?.archived ? 'Restore Chat' : 'Archive Chat',
        icon: activeChat.value?.archived ? 'pi pi-replay' : 'pi pi-inbox',
        command: activeChat.value?.archived ? restoreChat : archiveChat
    }
]);

const activeChat = computed(() => {
    return chatRooms.value.find((chat) => chat.id === activeChatId.value);
});

const selectedUser = computed(() => {
    return selectedUserId.value ? userData.value[selectedUserId.value] : null;
});

onMounted(async () => {
    const response = await fetch('/demo/data/chatData.json');
    const data = await response.json();
    chatRooms.value = data.chatRooms;
    currentUser.value = data.currentUser;
    userData.value = data.userData;
});

const formatParticipants = (participants) => {
    if (participants.length <= 3) {
        return participants.map((p) => p.name).join(', ');
    }
    const first3 = participants
        .slice(0, 3)
        .map((p) => p.name)
        .join(', ');
    return `${first3} ...`;
};

const toggleContactInfo = () => {
    if (activeChat.value?.type === 'individual') {
        if (showUserProfile.value) {
            closeUserProfile();
        } else {
            const participant = activeChat.value.participants?.[0];
            if (participant) {
                openUserProfile(participant.id);
            }
        }
    } else {
        showContactInfo.value = !showContactInfo.value;
        showUserProfile.value = false;
    }
};

const openUserProfile = (userId) => {
    selectedUserId.value = userId;
    showUserProfile.value = true;
    showContactInfo.value = false;
};

const closeUserProfile = () => {
    showUserProfile.value = false;
    selectedUserId.value = null;
};

const showMenu = (event) => {
    menu.value.toggle(event);
};

const selectChat = (chatId) => {
    activeChatId.value = chatId;
    showChatView.value = true;
};

const goBackToMenu = () => {
    showChatView.value = false;
};

const createNewChat = (contact) => {
    const newChatId = Math.max(...chatRooms.value.map((c) => c.id)) + 1;

    const newChat = {
        id: newChatId,
        name: contact.name,
        type: 'individual',
        archived: false,
        avatar: contact.avatar,
        lastMessage: 'Start a conversation...',
        lastMessageSender: null,
        lastMessageTime: 'Now',
        unreadCount: 0,
        messages: []
    };

    chatRooms.value.push(newChat);

    activeChatId.value = newChatId;
    showChatView.value = true;
};

const handleSendMessage = (message) => {
    const chat = chatRooms.value.find((chat) => chat.id === activeChatId.value);
    if (chat) {
        chat.messages.push(message);
    }
};
</script>

<template>
    <div class="flex card overflow-hidden" style="height: 70vh; min-height: 500px; max-height: 800px">
        <div :class="['md:block h-full overflow-hidden', showChatView ? 'hidden md:block' : 'block w-full md:w-auto']">
            <ChatMenu :chat-rooms="chatRooms" :active-chat-id="activeChatId" @select-chat="selectChat" @new-chat="createNewChat" />
        </div>

        <div :class="['flex-1 flex-col h-full min-h-0', showChatView ? 'flex' : 'hidden md:flex']">
            <div class="px-4 xl:px-6 py-3 xl:py-4 border-b border-surface-200 dark:border-surface-700 flex justify-between items-center shrink-0">
                <div class="flex items-center gap-2 xl:gap-3">
                    <Button icon="pi pi-arrow-left" text severity="secondary" class="md:hidden!" size="small" @click="goBackToMenu" aria-label="Back to chats" />

                    <div v-if="activeChat?.type === 'group' && activeChat?.avatar" class="w-8 h-8 xl:w-10 xl:h-10 cursor-pointer overflow-hidden" @click="toggleContactInfo">
                        <img :src="`/demo/images/chat/${encodeURIComponent(activeChat.avatar)}`" :alt="activeChat.name" class="w-full h-full rounded-full object-contain" />
                    </div>
                    <div v-else-if="activeChat?.type === 'individual' && activeChat?.avatar" class="w-8 h-8 xl:w-10 xl:h-10 cursor-pointer overflow-hidden" @click="toggleContactInfo">
                        <img :src="`/demo/images/avatar/${activeChat.avatar}`" :alt="activeChat.name" class="w-full h-full rounded-full object-cover" />
                    </div>
                    <div v-else class="w-8 h-8 xl:w-10 xl:h-10 bg-surface-900 dark:bg-surface-100 rounded-full flex items-center justify-center cursor-pointer" @click="toggleContactInfo">
                        <div class="grid grid-cols-2 gap-px">
                            <div class="w-1.5 h-1.5 xl:w-2 xl:h-2 bg-emerald-500 rounded-sm" />
                            <div class="w-1.5 h-1.5 xl:w-2 xl:h-2 bg-red-400 rounded-sm" />
                            <div class="w-1.5 h-1.5 xl:w-2 xl:h-2 bg-purple-500 rounded-sm" />
                            <div class="w-1.5 h-1.5 xl:w-2 xl:h-2 bg-cyan-400 rounded-sm" />
                        </div>
                    </div>
                    <div class="flex flex-col cursor-pointer" @click="toggleContactInfo">
                        <h3 class="text-sm xl:text-base font-medium text-surface-900 dark:text-surface-0 hover:text-primary-600 dark:hover:text-primary-400 transition-colors">{{ activeChat?.name }}</h3>
                        <p v-if="activeChat?.type === 'group'" class="text-xs xl:text-sm text-surface-500 dark:text-surface-400 truncate">{{ formatParticipants(activeChat?.participants || []) }}</p>
                    </div>
                </div>
                <div class="flex items-center gap-2 xl:gap-3">
                    <Button icon="pi pi-video" severity="secondary" outlined size="small" class="xl:size-normal" />
                    <Button icon="pi pi-ellipsis-v" severity="secondary" outlined size="small" class="xl:size-normal" @click="showMenu" />
                    <Menu ref="menu" :model="menuItems" :popup="true" />
                </div>
            </div>

            <div class="flex-1 flex relative overflow-hidden min-h-0">
                <ChatBox :active-chat="activeChat" :current-user="currentUser" @open-user-profile="openUserProfile" @send-message="handleSendMessage" />

                <ChatSidebar
                    :show-contact-info="showContactInfo"
                    :show-user-profile="showUserProfile"
                    :active-chat="activeChat"
                    :selected-user="selectedUser"
                    @open-user-profile="openUserProfile"
                    @close-user-profile="closeUserProfile"
                    @toggle-contact-info="toggleContactInfo"
                />
            </div>
        </div>

        <ConfirmDialog />
    </div>
</template>
