<script setup>
import { computed, onMounted, ref } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import ComposeDialog from './ComposeDialog.vue';

const router = useRouter();
const route = useRoute();

const selectedEmails = ref([]);
const selectAll = ref(false);

const selectedMenuItem = ref('Inbox');
const selectedCategory = ref(null);
const showComposeOverlay = ref(false);
const showMenuDrawer = ref(false);
const searchQuery = ref('');

const emailsData = ref([]);
const menuItems = ref([]);
const categoryItems = ref([]);

const getInboxEmails = (emailList) => {
    return emailList.filter((email) => !email.deleted && !email.spam && !email.archived);
};

const getStarredEmails = (emailList) => {
    return emailList.filter((email) => email.starred && !email.deleted && !email.spam);
};

const getImportantEmails = (emailList) => {
    return emailList.filter((email) => email.important && !email.deleted && !email.spam);
};

const getArchivedEmails = (emailList) => {
    return emailList.filter((email) => email.archived && !email.deleted);
};

const getSpamEmails = (emailList) => {
    return emailList.filter((email) => email.spam && !email.deleted);
};

const getDeletedEmails = (emailList) => {
    return emailList.filter((email) => email.deleted);
};

const getCategoryEmails = (emailList, category) => {
    return emailList.filter((email) => email.category === category && !email.deleted && !email.spam && !email.archived);
};

const getUnreadInboxEmails = (emailList) => {
    return emailList.filter((email) => !email.deleted && !email.spam && !email.archived && !email.read);
};

const getUnreadStarredEmails = (emailList) => {
    return emailList.filter((email) => email.starred && !email.deleted && !email.spam && !email.read);
};

const getUnreadImportantEmails = (emailList) => {
    return emailList.filter((email) => email.important && !email.deleted && !email.spam && !email.read);
};

const getUnreadArchivedEmails = (emailList) => {
    return emailList.filter((email) => email.archived && !email.deleted && !email.read);
};

const getUnreadSpamEmails = (emailList) => {
    return emailList.filter((email) => email.spam && !email.deleted && !email.read);
};

const getUnreadDeletedEmails = (emailList) => {
    return emailList.filter((email) => email.deleted && !email.read);
};

const getUnreadCategoryEmails = (emailList, category) => {
    return emailList.filter((email) => email.category === category && !email.deleted && !email.spam && !email.archived && !email.read);
};

const baseFilteredEmails = computed(() => {
    if (selectedMenuItem.value) {
        switch (selectedMenuItem.value) {
            case 'Inbox':
                return getInboxEmails(emailsData.value);
            case 'Starred':
                return getStarredEmails(emailsData.value);
            case 'Important':
                return getImportantEmails(emailsData.value);
            case 'Sent':
                return [];
            case 'Archived':
                return getArchivedEmails(emailsData.value);
            case 'Spam':
                return getSpamEmails(emailsData.value);
            case 'Trash':
                return getDeletedEmails(emailsData.value);
            default:
                return getInboxEmails(emailsData.value);
        }
    } else if (selectedCategory.value) {
        return getCategoryEmails(emailsData.value, selectedCategory.value);
    }
    return getInboxEmails(emailsData.value);
});

const filteredEmails = computed(() => {
    const emails = baseFilteredEmails.value;

    if (!searchQuery.value.trim()) {
        return emails;
    }

    const query = searchQuery.value.toLowerCase().trim();
    return emails.filter((email) => email.sender.toLowerCase().includes(query));
});

const first = ref(0);
const rows = ref(15);

const actionMenu = ref();
const bulkActionMenu = ref();
const selectedEmailId = ref(null);
const selectedEmailData = ref(null);
const actionMenuItems = computed(() => {
    const email = selectedEmailData.value;
    const isInTrash = email?.deleted;

    if (isInTrash) {
        return [{ label: 'Recover', icon: 'pi pi-replay', command: () => recoverEmail(selectedEmailId.value) }];
    }

    return [
        { label: 'Forward', icon: 'pi pi-reply', command: () => {} },
        {
            label: email?.archived ? 'Unarchive' : 'Archive',
            icon: email?.archived ? 'pi pi-replay' : 'pi pi-inbox',
            command: () => (email?.archived ? unarchiveEmail(selectedEmailId.value) : archiveEmail(selectedEmailId.value))
        },
        { label: 'Spam', icon: 'pi pi-ban', command: () => markAsSpam(selectedEmailId.value) },
        { label: 'Delete', icon: 'pi pi-trash', command: () => deleteEmail(selectedEmailId.value) }
    ];
});

const bulkActionMenuItems = computed(() => {
    const hasArchivedEmails = selectedEmails.value.some((email) => email.archived);
    const hasNonArchivedEmails = selectedEmails.value.some((email) => !email.archived);
    const hasDeletedEmails = selectedEmails.value.some((email) => email.deleted);

    if (selectedMenuItem.value === 'Trash' || hasDeletedEmails) {
        return [
            {
                label: 'Recover',
                icon: 'pi pi-replay',
                command: () => bulkRecover()
            }
        ];
    }

    return [
        {
            label: 'Mark as Read',
            icon: 'pi pi-eye',
            command: () => bulkMarkAsRead()
        },
        {
            label: 'Mark as Unread',
            icon: 'pi pi-eye-slash',
            command: () => bulkMarkAsUnread()
        },
        { separator: true },
        {
            label: 'Star',
            icon: 'pi pi-star',
            command: () => bulkToggleStar(true)
        },
        {
            label: 'Unstar',
            icon: 'pi pi-star-fill',
            command: () => bulkToggleStar(false)
        },
        { separator: true },
        {
            label: 'Mark as Important',
            icon: 'pi pi-bookmark',
            command: () => bulkToggleImportant(true)
        },
        {
            label: 'Mark as Not Important',
            icon: 'pi pi-bookmark-fill',
            command: () => bulkToggleImportant(false)
        },
        { separator: true },
        ...(hasNonArchivedEmails
            ? [
                  {
                      label: 'Archive',
                      icon: 'pi pi-inbox',
                      command: () => bulkArchive()
                  }
              ]
            : []),
        ...(hasArchivedEmails
            ? [
                  {
                      label: 'Unarchive',
                      icon: 'pi pi-replay',
                      command: () => bulkUnarchive()
                  }
              ]
            : []),
        {
            label: 'Mark as Spam',
            icon: 'pi pi-ban',
            command: () => bulkMarkAsSpam()
        },
        {
            label: 'Delete',
            icon: 'pi pi-trash',
            command: () => bulkDelete()
        }
    ];
});

const getAvatarInitials = (name) => {
    return name
        .split(' ')
        .map((n) => n[0])
        .join('')
        .toUpperCase();
};

const getAvatarColor = (name) => {
    const colors = ['bg-violet-100 text-violet-950', 'bg-lime-100 text-lime-950', 'bg-red-100 text-rose-950', 'bg-cyan-100 text-cyan-950', 'bg-indigo-100 text-indigo-950'];
    const index = name.charCodeAt(0) % colors.length;
    return colors[index];
};

const paginatedEmails = computed(() => {
    const start = first.value;
    const end = start + rows.value;
    return filteredEmails.value.slice(start, end);
});

const onPageChange = (event) => {
    first.value = event.first;
};

const toggleActionMenu = (event, emailId) => {
    selectedEmailId.value = emailId;
    selectedEmailData.value = emailsData.value.find((e) => e.id === emailId);
    actionMenu.value.toggle(event);
};

const openCompose = () => {
    showComposeOverlay.value = true;
};

const closeCompose = () => {
    showComposeOverlay.value = false;
};

const sendEmail = () => {
    closeCompose();
};

const navigateToEmail = (email) => {
    if (!email.read) {
        const emailInData = emailsData.value.find((e) => e.id === email.id);
        if (emailInData) {
            emailInData.read = true;
        }
    }
    const from = selectedMenuItem.value || selectedCategory.value || 'Inbox';
    router.push({
        path: `/apps/mail/detail/${email.id}`,
        query: { from }
    });
};

const toggleMenuDrawer = () => {
    showMenuDrawer.value = !showMenuDrawer.value;
};

const menuItemsWithCounts = computed(() => {
    return menuItems.value.map((item) => ({
        ...item,
        count: getMenuItemCount(item.label)
    }));
});

const categoryItemsWithCounts = computed(() => {
    return categoryItems.value.map((item) => ({
        ...item,
        count: getCategoryItemCount(item.label)
    }));
});

const getMenuItemCount = (label) => {
    switch (label) {
        case 'Inbox':
            return getUnreadInboxEmails(emailsData.value).length;
        case 'Starred':
            return getUnreadStarredEmails(emailsData.value).length;
        case 'Important':
            return getUnreadImportantEmails(emailsData.value).length;
        case 'Sent':
            return 0;
        case 'Archived':
            return getUnreadArchivedEmails(emailsData.value).length;
        case 'Spam':
            return getUnreadSpamEmails(emailsData.value).length;
        case 'Trash':
            return getUnreadDeletedEmails(emailsData.value).length;
        default:
            return 0;
    }
};

const getCategoryItemCount = (label) => {
    const unreadCategoryEmails = getUnreadCategoryEmails(emailsData.value, label);
    return unreadCategoryEmails.length;
};

const toggleStar = (emailId) => {
    const email = emailsData.value.find((e) => e.id === emailId);
    if (email) {
        email.starred = !email.starred;
    }
};

const toggleImportant = (emailId) => {
    const email = emailsData.value.find((e) => e.id === emailId);
    if (email) {
        email.important = !email.important;
    }
};

const archiveEmail = (emailId) => {
    const email = emailsData.value.find((e) => e.id === emailId);
    if (email) {
        email.archived = true;
        email.selected = false;
    }
};

const unarchiveEmail = (emailId) => {
    const email = emailsData.value.find((e) => e.id === emailId);
    if (email) {
        email.archived = false;
        email.selected = false;
    }
};

const markAsSpam = (emailId) => {
    const email = emailsData.value.find((e) => e.id === emailId);
    if (email) {
        email.spam = true;
        email.selected = false;
    }
};

const deleteEmail = (emailId) => {
    const email = emailsData.value.find((e) => e.id === emailId);
    if (email) {
        email.deleted = true;
        email.selected = false;
    }
};

const recoverEmail = (emailId) => {
    const email = emailsData.value.find((e) => e.id === emailId);
    if (email) {
        email.deleted = false;
        email.spam = false;
        email.selected = false;
    }
};

const bulkMarkAsRead = () => {
    selectedEmails.value.forEach((email) => {
        const emailInData = emailsData.value.find((e) => e.id === email.id);
        if (emailInData) {
            emailInData.read = true;
        }
    });
    selectedEmails.value = [];
    selectAll.value = false;
};

const bulkMarkAsUnread = () => {
    selectedEmails.value.forEach((email) => {
        const emailInData = emailsData.value.find((e) => e.id === email.id);
        if (emailInData) {
            emailInData.read = false;
        }
    });
    selectedEmails.value = [];
    selectAll.value = false;
};

const bulkToggleStar = (starred) => {
    selectedEmails.value.forEach((email) => {
        const emailInData = emailsData.value.find((e) => e.id === email.id);
        if (emailInData) {
            emailInData.starred = starred;
        }
    });
    selectedEmails.value = [];
    selectAll.value = false;
};

const bulkToggleImportant = (important) => {
    selectedEmails.value.forEach((email) => {
        const emailInData = emailsData.value.find((e) => e.id === email.id);
        if (emailInData) {
            emailInData.important = important;
        }
    });
    selectedEmails.value = [];
    selectAll.value = false;
};

const bulkArchive = () => {
    selectedEmails.value.forEach((email) => {
        const emailInData = emailsData.value.find((e) => e.id === email.id);
        if (emailInData && !emailInData.archived) {
            emailInData.archived = true;
        }
    });
    selectedEmails.value = [];
    selectAll.value = false;
};

const bulkUnarchive = () => {
    selectedEmails.value.forEach((email) => {
        const emailInData = emailsData.value.find((e) => e.id === email.id);
        if (emailInData && emailInData.archived) {
            emailInData.archived = false;
        }
    });
    selectedEmails.value = [];
    selectAll.value = false;
};

const bulkMarkAsSpam = () => {
    selectedEmails.value.forEach((email) => {
        const emailInData = emailsData.value.find((e) => e.id === email.id);
        if (emailInData) {
            emailInData.spam = true;
        }
    });
    selectedEmails.value = [];
    selectAll.value = false;
};

const bulkDelete = () => {
    selectedEmails.value.forEach((email) => {
        const emailInData = emailsData.value.find((e) => e.id === email.id);
        if (emailInData) {
            emailInData.deleted = true;
        }
    });
    selectedEmails.value = [];
    selectAll.value = false;
};

const bulkRecover = () => {
    selectedEmails.value.forEach((email) => {
        const emailInData = emailsData.value.find((e) => e.id === email.id);
        if (emailInData && emailInData.deleted) {
            emailInData.deleted = false;
            emailInData.spam = false;
        }
    });
    selectedEmails.value = [];
    selectAll.value = false;
};

const toggleBulkActionMenu = (event) => {
    bulkActionMenu.value.toggle(event);
};

const selectMenuItem = (label) => {
    selectedMenuItem.value = label;
    selectedCategory.value = null;
    first.value = 0;
};

const selectCategory = (label) => {
    selectedCategory.value = label;
    selectedMenuItem.value = null;
    first.value = 0;
};

onMounted(async () => {
    const response = await fetch('/demo/data/emailData.json');
    const data = await response.json();

    emailsData.value = data.emails;
    menuItems.value = data.menuItems;
    categoryItems.value = data.categoryItems;

    const viewFromQuery = route.query.view;
    if (viewFromQuery) {
        const isMenuItem = menuItems.value.some((item) => item.label === viewFromQuery);
        const isCategoryItem = categoryItems.value.some((item) => item.label === viewFromQuery);

        if (isMenuItem) {
            selectedMenuItem.value = viewFromQuery;
            selectedCategory.value = null;
        } else if (isCategoryItem) {
            selectedCategory.value = viewFromQuery;
            selectedMenuItem.value = null;
        }
    }
});
</script>

<template>
    <div class="flex h-full relative card">
        <div class="hidden lg:flex w-[244px] bg-surface-0 dark:bg-surface-900 border-r border-surface-200 dark:border-surface-700 flex-col">
            <div class="px-4 py-5 border-b border-surface-200 dark:border-surface-700 h-[4.28rem]">
                <h2 class="text-lg font-medium text-surface-950 dark:text-surface-0">Mails</h2>
            </div>

            <div class="p-4 flex flex-col gap-6">
                <div class="flex flex-col gap-4">
                    <div class="text-sm font-medium text-surface-500 dark:text-surface-400 uppercase">Menu</div>
                    <div class="flex flex-col gap-1">
                        <div
                            v-for="item in menuItemsWithCounts"
                            :key="item.label"
                            :class="[
                                'flex items-center gap-2 px-3 py-2 rounded-lg cursor-pointer transition-colors',
                                selectedMenuItem === item.label ? 'bg-primary text-surface-0 dark:text-surface-900 shadow-sm' : 'text-surface-500 dark:text-surface-400 hover:bg-surface-100 dark:hover:bg-surface-700'
                            ]"
                            @click="selectMenuItem(item.label)"
                        >
                            <i :class="item.icon" class="text-xs" />
                            <span class="flex-1 text-base font-medium">{{ item.label }}</span>
                            <div
                                v-if="item.count > 0"
                                :class="['px-2 py-1 rounded-sm text-sm font-semibold text-xs', selectedMenuItem === item.label ? 'bg-white text-primary-600' : 'bg-surface-200 dark:bg-surface-600 text-surface-900 dark:text-surface-100']"
                            >
                                {{ item.count }}
                            </div>
                        </div>
                    </div>
                </div>

                <div class="h-px bg-surface-200 dark:bg-surface-700" />

                <div class="flex flex-col gap-4">
                    <div class="text-sm font-medium text-surface-500 dark:text-surface-400 uppercase">Categories</div>
                    <div class="flex flex-col gap-1">
                        <div
                            v-for="item in categoryItemsWithCounts"
                            :key="item.label"
                            :class="[
                                'flex items-center gap-2 px-3 py-2 rounded-lg cursor-pointer transition-colors',
                                selectedCategory === item.label ? 'bg-primary text-surface-0 dark:text-surface-900 shadow-sm' : 'text-surface-500 dark:text-surface-400 hover:bg-surface-100 dark:hover:bg-surface-700'
                            ]"
                            @click="selectCategory(item.label)"
                        >
                            <i :class="item.icon" class="text-xs" />
                            <span class="flex-1 text-base font-medium">{{ item.label }}</span>
                            <div
                                v-if="item.count > 0"
                                :class="['px-2 py-1 rounded-sm text-sm font-semibold text-xs', selectedCategory === item.label ? 'bg-white text-primary-600' : 'bg-surface-200 dark:bg-surface-600 text-surface-900 dark:text-surface-100']"
                            >
                                {{ item.count }}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="flex-1 flex flex-col h-full overflow-hidden">
            <div class="px-4 md:px-5 py-4 border-b border-surface-200 dark:border-surface-700 h-auto lg:h-[4.28rem]">
                <div class="flex items-center gap-3 md:gap-4">
                    <Button icon="pi pi-bars" severity="secondary" outlined @click="toggleMenuDrawer" class="lg:hidden! shrink-0" />

                    <div v-if="selectedEmails.length > 0" class="flex items-center gap-2 shrink-0">
                        <span class="text-sm text-surface-600 dark:text-surface-300 font-medium">{{ selectedEmails.length }} selected</span>
                        <Button icon="pi pi-ellipsis-v" severity="secondary" outlined size="small" @click="toggleBulkActionMenu" title="Bulk actions" />
                    </div>

                    <div class="flex-1 flex items-center justify-between gap-3" :class="selectedEmails.length > 0 ? 'opacity-50' : ''">
                        <IconField iconPosition="left" class="flex-1 max-w-full sm:max-w-[296px]">
                            <InputIcon class="pi pi-search" />
                            <InputText v-model="searchQuery" placeholder="Search mail" class="w-full" />
                        </IconField>

                        <div class="flex items-center gap-2 md:gap-3 shrink-0">
                            <Button label="Compose New" icon="pi pi-plus" severity="secondary" outlined class="hidden! xl:flex!" @click="openCompose" />
                            <Button icon="pi pi-plus" severity="secondary" outlined class="xl:hidden!" @click="openCompose" />
                        </div>
                    </div>
                </div>
            </div>

            <div class="flex-1 flex flex-col min-h-0">
                <DataTable
                    :value="paginatedEmails"
                    v-model:selection="selectedEmails"
                    dataKey="id"
                    tableStyle="min-width: 100%"
                    :paginator="false"
                    class="mail-table"
                    :scrollable="true"
                    scrollHeight="flex"
                    @row-click="navigateToEmail($event.data)"
                    :pt="{
                        bodyRow: {
                            class: 'cursor-pointer hover:bg-surface-50 dark:hover:bg-surface-700 transition-colors'
                        }
                    }"
                >
                    <Column selectionMode="multiple" headerStyle="width: 3rem" />

                    <Column field="sender" header="From" style="width: 220px">
                        <template #body="slotProps">
                            <div class="flex items-center gap-4" :class="slotProps.data.read ? 'opacity-60' : ''">
                                <div class="relative">
                                    <Avatar v-if="slotProps.data.avatar && slotProps.data.avatar.startsWith('/')" :image="slotProps.data.avatar" size="small" shape="square" class="rounded-lg!" :pt="{ image: { class: 'rounded-lg!' } }" />
                                    <Avatar v-else-if="slotProps.data.avatar" :label="slotProps.data.avatar" :class="getAvatarColor(slotProps.data.sender)" size="small" shape="square" class="rounded-lg!" />
                                    <Avatar v-else :label="getAvatarInitials(slotProps.data.sender)" :class="getAvatarColor(slotProps.data.sender)" size="small" shape="square" class="rounded-lg!" />
                                    <div class="absolute -top-1 -right-1 w-2 h-2 bg-red-500 rounded-full border-2 border-surface-0 dark:border-surface-800" />
                                </div>
                                <span class="font-medium text-surface-900 dark:text-surface-0">{{ slotProps.data.sender }}</span>
                            </div>
                        </template>
                    </Column>

                    <Column field="time" header="Time" style="width: 120px">
                        <template #body="slotProps">
                            <span class="text-sm text-surface-500 dark:text-surface-400" :class="slotProps.data.read ? 'opacity-60' : ''">{{ slotProps.data.time }}</span>
                        </template>
                    </Column>

                    <Column field="subject" header="Message" class="flex-1">
                        <template #body="slotProps">
                            <div class="flex items-end gap-2 w-full max-w-[200px] sm:max-w-[250px] md:max-w-[300px] lg:max-w-[400px] xl:max-w-[500px] 2xl:max-w-[600px]" :class="slotProps.data.read ? 'opacity-60' : ''">
                                <span class="font-normal text-surface-900 dark:text-surface-0 text-sm whitespace-nowrap">{{ slotProps.data.subject }}</span>
                                <span class="flex-1 text-surface-500 dark:text-surface-400 text-sm truncate">{{ slotProps.data.preview }}</span>
                            </div>
                        </template>
                    </Column>

                    <Column field="tag" header="">
                        <template #body="slotProps">
                            <Tag v-if="slotProps.data.tag" :value="slotProps.data.tag" severity="secondary" class="text-xs" :class="slotProps.data.read ? 'opacity-60' : ''" />
                        </template>
                    </Column>

                    <Column field="actions" header="" style="width: 120px">
                        <template #body="slotProps">
                            <div class="flex gap-1">
                                <Button :icon="slotProps.data.starred ? 'pi pi-star-fill' : 'pi pi-star'" :class="slotProps.data.starred ? 'text-yellow-500' : ''" severity="secondary" text size="small" @click.stop="toggleStar(slotProps.data.id)" />
                                <Button
                                    :icon="slotProps.data.important ? 'pi pi-bookmark-fill' : 'pi pi-bookmark'"
                                    :class="slotProps.data.important ? 'text-orange-500' : ''"
                                    severity="secondary"
                                    text
                                    size="small"
                                    @click.stop="toggleImportant(slotProps.data.id)"
                                />
                                <Button icon="pi pi-ellipsis-v" severity="secondary" text size="small" @click.stop="toggleActionMenu($event, slotProps.data.id)" />
                            </div>
                        </template>
                    </Column>
                </DataTable>

                <div class="p-4 border-t border-surface-200 dark:border-surface-700 flex justify-between items-center">
                    <span class="text-sm text-surface-500 dark:text-surface-400">Shows {{ Math.min(first + rows, filteredEmails.length) }} results of {{ filteredEmails.length }}</span>
                    <Paginator :rows="rows" :totalRecords="filteredEmails.length" :first="first" @page="onPageChange" template="FirstPageLink PrevPageLink PageLinks NextPageLink LastPageLink" :pt="{ root: { class: 'border-0 bg-transparent' } }" />
                </div>
            </div>
        </div>

        <Menu ref="actionMenu" :model="actionMenuItems" :popup="true" />

        <Menu ref="bulkActionMenu" :model="bulkActionMenuItems" :popup="true" />

        <Drawer v-model:visible="showMenuDrawer" header="Mails" position="left" class="w-[280px]">
            <div class="flex flex-col gap-6">
                <div class="flex flex-col gap-4">
                    <div class="text-sm font-medium text-surface-500 dark:text-surface-400 uppercase">Menu</div>
                    <div class="flex flex-col gap-1">
                        <div
                            v-for="item in menuItemsWithCounts"
                            :key="item.label"
                            :class="[
                                'flex items-center gap-2 px-3 py-2 rounded-lg cursor-pointer transition-colors',
                                selectedMenuItem === item.label ? 'bg-primary text-surface-0 dark:text-surface-900 shadow-sm' : 'text-surface-500 dark:text-surface-400 hover:bg-surface-100 dark:hover:bg-surface-700'
                            ]"
                            @click="
                                selectMenuItem(item.label);
                                showMenuDrawer = false;
                            "
                        >
                            <i :class="item.icon" class="text-xs" />
                            <span class="flex-1 text-base font-medium">{{ item.label }}</span>
                            <div
                                v-if="item.count > 0"
                                :class="['px-2 py-1 rounded-sm text-sm font-semibold text-xs', selectedMenuItem === item.label ? 'bg-white text-primary-600' : 'bg-surface-200 dark:bg-surface-600 text-surface-900 dark:text-surface-100']"
                            >
                                {{ item.count }}
                            </div>
                        </div>
                    </div>
                </div>

                <div class="h-px bg-surface-200 dark:bg-surface-700" />

                <div class="flex flex-col gap-4">
                    <div class="text-sm font-medium text-surface-500 dark:text-surface-400 uppercase">Categories</div>
                    <div class="flex flex-col gap-1">
                        <div
                            v-for="item in categoryItemsWithCounts"
                            :key="item.label"
                            :class="[
                                'flex items-center gap-2 px-3 py-2 rounded-lg cursor-pointer transition-colors',
                                selectedCategory === item.label ? 'bg-primary text-surface-0 dark:text-surface-900 shadow-sm' : 'text-surface-500 dark:text-surface-400 hover:bg-surface-100 dark:hover:bg-surface-700'
                            ]"
                            @click="
                                selectCategory(item.label);
                                showMenuDrawer = false;
                            "
                        >
                            <i :class="item.icon" class="text-xs" />
                            <span class="flex-1 text-base font-medium">{{ item.label }}</span>
                            <div
                                v-if="item.count > 0"
                                :class="['px-2 py-1 rounded-sm text-sm font-semibold text-xs', selectedCategory === item.label ? 'bg-white text-primary-600' : 'bg-surface-200 dark:bg-surface-600 text-surface-900 dark:text-surface-100']"
                            >
                                {{ item.count }}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </Drawer>

        <ComposeDialog v-model:visible="showComposeOverlay" @send="sendEmail" @close="closeCompose" />
    </div>
</template>
