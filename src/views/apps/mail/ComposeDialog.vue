<script setup>
import { computed, ref } from 'vue';

const props = defineProps({
    visible: {
        type: Boolean,
        default: false
    },
    initialData: {
        type: Object,
        default: () => ({
            to: '',
            subject: '',
            message: ''
        })
    }
});

const emit = defineEmits(['update:visible', 'send', 'close']);

const isVisible = computed({
    get: () => props.visible,
    set: (value) => emit('update:visible', value)
});

const composeData = ref({
    to: props.initialData.to || '',
    subject: props.initialData.subject || '',
    message: props.initialData.message || ''
});

const closeCompose = () => {
    emit('close');
    emit('update:visible', false);
};

const sendEmail = () => {
    emit('send', { ...composeData.value });
    closeCompose();
};

const onHide = () => {
    closeCompose();
};
</script>

<template>
    <Dialog
        v-model:visible="isVisible"
        :modal="false"
        :closable="false"
        :draggable="false"
        position="bottom-right"
        class="w-[360px] md:w-[640px]"
        @hide="onHide"
        :pt="{
            root: { class: 'rounded-lg fixed! bottom-4! right-4! transform-none! m-0! shadow-lg' },
            header: { class: 'hidden!' },
            content: { class: 'p-0!' }
        }"
    >
        <div class="">
            <div class="p-3 md:p-4 border-b border-surface-200 dark:border-surface-700 flex items-center justify-between">
                <div class="flex items-center gap-2 md:gap-3 min-w-0">
                    <Avatar :image="'/demo/images/avatar/avatar-square-m-2.jpg'" size="normal" class="w-6 h-6 md:w-8 md:h-8 shrink-0" />
                    <div class="min-w-0">
                        <div class="text-surface-900 dark:text-surface-0 font-medium text-sm md:text-base">Robert Fox</div>
                        <div class="text-xs md:text-sm text-surface-500 dark:text-surface-400">Compose</div>
                    </div>
                </div>
                <Button icon="pi pi-times" text severity="secondary" size="small" @click="closeCompose" class="shrink-0" />
            </div>

            <div class="px-3 md:px-4 py-2 border-b border-surface-200 dark:border-surface-700 flex items-center gap-3">
                <label class="text-sm text-surface-600 dark:text-surface-300 font-medium min-w-0 shrink-0">To:</label>
                <InputText v-model="composeData.to" class="flex-1 text-sm" :pt="{ root: { class: 'border-0! shadow-none! focus:shadow-none bg-transparent p-0' } }" />
            </div>

            <div class="px-3 md:px-4 py-2 border-b border-surface-200 dark:border-surface-700 flex items-center gap-3">
                <label class="text-sm text-surface-600 dark:text-surface-300 font-medium min-w-0 shrink-0">Subject:</label>
                <InputText v-model="composeData.subject" class="flex-1 text-sm" :pt="{ root: { class: 'border-0! shadow-none! focus:shadow-none bg-transparent p-0' } }" />
            </div>

            <div class="p-3 md:p-4">
                <Textarea
                    v-model="composeData.message"
                    :rows="8"
                    placeholder="Compose your message..."
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
                <div class="flex items-center gap-2 w-full sm:w-auto">
                    <Button label="Discard" severity="secondary" outlined @click="closeCompose" class="flex-1 sm:flex-none" />
                    <Button label="Send" icon="pi pi-send" @click="sendEmail" class="flex-1 sm:flex-none" />
                </div>
            </div>
        </div>
    </Dialog>
</template>
