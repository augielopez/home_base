<script setup>
import { computed, ref } from 'vue';

const sidebarVisible = ref(false);
const title = ref('The Smartest Ways to Earn Airline Miles');
const content = ref(
    'Your credit score plays a crucial role in your financial well-being, influencing your ability to secure loans, mortgages, and even rental agreements. A higher score can unlock better interest rates and financial flexibility. Understanding how to improve and maintain a strong credit score is essential for achieving financial stability. Here are five golden rules to help you boost your score effectively.'
);
const status = ref('Draft');
const visibility = ref('Public');
const publishDate = ref(new Date());
const selectedAuthors = ref([{ name: 'Dianne Russell', image: '/demo/images/cms/avatars/avatar-dianne.jpg' }]);
const selectedCategories = ref(['Lifestyle', 'Art', 'Banking']);
const selectedTags = ref(['World', 'Space']);

const tagOptions = ref(['World', 'Space', 'Technology', 'Science', 'Nature', 'Travel', 'Art', 'Music', 'Food', 'Sports']);

const accordionValue = ref(['status', 'visibility', 'publish-date']);

const statusOptions = ref([
    { label: 'Draft', value: 'Draft' },
    { label: 'Published', value: 'Published' },
    { label: 'Scheduled', value: 'Scheduled' }
]);

const authorOptions = ref([
    { name: 'Dianne Russell', image: '/demo/images/cms/avatars/avatar-dianne.jpg' },
    { name: 'Jane Smith', image: '/demo/images/cms/avatars/avatar-jane.jpg' },
    { name: 'Darrell Steward', image: '/demo/images/cms/avatars/avatar-darrell.jpg' },
    { name: 'Emma Wilson', image: '/demo/images/cms/avatars/avatar-emma.jpg' },
    { name: 'Ethan Hunt', image: '/demo/images/cms/avatars/avatar-ethan.jpg' },
    { name: 'Sophia Chen', image: '/demo/images/cms/avatars/avatar-sophia.jpg' }
]);

const categories = ref(['Lifestyle', 'Sustainability', 'Culture', 'Art', 'Banking', 'Technology']);

const coverImage = ref('/demo/images/cms/cms-hero-1.jpg');
const fileInput = ref(null);

const formattedPublishDate = computed(() => {
    if (!publishDate.value) return 'Immediately';
    const date = new Date(publishDate.value);
    const options = { month: 'short', day: 'numeric', year: 'numeric' };
    return date.toLocaleDateString('en-US', options);
});

function removeCoverImage() {
    coverImage.value = null;
}

function triggerFileUpload() {
    fileInput.value?.click();
}

function handleFileUpload(event) {
    const file = event.target.files[0];
    if (file && file.type.startsWith('image/')) {
        const reader = new FileReader();
        reader.onload = (e) => {
            coverImage.value = e.target.result;
        };
        reader.readAsDataURL(file);
    }
}

function removeAuthor(event, authorToRemove) {
    event.stopPropagation();
    selectedAuthors.value = selectedAuthors.value.filter((author) => author.name !== authorToRemove.name);
}
</script>

<template>
    <div class="flex flex-col min-h-screen overflow-hidden card">
        <div class="p-6 border-b border-surface-200 dark:border-surface-700 flex justify-between items-center gap-4">
            <h1 class="flex-1 text-surface-900 dark:text-surface-0 text-lg font-medium">Create a new post</h1>
            <Button icon="pi pi-bars" severity="secondary" @click="sidebarVisible = true" class="flex! xl:hidden!" />
        </div>

        <div class="flex flex-1 overflow-hidden">
            <div class="flex-1 p-6 flex flex-col gap-6 min-w-0 overflow-auto">
                <div class="flex flex-col gap-2">
                    <label class="text-surface-900 dark:text-surface-0 text-base font-medium">Cover</label>
                    <div class="relative h-[19rem] rounded-2xl border border-surface-200 dark:border-surface-700 overflow-hidden">
                        <template v-if="coverImage">
                            <img :src="coverImage" alt="Cover image" class="w-full h-full object-cover" />
                            <div class="absolute inset-0 bg-linear-to-b from-transparent to-black/30" />
                            <div class="absolute top-[18px] right-[18px]">
                                <Button icon="pi pi-trash" severity="secondary" size="small" class="text-red-500! dark:text-red-400!" @click="removeCoverImage" />
                            </div>
                        </template>
                        <template v-else>
                            <div class="w-full h-full bg-surface-100 dark:bg-surface-800 flex flex-col items-center justify-center gap-4 cursor-pointer hover:bg-surface-200 dark:hover:bg-surface-700 transition-colors" @click="triggerFileUpload">
                                <div class="w-12 h-12 rounded-full bg-surface-200 dark:bg-surface-600 flex items-center justify-center">
                                    <i class="pi pi-cloud-upload text-surface-600 dark:text-surface-300 text-xl" />
                                </div>
                                <div class="text-center">
                                    <div class="text-surface-900 dark:text-surface-0 text-base font-medium mb-1">Click to upload cover image</div>
                                    <div class="text-surface-500 dark:text-surface-400 text-sm">PNG, JPG or WebP (max 5MB)</div>
                                </div>
                            </div>
                        </template>
                        <input ref="fileInput" type="file" accept="image/*" @change="handleFileUpload" class="hidden" />
                    </div>
                </div>

                <div class="flex flex-col gap-2">
                    <label class="text-surface-900 dark:text-surface-0 text-base font-medium">Title</label>
                    <InputText v-model="title" placeholder="The Smartest Ways to Earn Airline Miles" />
                </div>

                <div class="flex-1 flex flex-col gap-2 min-w-0">
                    <label class="text-surface-900 dark:text-surface-0 text-base font-medium">Content</label>
                    <Editor v-model="content" editorStyle="min-height: 320px; padding-top:0; overflow-wrap: break-word; word-break: break-word;" class="min-w-0!" />
                </div>
            </div>

            <div class="hidden xl:block w-[309px] p-6 bg-surface-0 dark:bg-surface-900 border-l border-surface-200 dark:border-surface-700">
                <div class="flex flex-col gap-6">
                    <div class="flex gap-4">
                        <Button label="Save Draft" outlined severity="secondary" class="flex-1" />
                        <Button label="Publish" severity="primary" class="flex-1" />
                    </div>

                    <div class="w-full border-t border-dashed border-surface-200 dark:border-surface-700" />

                    <div class="flex flex-col gap-4">
                        <div class="flex justify-start items-start gap-2">
                            <span class="flex-1 text-surface-900 dark:text-surface-0 text-base font-medium">Publish</span>
                            <a href="#" class="text-primary-600 dark:text-primary-400 text-base font-medium underline">Preview</a>
                        </div>
                    </div>

                    <Accordion
                        :multiple="true"
                        v-model:value="accordionValue"
                        :pt="{
                            root: { class: 'border-0! shadow-none!' }
                        }"
                        expandIcon="pi pi-chevron-down text-primary!"
                        collapseIcon="pi pi-chevron-up text-primary!"
                    >
                        <AccordionPanel value="status" :pt="{ root: { class: 'border-0! ' } }">
                            <AccordionHeader
                                :pt="{
                                    root: { class: 'bg-transparent! border-0! p-0! py-4! shadow-none!' },
                                    content: { class: 'justify-start items-center w-full px-0' }
                                }"
                            >
                                <template #default>
                                    <div class="flex justify-start items-center gap-2 w-full">
                                        <span class="text-surface-900 dark:text-surface-0 text-base font-medium">Status:</span>
                                        <span class="flex-1 text-primary-600 dark:text-primary-400 text-base font-medium">{{ status }}</span>
                                    </div>
                                </template>
                            </AccordionHeader>
                            <AccordionContent
                                :pt="{
                                    content: { class: 'bg-transparent! border-0! p-0! pb-4!' }
                                }"
                            >
                                <Select v-model="status" :options="statusOptions" optionLabel="label" optionValue="value" class="w-full!" />
                            </AccordionContent>
                        </AccordionPanel>
                        <div class="w-full border-t border-dashed border-surface-200 dark:border-surface-700" />
                        <AccordionPanel value="visibility" :pt="{ root: { class: 'border-0! ' } }">
                            <AccordionHeader
                                :pt="{
                                    root: { class: 'bg-transparent! border-0! p-0! py-4! shadow-none!' },
                                    content: { class: 'justify-start items-center w-full px-0' }
                                }"
                            >
                                <template #default>
                                    <div class="flex justify-start items-center gap-2 w-full">
                                        <span class="text-surface-900 dark:text-surface-0 text-base font-medium">Visibility:</span>
                                        <span class="flex-1 text-primary-600 dark:text-primary-400 text-base font-medium">{{ visibility }}</span>
                                    </div>
                                </template>
                            </AccordionHeader>
                            <AccordionContent
                                :pt="{
                                    content: { class: 'bg-transparent! border-0! p-0! pb-4!' }
                                }"
                            >
                                <div class="flex flex-col gap-3">
                                    <div class="flex items-center gap-2">
                                        <RadioButton v-model="visibility" inputId="public" value="Public" />
                                        <label for="public" class="text-surface-900 dark:text-surface-0 text-base">Public</label>
                                    </div>
                                    <div class="flex items-center gap-2">
                                        <RadioButton v-model="visibility" inputId="password" value="Password protected" />
                                        <label for="password" class="text-surface-900 dark:text-surface-0 text-base">Password protected</label>
                                    </div>
                                    <div class="flex items-center gap-2">
                                        <RadioButton v-model="visibility" inputId="private" value="Private" />
                                        <label for="private" class="text-surface-900 dark:text-surface-0 text-base">Private</label>
                                    </div>
                                </div>
                            </AccordionContent>
                        </AccordionPanel>
                        <div class="w-full border-t border-dashed border-surface-200 dark:border-surface-700" />
                        <AccordionPanel value="publish-date" :pt="{ root: { class: 'border-0! ' } }">
                            <AccordionHeader
                                :pt="{
                                    root: { class: 'bg-transparent! border-0! p-0! py-4! shadow-none!' },
                                    content: { class: 'justify-start items-center w-full px-0' }
                                }"
                            >
                                <template #default>
                                    <div class="flex justify-start items-center gap-2 w-full">
                                        <span class="text-surface-900 dark:text-surface-0 text-base font-medium">Publish:</span>
                                        <span class="flex-1 text-primary-600 dark:text-primary-400 text-base font-medium">{{ formattedPublishDate }}</span>
                                    </div>
                                </template>
                            </AccordionHeader>
                            <AccordionContent
                                :pt="{
                                    content: { class: 'bg-transparent! border-0! p-0! pb-4!' }
                                }"
                            >
                                <DatePicker v-model="publishDate" showIcon fluid />
                            </AccordionContent>
                        </AccordionPanel>
                    </Accordion>

                    <div class="w-full border-t border-dashed border-surface-200 dark:border-surface-700" />

                    <div class="flex flex-col gap-2">
                        <label class="text-surface-900 dark:text-surface-0 text-base font-medium">Author</label>
                        <MultiSelect v-model="selectedAuthors" :options="authorOptions" optionLabel="name" placeholder="Select authors">
                            <template #value="slotProps">
                                <div class="flex gap-1 overflow-hidden min-h-[2rem]" v-if="slotProps.value && slotProps.value.length > 0">
                                    <Chip v-for="author in slotProps.value" :key="author.name" :label="author.name" :image="author.image" removable class="shrink-0!" @remove="(event) => removeAuthor(event, author)" />
                                </div>
                                <span v-else class="text-surface-500 min-h-[2rem] flex items-center">Select authors</span>
                            </template>
                        </MultiSelect>
                    </div>

                    <div class="w-full border-t border-dashed border-surface-200 dark:border-surface-700" />

                    <div class="flex flex-col gap-4">
                        <label class="text-surface-900 dark:text-surface-0 text-base font-medium">Category</label>
                        <div class="flex flex-col gap-3">
                            <div v-for="category in categories" :key="category" class="flex items-center gap-2">
                                <Checkbox v-model="selectedCategories" :inputId="category" :value="category" />
                                <label :for="category" class="text-surface-900 dark:text-surface-0 text-base">{{ category }}</label>
                            </div>
                        </div>
                    </div>

                    <div class="w-full border-t border-dashed border-surface-200 dark:border-surface-700" />

                    <div class="flex flex-col gap-2">
                        <label class="text-surface-900 dark:text-surface-0 text-base font-medium">Tag</label>
                        <MultiSelect v-model="selectedTags" :options="tagOptions" placeholder="Select tags" display="chip" class="w-full!" />
                    </div>

                    <div class="w-full border-t border-dashed border-surface-200 dark:border-surface-700" />

                    <Button label="Move to trash" icon="pi pi-trash" severity="danger" outlined />
                </div>
            </div>
        </div>

        <Drawer v-model:visible="sidebarVisible" position="right" class="w-full! max-w-md!">
            <template #header>
                <h3 class="text-surface-900 dark:text-surface-0 text-lg font-medium">Publishing Settings</h3>
            </template>

            <div class="flex flex-col gap-6 p-4 px-2">
                <div class="flex gap-4">
                    <Button label="Save Draft" outlined severity="secondary" class="flex-1" />
                    <Button label="Publish" severity="primary" class="flex-1" />
                </div>

                <div class="w-full border-t border-dashed border-surface-200 dark:border-surface-700" />

                <div class="flex flex-col gap-4">
                    <div class="flex justify-start items-start gap-2">
                        <span class="flex-1 text-surface-900 dark:text-surface-0 text-base font-medium">Publish</span>
                        <a href="#" class="text-primary-600 dark:text-primary-400 text-base font-medium underline">Preview</a>
                    </div>
                </div>

                <Accordion
                    :multiple="true"
                    v-model:value="accordionValue"
                    :pt="{
                        root: { class: 'border-0! shadow-none!' }
                    }"
                    expandIcon="pi pi-chevron-down text-primary!"
                    collapseIcon="pi pi-chevron-up text-primary!"
                >
                    <AccordionPanel value="status" :pt="{ root: { class: 'border-0! ' } }">
                        <AccordionHeader
                            :pt="{
                                root: { class: 'bg-transparent! border-0! p-0! py-4! shadow-none!' },
                                content: { class: 'justify-start items-center w-full px-0' }
                            }"
                        >
                            <template #default>
                                <div class="flex justify-start items-center gap-2 w-full">
                                    <span class="text-surface-900 dark:text-surface-0 text-base font-medium">Status:</span>
                                    <span class="flex-1 text-primary-600 dark:text-primary-400 text-base font-medium">{{ status }}</span>
                                </div>
                            </template>
                        </AccordionHeader>
                        <AccordionContent
                            :pt="{
                                content: { class: 'bg-transparent! border-0! p-0! pb-4!' }
                            }"
                        >
                            <Select v-model="status" :options="statusOptions" optionLabel="label" optionValue="value" class="w-full!" />
                        </AccordionContent>
                    </AccordionPanel>
                    <div class="w-full border-t border-dashed border-surface-200 dark:border-surface-700" />
                    <AccordionPanel value="visibility" :pt="{ root: { class: 'border-0! ' } }">
                        <AccordionHeader
                            :pt="{
                                root: { class: 'bg-transparent! border-0! p-0! py-4! shadow-none!' },
                                content: { class: 'justify-start items-center w-full px-0' }
                            }"
                        >
                            <template #default>
                                <div class="flex justify-start items-center gap-2 w-full">
                                    <span class="text-surface-900 dark:text-surface-0 text-base font-medium">Visibility:</span>
                                    <span class="flex-1 text-primary-600 dark:text-primary-400 text-base font-medium">{{ visibility }}</span>
                                </div>
                            </template>
                        </AccordionHeader>
                        <AccordionContent
                            :pt="{
                                content: { class: 'bg-transparent! border-0! p-0! pb-4!' }
                            }"
                        >
                            <div class="flex flex-col gap-3">
                                <div class="flex items-center gap-2">
                                    <RadioButton v-model="visibility" inputId="mobile-public" value="Public" />
                                    <label for="mobile-public" class="text-surface-900 dark:text-surface-0 text-base">Public</label>
                                </div>
                                <div class="flex items-center gap-2">
                                    <RadioButton v-model="visibility" inputId="mobile-password" value="Password protected" />
                                    <label for="mobile-password" class="text-surface-900 dark:text-surface-0 text-base">Password protected</label>
                                </div>
                                <div class="flex items-center gap-2">
                                    <RadioButton v-model="visibility" inputId="mobile-private" value="Private" />
                                    <label for="mobile-private" class="text-surface-900 dark:text-surface-0 text-base">Private</label>
                                </div>
                            </div>
                        </AccordionContent>
                    </AccordionPanel>
                    <div class="w-full border-t border-dashed border-surface-200 dark:border-surface-700" />
                    <AccordionPanel value="publish-date" :pt="{ root: { class: 'border-0! ' } }">
                        <AccordionHeader
                            :pt="{
                                root: { class: 'bg-transparent! border-0! p-0! py-4! shadow-none!' },
                                content: { class: 'justify-start items-center w-full px-0' }
                            }"
                        >
                            <template #default>
                                <div class="flex justify-start items-center gap-2 w-full">
                                    <span class="text-surface-900 dark:text-surface-0 text-base font-medium">Publish:</span>
                                    <span class="flex-1 text-primary-600 dark:text-primary-400 text-base font-medium">{{ formattedPublishDate }}</span>
                                </div>
                            </template>
                        </AccordionHeader>
                        <AccordionContent
                            :pt="{
                                content: { class: 'bg-transparent! border-0! p-0! pb-4!' }
                            }"
                        >
                            <DatePicker v-model="publishDate" showIcon class="w-full!" />
                        </AccordionContent>
                    </AccordionPanel>
                </Accordion>

                <div class="w-full border-t border-dashed border-surface-200 dark:border-surface-700" />

                <div class="flex flex-col gap-2">
                    <label class="text-surface-900 dark:text-surface-0 text-base font-medium">Author</label>
                    <MultiSelect v-model="selectedAuthors" :options="authorOptions" optionLabel="name" placeholder="Select authors">
                        <template #value="slotProps">
                            <div class="flex gap-1 overflow-hidden min-h-[2rem]" v-if="slotProps.value && slotProps.value.length > 0">
                                <Chip v-for="author in slotProps.value" :key="author.name" :label="author.name" :image="author.image" removable class="shrink-0!" @remove="(event) => removeAuthor(event, author)" />
                            </div>
                            <span v-else class="text-surface-500 min-h-[2rem] flex items-center">Select authors</span>
                        </template>
                    </MultiSelect>
                </div>

                <div class="w-full border-t border-dashed border-surface-200 dark:border-surface-700" />

                <div class="flex flex-col gap-4">
                    <label class="text-surface-900 dark:text-surface-0 text-base font-medium">Category</label>
                    <div class="flex flex-col gap-3">
                        <div v-for="category in categories" :key="category" class="flex items-center gap-2">
                            <Checkbox v-model="selectedCategories" :inputId="'mobile-' + category" :value="category" />
                            <label :for="'mobile-' + category" class="text-surface-900 dark:text-surface-0 text-base">{{ category }}</label>
                        </div>
                    </div>
                </div>

                <div class="w-full border-t border-dashed border-surface-200 dark:border-surface-700" />

                <div class="flex flex-col gap-2">
                    <label class="text-surface-900 dark:text-surface-0 text-base font-medium">Tag</label>
                    <MultiSelect v-model="selectedTags" :options="tagOptions" placeholder="Select tags" display="chip" class="w-full!" />
                </div>

                <div class="w-full border-t border-dashed border-surface-200 dark:border-surface-700" />

                <Button label="Move to trash" icon="pi pi-trash" severity="danger" outlined />
            </div>
        </Drawer>
    </div>
</template>
