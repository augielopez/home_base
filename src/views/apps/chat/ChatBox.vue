<script setup>
import { nextTick, ref, watch } from 'vue';

const props = defineProps({
    activeChat: {
        type: Object,
        default: null
    },
    currentUser: {
        type: Object,
        required: true
    }
});

const emit = defineEmits(['openUserProfile', 'sendMessage']);

const newMessage = ref('');
const messagesContainer = ref(null);

const scrollToBottom = () => {
    nextTick(() => {
        if (messagesContainer.value) {
            messagesContainer.value.scrollTop = messagesContainer.value.scrollHeight;
        }
    });
};

const sendMessage = () => {
    if (!newMessage.value.trim()) return;

    const message = {
        id: Date.now(),
        senderId: props.currentUser.id,
        senderName: props.currentUser.name,
        content: newMessage.value.trim(),
        timestamp: new Date().toISOString(),
        time: new Date().toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' }),
        type: 'text'
    };

    emit('sendMessage', message);
    newMessage.value = '';
    scrollToBottom();
};

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

// Watch for changes in messages to scroll to bottom
watch(
    () => props.activeChat?.messages,
    () => {
        scrollToBottom();
    },
    { deep: true }
);

// Scroll to bottom when active chat changes
watch(
    () => props.activeChat?.id,
    () => {
        scrollToBottom();
    }
);
</script>

<template>
    <div class="flex-1 flex flex-col h-full min-h-0">
        <!-- Messages List -->
        <div ref="messagesContainer" class="flex-1 overflow-y-auto p-4 xl:p-6 space-y-4 xl:space-y-6 min-h-0 overscroll-contain">
            <div v-for="message in activeChat?.messages" :key="message.id">
                <!-- Date Separator -->
                <div v-if="message.isNewDay" class="flex items-center gap-4 xl:gap-6 mb-4 xl:mb-6">
                    <div class="flex-1 h-px bg-surface-200 dark:bg-surface-700" />
                    <span class="text-xs xl:text-sm text-surface-500 dark:text-surface-400">{{ message.dateLabel }}</span>
                    <div class="flex-1 h-px bg-surface-200 dark:bg-surface-700" />
                </div>

                <!-- Message -->
                <div v-if="message.senderId === 'me'" class="flex justify-end items-start gap-2 xl:gap-4 pl-8 xl:pl-16">
                    <span class="text-xs text-surface-500 dark:text-surface-400 mt-2">{{ message.time }}</span>
                    <div class="px-3 py-2 bg-primary-100 dark:bg-primary-900 rounded-xl max-w-xs xl:max-w-sm">
                        <p class="text-sm text-surface-900 dark:text-surface-0 break-words overflow-wrap-anywhere">{{ message.content }}</p>
                    </div>
                </div>
                <div v-else class="flex justify-start items-start gap-2 xl:gap-4 pr-8 xl:pr-16">
                    <Avatar v-if="message.senderAvatar" :image="`/demo/images/avatar/${message.senderAvatar}`" size="normal" shape="circle" class="w-6 h-6 xl:w-8 xl:h-8 cursor-pointer shrink-0!" @click="openUserProfile(message.senderId)" />
                    <Avatar v-else :label="getAvatarInitials(message.senderName)" size="normal" shape="circle" class="w-6 h-6 xl:w-8 xl:h-8 bg-primary-100 text-primary-600 cursor-pointer" @click="openUserProfile(message.senderId)" />
                    <div class="px-3 py-2 bg-surface-100 dark:bg-surface-700 rounded-xl max-w-xs xl:max-w-sm">
                        <p class="text-sm text-surface-900 dark:text-surface-0 break-words overflow-wrap-anywhere">{{ message.content }}</p>
                    </div>
                    <span class="text-xs text-surface-500 dark:text-surface-400 mt-2">{{ message.time }}</span>
                </div>
            </div>
        </div>

        <!-- Message Input -->
        <div class="px-4 xl:px-6 py-3 xl:py-5 border-t border-surface-200 dark:border-surface-700 flex items-center gap-2 xl:gap-4 shrink-0">
            <InputText v-model="newMessage" placeholder="Write a message" class="flex-1" @keyup.enter="sendMessage" />
            <div class="flex items-center gap-2 xl:gap-3">
                <!-- Mobile + Tablet: Single attach button -->
                <Button icon="pi pi-paperclip" severity="secondary" outlined size="small" class="xl:hidden!" />

                <!-- Desktop: Two separate buttons -->
                <div class="hidden! xl:flex! items-center gap-2">
                    <Button icon="pi pi-paperclip" severity="secondary" outlined />
                    <Button icon="pi pi-image" severity="secondary" outlined />
                </div>

                <div class="w-px h-4 bg-surface-200 dark:bg-surface-700 hidden! xl:block!" />

                <!-- Mobile + Tablet: Icon only send button -->
                <Button icon="pi pi-send" severity="primary" size="small" class="xl:hidden!" @click="sendMessage" />

                <!-- Desktop: Send button with label -->
                <Button label="Send" icon="pi pi-send" class="hidden! xl:flex!" @click="sendMessage" />
            </div>
        </div>
    </div>
</template>
