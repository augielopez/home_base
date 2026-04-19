<script setup>
import { computed, onMounted, ref } from 'vue';
import { useRoute, useRouter } from 'vue-router';

const router = useRouter();
const route = useRoute();
const emailId = computed(() => route.params.id);
const fromView = computed(() => route.query.from || 'Inbox');

const replyMessage = ref('');
const showReplyEditor = ref(false);
const recipientPanel = ref();
const actionMenu = ref();

const emailsData = ref([]);

onMounted(async () => {
    const response = await fetch('/demo/data/emailData.json');
    const data = await response.json();
    emailsData.value = data.emails;
});

const currentEmail = computed(() => {
    const id = parseInt(emailId.value);
    return emailsData.value.find((email) => email.id === id);
});

const goBack = () => {
    router.push({
        path: '/apps/mail/inbox',
        query: { view: fromView.value }
    });
};

const toggleReply = () => {
    showReplyEditor.value = !showReplyEditor.value;
};

const sendReply = () => {
    showReplyEditor.value = false;
    replyMessage.value = '';
};

const toggleImportant = () => {
    if (currentEmail.value) {
        const email = emailsData.value.find((e) => e.id === currentEmail.value.id);
        if (email) {
            email.important = !email.important;
        }
    }
};

const showRecipientDetails = (event) => {
    recipientPanel.value.toggle(event);
};

const toggleStar = () => {
    if (currentEmail.value) {
        const email = emailsData.value.find((e) => e.id === currentEmail.value.id);
        if (email) {
            email.starred = !email.starred;
        }
    }
};

const archiveEmail = () => {
    if (currentEmail.value) {
        const email = emailsData.value.find((e) => e.id === currentEmail.value.id);
        if (email) {
            email.archived = true;
        }
        goBack();
    }
};

const unarchiveEmail = () => {
    if (currentEmail.value) {
        const email = emailsData.value.find((e) => e.id === currentEmail.value.id);
        if (email) {
            email.archived = false;
        }
    }
};

const markAsSpam = () => {
    if (currentEmail.value) {
        const email = emailsData.value.find((e) => e.id === currentEmail.value.id);
        if (email) {
            email.spam = true;
        }
        goBack();
    }
};

const deleteEmail = () => {
    if (currentEmail.value) {
        const email = emailsData.value.find((e) => e.id === currentEmail.value.id);
        if (email) {
            email.deleted = true;
        }
        goBack();
    }
};

const recoverEmail = () => {
    if (currentEmail.value) {
        const email = emailsData.value.find((e) => e.id === currentEmail.value.id);
        if (email) {
            email.deleted = false;
            email.spam = false;
        }
        goBack();
    }
};

const showActionMenu = (event) => {
    actionMenu.value.toggle(event);
};

const actionMenuItems = computed(() => {
    const email = currentEmail.value;
    const isInTrash = email?.deleted;

    if (isInTrash) {
        return [{ label: 'Recover', icon: 'pi pi-replay', command: () => recoverEmail() }];
    }

    return [
        { label: 'Forward', icon: 'pi pi-reply', command: () => {} },
        {
            label: email?.archived ? 'Unarchive' : 'Archive',
            icon: email?.archived ? 'pi pi-replay' : 'pi pi-inbox',
            command: () => (email?.archived ? unarchiveEmail() : archiveEmail())
        },
        { label: 'Mark as Spam', icon: 'pi pi-ban', command: () => markAsSpam() },
        { label: 'Delete', icon: 'pi pi-trash', command: () => deleteEmail() }
    ];
});

const getAvatarInitials = (name) => {
    return name
        .split(' ')
        .map((n) => n[0])
        .join('')
        .toUpperCase();
};
</script>

<template>
    <div class="w-full h-full flex flex-col bg-surface-0 dark:bg-surface-900">
        <div class="px-4 md:px-6 py-4 border-b border-surface-200 dark:border-surface-700 flex justify-between items-center bg-surface-0 dark:bg-surface-900">
            <div class="flex items-center gap-2 md:gap-4 flex-1 min-w-0">
                <Button icon="pi pi-arrow-left" text @click="goBack" severity="secondary" />
                <div class="flex flex-col min-w-0">
                    <h1 class="text-surface-900 dark:text-surface-0 text-lg font-medium truncate">{{ currentEmail?.subject }}</h1>
                    <span class="text-surface-500 dark:text-surface-400 text-sm">{{ currentEmail?.thread?.length || 1 }} {{ currentEmail?.thread?.length === 1 ? 'message' : 'messages' }}</span>
                </div>
            </div>
            <div class="flex items-center gap-2 md:gap-3 shrink-0">
                <Button :icon="currentEmail?.starred ? 'pi pi-star-fill' : 'pi pi-star'" :class="currentEmail?.starred ? 'text-yellow-500' : ''" text severity="secondary" @click="toggleStar" title="Star" />
                <Button :icon="currentEmail?.important ? 'pi pi-bookmark-fill' : 'pi pi-bookmark'" :class="currentEmail?.important ? 'text-orange-500' : ''" text severity="secondary" @click="toggleImportant" title="Mark as important" />
                <Button icon="pi pi-ellipsis-v" severity="secondary" text @click="showActionMenu" title="More actions" />
            </div>
        </div>

        <div class="flex-1 overflow-y-auto">
            <div class="px-4 md:px-6">
                <div v-for="(message, index) in currentEmail?.thread" :key="message.id" class="message-card">
                    <div class="my-4 bg-surface-0 dark:bg-surface-800 border border-surface-200 dark:border-surface-700 rounded-lg overflow-hidden">
                        <div class="p-3 md:p-6 border-b border-surface-200 dark:border-surface-700">
                            <div class="block md:hidden">
                                <div class="flex items-start gap-3 mb-3">
                                    <Avatar v-if="message.avatar && message.avatar.startsWith('/')" :image="message.avatar" size="normal" shape="square" class="w-8 h-8 shrink-0 rounded-lg!" :pt="{ image: { class: 'rounded-lg!' } }" />
                                    <Avatar v-else-if="message.avatar" :label="message.avatar" size="normal" shape="square" class="w-8 h-8 shrink-0 bg-primary-100 text-primary-600 rounded-lg!" />
                                    <Avatar v-else :label="getAvatarInitials(message.sender)" size="normal" shape="square" class="w-8 h-8 shrink-0 bg-primary-100 text-primary-600 rounded-lg!" />
                                    <div class="flex-1 min-w-0">
                                        <div class="flex items-center justify-between">
                                            <span class="text-surface-900 dark:text-surface-0 font-medium truncate">{{ message.sender }}</span>
                                            <span class="text-xs text-surface-500 dark:text-surface-400 shrink-0 ml-2">{{ message.time }}</span>
                                        </div>
                                        <div class="text-sm text-surface-500 dark:text-surface-400 truncate">&lt;{{ message.email }}&gt;</div>
                                        <div class="flex items-center justify-between mt-1">
                                            <div class="flex items-center gap-1 text-sm text-surface-500 dark:text-surface-400">
                                                <span>to {{ message.sender === 'Robert Fox' ? currentEmail?.sender : 'Robert Fox' }}</span>
                                                <Button icon="pi pi-chevron-down" text size="small" severity="secondary" class="p-1 w-4 h-4" @click="showRecipientDetails" />
                                            </div>
                                            <div class="flex items-center gap-1">
                                                <Button text size="small" severity="secondary" @click="toggleReply" title="Reply" class="w-6 h-6">
                                                    <i class="pi pi-reply flip-icon-horizontal" />
                                                </Button>
                                                <Button icon="pi pi-ellipsis-v" text size="small" severity="secondary" @click="showActionMenu" title="More actions" class="w-6 h-6" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="hidden md:block">
                                <div class="flex items-start justify-between gap-4">
                                    <div class="flex items-start gap-3">
                                        <Avatar v-if="message.avatar && message.avatar.startsWith('/')" :image="message.avatar" size="normal" shape="square" class="w-10 h-10 shrink-0 rounded-lg!" :pt="{ image: { class: 'rounded-lg!' } }" />
                                        <Avatar v-else-if="message.avatar" :label="message.avatar" size="normal" shape="square" class="w-10 h-10 shrink-0 bg-primary-100 text-primary-600 rounded-lg!" />
                                        <Avatar v-else :label="getAvatarInitials(message.sender)" size="normal" shape="square" class="w-10 h-10 shrink-0 bg-primary-100 text-primary-600 rounded-lg!" />
                                        <div class="flex flex-col gap-1">
                                            <div class="flex items-center gap-2">
                                                <span class="text-surface-900 dark:text-surface-0 font-medium">{{ message.sender }}</span>
                                                <span class="text-surface-500 dark:text-surface-400 text-sm">&lt;{{ message.email }}&gt;</span>
                                            </div>
                                            <div class="flex items-center gap-2 text-sm text-surface-500 dark:text-surface-400">
                                                <span>to {{ message.sender === 'Robert Fox' ? currentEmail?.sender : 'Robert Fox' }}</span>
                                                <Button icon="pi pi-chevron-down" text size="small" severity="secondary" class="p-1 w-5 h-5" @click="showRecipientDetails" />
                                            </div>
                                        </div>
                                    </div>
                                    <div class="flex items-center gap-2">
                                        <span class="text-sm text-surface-500 dark:text-surface-400">{{ message.time }}</span>
                                        <div class="flex items-center gap-1">
                                            <Button text size="small" severity="secondary" @click="toggleReply" title="Reply">
                                                <i class="pi pi-reply flip-icon-horizontal" />
                                            </Button>
                                            <Button icon="pi pi-ellipsis-v" text size="small" severity="secondary" @click="showActionMenu" title="More actions" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="p-3 md:p-6">
                            <div class="text-sm md:text-base text-surface-700 dark:text-surface-300 leading-relaxed break-words overflow-hidden" v-html="message.content || currentEmail?.fullContent" />
                        </div>

                        <div class="px-3 md:px-6 pb-3 md:pb-4 flex flex-col sm:flex-row items-stretch sm:items-center gap-2" v-if="index === (currentEmail?.thread?.length || 1) - 1">
                            <Button label="Reply" severity="secondary" outlined size="small" @click="toggleReply" class="w-full sm:w-auto">
                                <template #icon>
                                    <i class="pi pi-reply flip-icon-horizontal" />
                                </template>
                            </Button>
                            <Button label="Forward" icon="pi pi-reply" severity="secondary" outlined size="small" class="w-full sm:w-auto" />
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div v-if="showReplyEditor" class="px-3 md:px-6 mb-4 md:mb-6">
            <div class="bg-surface-0 dark:bg-surface-800 border border-surface-200 dark:border-surface-700 rounded-lg shadow-sm">
                <div class="p-3 md:p-4 border-b border-surface-200 dark:border-surface-700 flex items-center justify-between">
                    <div class="flex items-center gap-2 md:gap-3 min-w-0">
                        <Avatar :image="'/demo/images/avatar/avatar-square-m-2.jpg'" size="normal" shape="square" class="w-6 h-6 md:w-8 md:h-8 shrink-0 rounded-lg!" :pt="{ image: { class: 'rounded-lg!' } }" />
                        <div class="min-w-0">
                            <div class="text-surface-900 dark:text-surface-0 font-medium text-sm md:text-base">Robert Fox</div>
                            <div class="text-xs md:text-sm text-surface-500 dark:text-surface-400 truncate">to {{ currentEmail?.sender }}</div>
                        </div>
                    </div>
                    <Button icon="pi pi-times" text severity="secondary" size="small" @click="showReplyEditor = false" class="shrink-0" />
                </div>

                <div class="p-3 md:p-4">
                    <Textarea
                        v-model="replyMessage"
                        :rows="6"
                        placeholder="Type your reply..."
                        class="w-full border-0 resize-none text-sm md:text-base"
                        :pt="{
                            root: { class: 'border-0 shadow-none focus:shadow-none' }
                        }"
                    />
                </div>

                <div class="p-3 md:p-4 border-t border-surface-200 dark:border-surface-700 flex flex-col sm:flex-row items-stretch sm:items-center justify-between gap-3 sm:gap-0">
                    <div class="flex items-center gap-1 justify-center sm:justify-start">
                        <Button icon="pi pi-paperclip" text size="small" severity="secondary" title="Attach files" />
                        <Button icon="pi pi-image" text size="small" severity="secondary" title="Insert photo" />
                        <Button icon="pi pi-link" text size="small" severity="secondary" title="Insert link" class="hidden sm:inline-flex" />
                        <Button icon="pi pi-face-smile" text size="small" severity="secondary" title="Insert emoji" class="hidden sm:inline-flex" />
                    </div>
                    <div class="flex items-center gap-2">
                        <Button label="Send" icon="pi pi-send" @click="sendReply" class="w-full sm:w-auto" />
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="p-3 md:p-6 border-t border-surface-200 dark:border-surface-700 bg-surface-0 dark:bg-surface-900">
        <Button label="Reply" severity="secondary" outlined @click="showReplyEditor = true" class="w-full sm:w-auto">
            <template #icon>
                <i class="pi pi-reply flip-icon-horizontal" />
            </template>
        </Button>
    </div>

    <Menu ref="actionMenu" :model="actionMenuItems" :popup="true" />

    <OverlayPanel ref="recipientPanel" class="w-80">
        <div class="p-4">
            <div class="flex items-center gap-3 mb-4">
                <Avatar :label="getAvatarInitials(currentEmail?.sender || '')" size="normal" class="w-10 h-10 bg-primary-100 text-primary-600" />
                <div>
                    <div class="font-medium text-surface-900 dark:text-surface-0">{{ currentEmail?.sender }}</div>
                    <div class="text-sm text-surface-500 dark:text-surface-400">&lt;{{ currentEmail?.email }}&gt;</div>
                </div>
            </div>
            <div class="space-y-2 text-sm">
                <div><strong>From:</strong> {{ currentEmail?.sender }} &lt;{{ currentEmail?.email }}&gt;</div>
                <div><strong>To:</strong> Robert Fox</div>
                <div><strong>Date:</strong> {{ currentEmail?.thread?.[0]?.time }}</div>
                <div><strong>Subject:</strong> {{ currentEmail?.subject }}</div>
            </div>
        </div>
    </OverlayPanel>
</template>
<style scoped>
.flip-icon-horizontal {
    transform: scaleX(-1);
}
</style>
