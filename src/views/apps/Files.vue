<script setup>
import { useConfirm } from 'primevue/useconfirm';
import { computed, ref } from 'vue';

const confirm = useConfirm();

const activeFilter = ref('All Files');

const showEditDrawer = ref(false);
const editingItem = ref(null);
const isAddMode = ref(false);
const editForm = ref({
    fileName: '',
    owner: '',
    type: '',
    fileSize: '',
    size: '',
    uploadDate: '',
    editDate: ''
});
const newComment = ref('');
const fileInput = ref(null);

const activityFeed = ref([
    {
        id: 1,
        fileName: 'Diamond.pdf',
        icon: 'pi-file-pdf',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.',
        author: 'Olivia Martinez',
        time: 'Today, 08:00 PM',
        dotColor: 'bg-primary-500',
        ringColor: 'ring-primary-500'
    },
    {
        id: 2,
        fileName: 'Genesis.png',
        icon: 'pi-image',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.',
        author: 'Jessica Davis',
        time: 'Yesterday, 11:42 PM',
        dotColor: 'bg-green-500',
        ringColor: 'ring-green-500'
    },
    {
        id: 3,
        fileName: 'Avalon.esp',
        icon: 'pi-file',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.',
        author: 'Robert Fox',
        time: 'Dec 11, 2025',
        dotColor: 'bg-cyan-500',
        ringColor: 'ring-cyan-500'
    },
    {
        id: 4,
        fileName: 'Poseidon.zip',
        icon: 'pi-file-o',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.',
        author: 'Emily Johnson',
        time: 'Dec 10, 2025',
        dotColor: 'bg-yellow-500',
        ringColor: 'ring-yellow-500'
    },
    {
        id: 5,
        fileName: 'Portfolio.pdf',
        icon: 'pi-file-pdf',
        description: 'Latest updates to the client portfolio with new design mockups and specifications.',
        author: 'Sarah Wilson',
        time: 'Dec 9, 2025',
        dotColor: 'bg-purple-500',
        ringColor: 'ring-purple-500'
    },
    {
        id: 6,
        fileName: 'Database.sql',
        icon: 'pi-database',
        description: 'Database schema updates and new table structures for the project.',
        author: 'Benjamin Taylor',
        time: 'Dec 8, 2025',
        dotColor: 'bg-red-500',
        ringColor: 'ring-red-500'
    }
]);

const storageData = ref([
    {
        id: 1,
        type: 'PNG',
        count: 12762,
        color: 'bg-green-500',
        shadowColor: 'rgba(34,197,94,0.16)',
        flexValue: 12762
    },
    {
        id: 2,
        type: 'CSS',
        count: 10824,
        color: 'bg-orange-500',
        shadowColor: 'rgba(249,115,22,0.16)',
        flexValue: 10824
    },
    {
        id: 3,
        type: 'PDF',
        count: 8824,
        color: 'bg-primary-500',
        shadowColor: 'rgba(59,130,246,0.16)',
        flexValue: 8824
    },
    {
        id: 4,
        type: 'DOCX',
        count: 7145,
        color: 'bg-violet-500',
        shadowColor: 'rgba(139,92,246,0.16)',
        flexValue: 7145
    },
    {
        id: 5,
        type: 'EPS',
        count: 6802,
        color: 'bg-cyan-500',
        shadowColor: 'rgba(6,182,212,0.16)',
        flexValue: 6802
    },
    {
        id: 6,
        type: 'ZIP',
        count: 5829,
        color: 'bg-yellow-500',
        shadowColor: 'rgba(234,179,8,0.16)',
        flexValue: 5829
    },
    {
        id: 7,
        type: 'XLS',
        count: 5240,
        color: 'bg-rose-500',
        shadowColor: 'rgba(244,63,94,0.16)',
        flexValue: 5240
    }
]);

const totalFiles = computed(() => storageData.value.reduce((sum, item) => sum + item.count, 0));

const pinnedItems = ref([
    {
        id: 1,
        name: 'Genesis',
        type: 'DOCX',
        size: '17.4 MB',
        icon: 'pi-file-word'
    },
    {
        id: 2,
        name: 'Avalon',
        type: 'XLS',
        size: '24 MB',
        icon: 'pi-file-excel'
    },
    {
        id: 3,
        name: 'Poseidon',
        type: 'EPS',
        size: '11.4 MB',
        icon: 'pi-image'
    },
    {
        id: 4,
        name: 'PrimeBlocks',
        type: 'ZIP',
        size: '32 MB',
        icon: 'pi-file-o'
    },
    {
        id: 5,
        name: 'PrimeOne',
        type: 'CSS',
        size: '23 MB',
        icon: 'pi-code'
    },
    {
        id: 6,
        name: 'Diamond',
        type: 'PDF',
        size: '24 MB',
        icon: 'pi-file-pdf'
    }
]);

const documents = ref([
    {
        id: 1,
        fileName: 'Diamond',
        type: 'PDF',
        fileSize: '24 MB',
        size: '-',
        uploadDate: 'Jan 11, 2025',
        editDate: 'Jan 22, 2025',
        owner: 'Robert Fox',
        icon: 'pi-file-pdf',
        comments: [
            { id: 1, author: 'Olivia Martinez', content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.', time: 'Today, 08:00 PM' },
            { id: 2, author: 'Jessica Davis', content: 'Great work on this document! The formatting looks perfect.', time: 'Yesterday, 10:30 AM' }
        ]
    },
    {
        id: 2,
        fileName: 'Genesis',
        type: 'DOCX',
        fileSize: '17.4 MB',
        size: '-',
        uploadDate: 'Jan 7, 2025',
        editDate: 'Jan 14, 2025',
        owner: 'Emily Johnson',
        icon: 'pi-file-word',
        comments: [{ id: 1, author: 'Robert Fox', content: 'Please review the final draft before publishing.', time: 'Today, 02:15 PM' }]
    },
    {
        id: 3,
        fileName: 'Mountain',
        type: 'PNG',
        fileSize: '8.3 MB',
        size: '2880x1440',
        uploadDate: 'Jan 2, 2025',
        editDate: 'Jan 14, 2025',
        owner: 'David Smith',
        icon: 'pi-image',
        comments: []
    },
    {
        id: 4,
        fileName: 'Avalon',
        type: 'XLS',
        fileSize: '21 MB',
        size: '-',
        uploadDate: 'Jan 1, 2025',
        editDate: 'Jan 12, 2025',
        owner: 'Jessica Davis',
        icon: 'pi-file-excel',
        comments: [{ id: 1, author: 'Benjamin Taylor', content: 'The calculations look accurate. Ready for client presentation.', time: 'Jan 12, 2025' }]
    },
    {
        id: 5,
        fileName: 'Poseidon',
        type: 'EPS',
        fileSize: '11.4 MB',
        size: '-',
        uploadDate: 'Jan 2, 2025',
        editDate: 'Jan 11, 2025',
        owner: 'Robert Fox',
        icon: 'pi-image',
        comments: []
    },
    {
        id: 6,
        fileName: 'PrimeBlocks',
        type: 'ZIP',
        fileSize: '32 MB',
        size: '-',
        uploadDate: 'Jan 2, 2025',
        editDate: 'Jan 16, 2025',
        owner: 'James Anderson',
        icon: 'pi-file-o',
        comments: []
    },
    {
        id: 7,
        fileName: 'PrimeOne',
        type: 'CSS',
        fileSize: '23.3 MB',
        size: '-',
        uploadDate: 'Feb 27, 2025',
        editDate: 'Feb 28, 2025',
        owner: 'Benjamin Taylor',
        icon: 'pi-code',
        comments: []
    },
    {
        id: 8,
        fileName: 'Portfolio',
        type: 'PDF',
        fileSize: '15.2 MB',
        size: '-',
        uploadDate: 'Dec 28, 2024',
        editDate: 'Jan 5, 2025',
        owner: 'Robert Fox',
        icon: 'pi-file-pdf',
        comments: []
    },
    {
        id: 9,
        fileName: 'Presentation',
        type: 'PPTX',
        fileSize: '45.7 MB',
        size: '-',
        uploadDate: 'Jan 15, 2025',
        editDate: 'Jan 20, 2025',
        owner: 'Sarah Wilson',
        icon: 'pi-file',
        comments: []
    },
    {
        id: 10,
        fileName: 'Spreadsheet',
        type: 'XLS',
        fileSize: '6.8 MB',
        size: '-',
        uploadDate: 'Jan 18, 2025',
        editDate: 'Jan 25, 2025',
        owner: 'Robert Fox',
        icon: 'pi-file-excel',
        comments: []
    },
    {
        id: 11,
        fileName: 'Logo',
        type: 'SVG',
        fileSize: '2.1 MB',
        size: '1024x1024',
        uploadDate: 'Jan 22, 2025',
        editDate: 'Jan 24, 2025',
        owner: 'Alex Brown',
        icon: 'pi-image',
        comments: []
    },
    {
        id: 12,
        fileName: 'Database',
        type: 'SQL',
        fileSize: '128 MB',
        size: '-',
        uploadDate: 'Jan 5, 2025',
        editDate: 'Jan 26, 2025',
        owner: 'Robert Fox',
        icon: 'pi-database',
        comments: []
    },
    {
        id: 13,
        fileName: 'Report',
        type: 'DOCX',
        fileSize: '3.2 MB',
        size: '-',
        uploadDate: 'Jan 28, 2025',
        editDate: 'Jan 29, 2025',
        owner: 'Lisa Chen',
        icon: 'pi-file-word',
        comments: []
    }
]);

const filteredDocuments = computed(() => {
    let filtered = documents.value;

    switch (activeFilter.value) {
        case 'Recently Uploaded':
            return [...filtered].sort((a, b) => new Date(b.uploadDate) - new Date(a.uploadDate));
        case 'Large Files':
            return filtered.filter((doc) => parseFloat(doc.fileSize) > 20);
        case 'Uploaded by Me':
            return filtered.filter((doc) => doc.owner === 'Robert Fox');
        default:
            return filtered;
    }
});

const first = ref(0);
const rows = ref(5);

const tableMenuRefs = ref({});

const activityMenuRefs = ref({});
const pinnedMenuRefs = ref({});
const commentMenuRefs = ref({});

const feedMenuItems = [
    { label: 'Open', icon: 'pi pi-external-link' },
    { label: 'Share', icon: 'pi pi-share-alt' },
    { label: 'Download', icon: 'pi pi-download' },
    { label: 'Delete', icon: 'pi pi-trash' }
];

const pinnedMenuItems = [
    { label: 'Open', icon: 'pi pi-external-link' },
    { label: 'Unpin', icon: 'pi pi-times' },
    { label: 'Share', icon: 'pi pi-share-alt' },
    { label: 'Delete', icon: 'pi pi-trash' }
];

const createTableMenuItems = (document) => [
    { label: 'Edit', icon: 'pi pi-pencil', command: () => editDocument(document) },
    { label: 'Pin', icon: 'pi pi-bookmark' },
    { label: 'Share', icon: 'pi pi-share-alt' },
    { label: 'Delete', icon: 'pi pi-trash', command: () => confirmDeleteDocument(document) }
];

const createCommentMenuItems = (commentId) => [
    { label: 'Edit Comment', icon: 'pi pi-pencil' },
    { label: 'Copy Text', icon: 'pi pi-copy' },
    { label: 'Report', icon: 'pi pi-flag' },
    { separator: true },
    { label: 'Remove', icon: 'pi pi-trash', command: () => removeComment(commentId) }
];

const getTagSeverity = (type) => {
    const severityMap = {
        PDF: 'info',
        DOCX: 'secondary',
        PNG: 'success',
        XLS: 'warn',
        EPS: 'help',
        ZIP: 'warn',
        CSS: 'info',
        PPTX: 'secondary',
        SVG: 'success',
        SQL: 'contrast'
    };
    return severityMap[type] || 'secondary';
};

const toggleActivityMenu = (event, activityId) => {
    const menuKey = `activityMenu_${activityId}`;
    const menu = activityMenuRefs.value[menuKey];
    if (menu) {
        menu.toggle(event);
    }
};

const togglePinnedMenu = (event, pinnedId) => {
    const menuKey = `pinnedMenu_${pinnedId}`;
    const menu = pinnedMenuRefs.value[menuKey];
    if (menu) {
        menu.toggle(event);
    }
};

const toggleTableMenu = (event, itemId) => {
    const menuKey = `tableMenu_${itemId}`;
    const menu = tableMenuRefs.value[menuKey];
    if (menu) {
        menu.toggle(event);
    }
};

const toggleCommentMenu = (event, commentId) => {
    const menuKey = `commentMenu_${commentId}`;
    const menu = commentMenuRefs.value[menuKey];
    if (menu) {
        menu.toggle(event);
    }
};

const editDocument = (document) => {
    editingItem.value = document;
    isAddMode.value = false;
    editForm.value = { ...document };
    showEditDrawer.value = true;
};

const addDocument = () => {
    editingItem.value = null;
    isAddMode.value = true;
    editForm.value = {
        fileName: '',
        owner: '',
        type: '',
        fileSize: '',
        size: '',
        uploadDate: '',
        editDate: ''
    };
    showEditDrawer.value = true;
};

const updateDocument = () => {
    if (isAddMode.value) {
        const newId = Math.max(...documents.value.map((d) => d.id)) + 1;
        const currentDate = new Date().toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
        const newDoc = {
            ...editForm.value,
            id: newId,
            owner: editForm.value.owner || 'Robert Fox',
            uploadDate: editForm.value.uploadDate || currentDate,
            editDate: editForm.value.editDate || currentDate,
            size: editForm.value.size || '-',
            icon: getIconByType(editForm.value.type),
            comments: []
        };
        documents.value.unshift(newDoc);
    } else {
        const index = documents.value.findIndex((d) => d.id === editingItem.value.id);
        if (index !== -1) {
            documents.value[index] = { ...documents.value[index], ...editForm.value };
        }
    }
    showEditDrawer.value = false;
};

const addComment = () => {
    if (newComment.value.trim() && editingItem.value) {
        const comment = {
            id: Date.now(),
            author: 'Robert Fox',
            content: newComment.value.trim(),
            time: 'Just now'
        };
        editingItem.value.comments.push(comment);
        newComment.value = '';
    }
};

const removeComment = (commentId) => {
    if (editingItem.value && editingItem.value.comments) {
        const commentIndex = editingItem.value.comments.findIndex((c) => c.id === commentId);
        if (commentIndex !== -1) {
            editingItem.value.comments.splice(commentIndex, 1);
        }
    }
};

const getIconByType = (type) => {
    const iconMap = {
        PDF: 'pi-file-pdf',
        DOCX: 'pi-file-word',
        PNG: 'pi-image',
        JPG: 'pi-image',
        SVG: 'pi-image',
        XLS: 'pi-file-excel',
        EPS: 'pi-image',
        ZIP: 'pi-file-o',
        CSS: 'pi-code',
        PPTX: 'pi-file',
        SQL: 'pi-database'
    };
    return iconMap[type] || 'pi-file';
};

const triggerFileUpload = () => {
    fileInput.value?.click();
};

const handleFileUpload = (event) => {
    const file = event.target.files[0];
    if (file) {
        const currentDate = new Date().toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
        editForm.value.fileName = file.name.split('.')[0];
        editForm.value.type = file.name.split('.').pop().toUpperCase();
        editForm.value.fileSize = (file.size / (1024 * 1024)).toFixed(1) + ' MB';

        if (isAddMode.value) {
            if (!editForm.value.uploadDate) {
                editForm.value.uploadDate = currentDate;
            }
            if (!editForm.value.editDate) {
                editForm.value.editDate = currentDate;
            }
            if (!editForm.value.owner) {
                editForm.value.owner = 'Robert Fox';
            }
            if (!editForm.value.size) {
                editForm.value.size = '-';
            }
        }
    }
};

const removeUploadedFile = () => {
    editForm.value.fileName = '';
    editForm.value.type = '';
    editForm.value.fileSize = '';
    editForm.value.size = '';

    if (isAddMode.value) {
        editForm.value.uploadDate = '';
        editForm.value.editDate = '';
        editForm.value.owner = '';
    }

    if (fileInput.value) {
        fileInput.value.value = '';
    }
};

const confirmDeleteDocument = (document) => {
    confirm.require({
        message: `Are you sure you want to delete "${document.fileName}"? This action cannot be undone.`,
        header: 'Delete Document',
        icon: 'pi pi-info-circle',
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
            deleteDocument(document.id);
        }
    });
};

const deleteDocument = (documentId) => {
    const index = documents.value.findIndex((d) => d.id === documentId);
    if (index !== -1) {
        documents.value.splice(index, 1);
        if (editingItem.value && editingItem.value.id === documentId) {
            showEditDrawer.value = false;
        }
    }
};

const confirmMoveToTrash = () => {
    if (!editingItem.value) return;

    confirm.require({
        message: `Are you sure you want to move "${editingItem.value.fileName}" to trash? This action cannot be undone.`,
        header: 'Move to Trash',
        icon: 'pi pi-info-circle',
        rejectProps: {
            label: 'Cancel',
            severity: 'secondary',
            outlined: true
        },
        acceptProps: {
            label: 'Move to Trash',
            severity: 'danger'
        },
        accept: () => {
            deleteDocument(editingItem.value.id);
        }
    });
};
</script>

<template>
    <div class="flex flex-col gap-6 card">
        <div class="flex flex-col gap-4 lg:flex-row lg:justify-between lg:items-center">
            <div class="text-surface-900 dark:text-surface-0 text-2xl! font-medium leading-loose">Overview</div>

            <div class="flex flex-col gap-3 sm:flex-row sm:items-center sm:gap-4">
                <Button icon="pi pi-plus" label="Add New" severity="primary" rounded class="w-full sm:w-auto cursor-pointer" @click="addDocument" />
            </div>
        </div>

        <div class="flex flex-col gap-8">
            <div class="flex flex-col lg:grid lg:grid-cols-12 gap-6">
                <div class="lg:col-span-6 xl:col-span-4 bg-surface-0 dark:bg-surface-900 rounded-2xl border border-surface-200 dark:border-surface-700 overflow-hidden">
                    <div class="px-6 pt-4 pb-4">
                        <h3 class="text-surface-900 dark:text-surface-0 text-xl font-medium leading-7">Activity Feed</h3>
                    </div>

                    <div class="relative max-h-[350px] lg:max-h-[450px] 2xl:max-h-[330px]">
                        <div class="absolute top-0 left-0 right-0 h-4 bg-linear-to-b from-surface-0 dark:from-surface-900 to-transparent pointer-events-none z-20" />
                        <div class="absolute bottom-0 left-0 right-0 h-6 bg-linear-to-t from-surface-0 dark:from-surface-900 to-transparent pointer-events-none z-20" />

                        <div class="pb-6 pt-3 px-4 max-h-[350px] lg:max-h-[450px] 2xl:max-h-[330px] overflow-y-auto">
                            <div class="relative">
                                <div class="absolute left-[10px] top-0 bottom-0 w-px bg-surface-200 dark:bg-surface-700" />

                                <div class="flex flex-col gap-4">
                                    <div v-for="(activity, index) in activityFeed" :key="activity.id" class="flex gap-3">
                                        <div class="flex items-start pt-2.5 w-6 justify-center">
                                            <div :class="`w-2 h-2 ${activity.dotColor} rounded-full ring-2 ${activity.ringColor} ring-offset-2 ring-offset-surface-0 dark:ring-offset-surface-800 relative z-10`" />
                                        </div>

                                        <div :class="`flex-1 pb-4 ${index < activityFeed.length - 1 ? 'border-b border-surface-200 dark:border-surface-700' : ''}`">
                                            <div class="flex flex-col gap-2">
                                                <div class="flex flex-col gap-1">
                                                    <div class="flex items-center justify-between">
                                                        <div class="flex items-center gap-1">
                                                            <i :class="`pi ${activity.icon} text-sm text-surface-500`" />
                                                            <span class="text-surface-950 dark:text-surface-0 text-base font-medium leading-normal">{{ activity.fileName }}</span>
                                                        </div>
                                                        <Button @click="toggleActivityMenu($event, activity.id)" rounded text icon="pi pi-ellipsis-h" size="small" severity="secondary" class="cursor-pointer" />
                                                        <Menu
                                                            :ref="
                                                                (el) => {
                                                                    if (el) activityMenuRefs[`activityMenu_${activity.id}`] = el;
                                                                }
                                                            "
                                                            :model="feedMenuItems"
                                                            :popup="true"
                                                            class="!w-48"
                                                        />
                                                    </div>
                                                    <p class="text-surface-600 dark:text-surface-400 text-sm leading-tight">{{ activity.description }}</p>
                                                </div>
                                                <div class="flex items-center gap-2">
                                                    <span class="text-surface-500 text-sm leading-tight">{{ activity.time }}</span>
                                                    <div class="w-0 h-[6px] border-l border-surface-200 dark:border-surface-700" />
                                                    <span class="text-surface-500 text-sm leading-tight">{{ activity.author }}</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="lg:col-span-6 xl:col-span-8 flex flex-col gap-6">
                    <div class="p-5 bg-surface-0 dark:bg-surface-900 rounded-2xl border border-surface-200 dark:border-surface-700 flex flex-col gap-[18px] overflow-hidden">
                        <div class="flex justify-between items-center h-8">
                            <h3 class="text-surface-900 dark:text-surface-0 text-xl font-medium leading-7">Storage</h3>
                            <div class="flex items-center gap-1">
                                <span class="text-surface-950 dark:text-surface-0 text-xl font-semibold leading-tight">{{ totalFiles.toLocaleString() }}</span>
                                <span class="text-surface-500 text-sm leading-none">Total Files</span>
                            </div>
                        </div>

                        <div class="hidden md:flex items-end gap-1 w-full">
                            <div v-for="storage in storageData" :key="storage.id" :style="`flex: ${storage.flexValue}`" class="flex flex-col gap-2">
                                <div :class="`h-4 ${storage.color} rounded-lg`" :style="`box-shadow: 0px 5px 10px 0px ${storage.shadowColor}`" />
                                <div class="flex flex-col gap-1">
                                    <span class="text-surface-900 dark:text-surface-0 text-sm md:text-base xl:text-lg font-medium leading-tight md:leading-normal xl:leading-7">{{ storage.count.toLocaleString() }}</span>
                                    <div class="flex items-center gap-1">
                                        <div :class="`w-2 h-2 ${storage.color} rounded-sm`" :style="`box-shadow: 0px 5px 10px 0px ${storage.shadowColor}`" />
                                        <span class="text-surface-500 text-xs md:text-sm leading-tight">{{ storage.type }}</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="flex flex-col gap-3 md:hidden">
                            <div v-for="storage in storageData" :key="storage.id" class="flex items-center justify-between">
                                <div class="flex items-center gap-3">
                                    <div :class="`w-3 h-3 ${storage.color} rounded-sm`" :style="`box-shadow: 0px 5px 10px 0px ${storage.shadowColor}`" />
                                    <span class="text-surface-500 text-sm leading-tight">{{ storage.type }}</span>
                                </div>
                                <span class="text-surface-900 dark:text-surface-0 text-lg font-medium leading-7">{{ storage.count.toLocaleString() }}</span>
                            </div>
                        </div>
                    </div>

                    <div class="p-5 bg-surface-0 dark:bg-surface-900 rounded-2xl border border-surface-200 dark:border-surface-700">
                        <h3 class="text-surface-900 dark:text-surface-0 text-xl font-medium mb-4">Pinned</h3>

                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 2xl:grid-cols-6 gap-3">
                            <div v-for="pinned in pinnedItems" :key="pinned.id" class="p-3 rounded-xl border border-surface-200 dark:border-surface-700 flex flex-col gap-4">
                                <div class="flex justify-between items-start">
                                    <i :class="`pi ${pinned.icon} text-2xl! text-surface-400`" />
                                    <Button @click="togglePinnedMenu($event, pinned.id)" rounded text icon="pi pi-ellipsis-v" size="small" severity="secondary" class="cursor-pointer" />
                                    <Menu
                                        :ref="
                                            (el) => {
                                                if (el) pinnedMenuRefs[`pinnedMenu_${pinned.id}`] = el;
                                            }
                                        "
                                        :model="pinnedMenuItems"
                                        :popup="true"
                                        class="!w-48"
                                    />
                                </div>
                                <div class="flex flex-col gap-1">
                                    <span class="text-surface-900 dark:text-surface-0 text-base font-medium">{{ pinned.name }}</span>
                                    <div class="flex xl:items-center gap-1 xl:flex-row flex-col">
                                        <span class="text-surface-500 text-sm">{{ pinned.type }}</span>
                                        <div class="w-1 h-1 bg-surface-300 rounded-full hidden xl:block" />
                                        <span class="text-surface-500 text-sm">{{ pinned.size }}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="flex flex-col gap-6">
                <h2 class="text-surface-950 dark:text-surface-0 text-2xl font-medium leading-loose">Documents</h2>

                <div class="flex flex-wrap gap-4">
                    <button
                        @click="activeFilter = 'All Files'"
                        :class="[
                            'px-[18px] py-[9px] rounded-xl text-base font-medium border transition-colors whitespace-nowrap cursor-pointer',
                            activeFilter === 'All Files'
                                ? 'bg-primary-50 dark:bg-primary-900/20 border-primary-200 dark:border-primary-800 text-primary-950 dark:text-primary-100 shadow-sm'
                                : 'border-surface-200 dark:border-surface-700 text-surface-950 dark:text-surface-0 hover:bg-surface-50 dark:hover:bg-surface-700'
                        ]"
                    >
                        All Files
                    </button>
                    <button
                        @click="activeFilter = 'Recently Uploaded'"
                        :class="[
                            'px-[18px] py-[9px] rounded-xl text-base font-medium border transition-colors whitespace-nowrap cursor-pointer',
                            activeFilter === 'Recently Uploaded'
                                ? 'bg-primary-50 dark:bg-primary-900/20 border-primary-200 dark:border-primary-800 text-primary-950 dark:text-primary-100 shadow-sm'
                                : 'border-surface-200 dark:border-surface-700 text-surface-950 dark:text-surface-0 hover:bg-surface-50 dark:hover:bg-surface-700'
                        ]"
                    >
                        Recently Uploaded
                    </button>
                    <button
                        @click="activeFilter = 'Large Files'"
                        :class="[
                            'px-[18px] py-[9px] rounded-xl text-base font-medium border transition-colors whitespace-nowrap cursor-pointer',
                            activeFilter === 'Large Files'
                                ? 'bg-primary-50 dark:bg-primary-900/20 border-primary-200 dark:border-primary-800 text-primary-950 dark:text-primary-100 shadow-sm'
                                : 'border-surface-200 dark:border-surface-700 text-surface-950 dark:text-surface-0 hover:bg-surface-50 dark:hover:bg-surface-700'
                        ]"
                    >
                        Large Files
                    </button>
                    <button
                        @click="activeFilter = 'Uploaded by Me'"
                        :class="[
                            'px-[18px] py-[9px] rounded-xl text-base font-medium border transition-colors whitespace-nowrap cursor-pointer',
                            activeFilter === 'Uploaded by Me'
                                ? 'bg-primary-50 dark:bg-primary-900/20 border-primary-200 dark:border-primary-800 text-primary-950 dark:text-primary-100 shadow-sm'
                                : 'border-surface-200 dark:border-surface-700 text-surface-950 dark:text-surface-0 hover:bg-surface-50 dark:hover:bg-surface-700'
                        ]"
                    >
                        Uploaded by Me
                    </button>
                </div>

                <DataTable
                    :value="filteredDocuments"
                    :paginator="true"
                    :rows="rows"
                    :first="first"
                    sortMode="multiple"
                    class="bg-surface-0 dark:bg-surface-800 rounded-2xl border border-surface-200 dark:border-surface-700 overflow-hidden [&>[data-pc-section=paginatorcontainer]]:border-0! [&_[data-pc-name=pcpaginator]]:rounded-none!"
                    tableClass="w-full"
                    paginatorTemplate="FirstPageLink PrevPageLink PageLinks NextPageLink LastPageLink CurrentPageReport"
                    :currentPageReportTemplate="`Shows {first} to {last} of {totalRecords} results`"
                >
                    <Column field="fileName" header="File Name" sortable class="w-40">
                        <template #body="slotProps">
                            <div class="flex items-center gap-3 py-2">
                                <i :class="`pi ${slotProps.data.icon} text-xl text-surface-400`" />
                                <span class="text-surface-500 text-sm whitespace-nowrap">{{ slotProps.data.fileName }}</span>
                            </div>
                        </template>
                    </Column>

                    <Column field="type" header="Type" sortable class="w-32">
                        <template #body="slotProps">
                            <Tag :value="slotProps.data.type" :severity="getTagSeverity(slotProps.data.type)" class="px-2 py-1" />
                        </template>
                    </Column>

                    <Column field="fileSize" header="File Size" sortable class="w-42">
                        <template #body="slotProps">
                            <span class="text-surface-500 text-sm whitespace-nowrap">{{ slotProps.data.fileSize }}</span>
                        </template>
                    </Column>

                    <Column field="size" header="Size" class="w-24">
                        <template #body="slotProps">
                            <span class="text-surface-500 text-sm whitespace-nowrap">{{ slotProps.data.size }}</span>
                        </template>
                    </Column>

                    <Column field="uploadDate" header="Upload Date" sortable class="flex-1">
                        <template #body="slotProps">
                            <span class="text-surface-500 text-sm whitespace-nowrap">{{ slotProps.data.uploadDate }}</span>
                        </template>
                    </Column>

                    <Column field="editDate" header="Edit Date" sortable class="flex-1">
                        <template #body="slotProps">
                            <span class="text-surface-500 text-sm whitespace-nowrap">{{ slotProps.data.editDate }}</span>
                        </template>
                    </Column>

                    <Column field="owner" header="Owner" sortable class="flex-1">
                        <template #body="slotProps">
                            <span class="text-surface-500 text-sm whitespace-nowrap">{{ slotProps.data.owner }}</span>
                        </template>
                    </Column>

                    <Column header="Actions" class="w-24">
                        <template #body="slotProps">
                            <div class="flex items-center gap-1">
                                <Button icon="pi pi-download" rounded text size="small" severity="secondary" class="cursor-pointer" />
                                <Button @click="toggleTableMenu($event, slotProps.data.id)" rounded text icon="pi pi-ellipsis-h" size="small" severity="secondary" class="cursor-pointer" />
                                <Menu
                                    :ref="
                                        (el) => {
                                            if (el) tableMenuRefs[`tableMenu_${slotProps.data.id}`] = el;
                                        }
                                    "
                                    :model="createTableMenuItems(slotProps.data)"
                                    :popup="true"
                                    class="!w-48"
                                />
                            </div>
                        </template>
                    </Column>
                </DataTable>
            </div>
        </div>

        <Drawer v-model:visible="showEditDrawer" position="right" class="w-full! max-w-[417px]!">
            <template #header>
                <h3 class="text-surface-900 dark:text-surface-0 text-2xl font-medium">{{ isAddMode ? 'Add' : 'Edit' }}</h3>
            </template>

            <div class="flex flex-col h-full">
                <div class="flex-1 flex flex-col gap-6 overflow-y-auto">
                    <div class="relative min-h-[180px] h-[180px] rounded-2xl bg-surface-100 dark:bg-surface-800 border border-surface-200 dark:border-surface-700">
                        <div class="w-full h-full flex flex-col items-center justify-center gap-4 cursor-pointer hover:bg-surface-200 dark:hover:bg-surface-700 transition-colors rounded-2xl" @click="triggerFileUpload">
                            <div class="flex items-center justify-center">
                                <div class="w-12 h-12 rounded-full bg-surface-200 dark:bg-surface-600 flex items-center justify-center">
                                    <i :class="`pi ${editForm.type ? getIconByType(editForm.type) : 'pi-upload'} text-surface-600 dark:text-surface-300 text-2xl`" />
                                </div>
                            </div>
                            <div class="text-center">
                                <div class="text-surface-900 dark:text-surface-0 text-base font-medium mb-1">
                                    {{ editForm.fileName || 'Click to upload file' }}
                                </div>
                                <div class="text-surface-500 dark:text-surface-400 text-sm">
                                    {{ editForm.type ? `${editForm.type} • ${editForm.fileSize || ''}` : 'Select a file to upload' }}
                                </div>
                            </div>
                        </div>
                        <Button v-if="editForm.fileName && editForm.type" icon="pi pi-times" text rounded size="small" class="absolute! z-40! top-4 right-4 cursor-pointer" severity="secondary" @click.stop="removeUploadedFile" />
                        <input ref="fileInput" type="file" @change="handleFileUpload" class="hidden" />
                    </div>

                    <div class="flex flex-col gap-6">
                        <div class="flex flex-col gap-2">
                            <label class="text-surface-950 dark:text-surface-0 text-base font-medium">Name</label>
                            <InputText v-model="editForm.fileName" class="w-full" />
                        </div>

                        <div class="flex flex-col gap-2">
                            <label class="text-surface-950 dark:text-surface-0 text-base font-medium">Owner</label>
                            <InputText v-model="editForm.owner" class="w-full" />
                        </div>

                        <div v-if="!isAddMode || editForm.fileName" class="bg-surface-50 dark:bg-surface-800 rounded-xl p-4 border border-surface-200 dark:border-surface-700">
                            <div class="grid grid-cols-2 gap-4">
                                <div class="flex flex-col gap-1 min-h-[44px]">
                                    <label class="text-surface-500 text-xs font-medium uppercase tracking-wide">Type</label>
                                    <Tag v-if="editForm.type" :value="editForm.type" :severity="getTagSeverity(editForm.type)" class="px-2 py-1 text-xs w-fit" />
                                    <span v-else class="text-surface-700 dark:text-surface-300 text-sm font-medium">&nbsp;</span>
                                </div>

                                <div class="flex flex-col gap-1 min-h-[44px]">
                                    <label class="text-surface-500 text-xs font-medium uppercase tracking-wide">File Size</label>
                                    <span class="text-surface-700 dark:text-surface-300 text-sm font-medium">{{ editForm.fileSize || '&nbsp;' }}</span>
                                </div>

                                <div class="flex flex-col gap-1 min-h-[44px]">
                                    <label class="text-surface-500 text-xs font-medium uppercase tracking-wide">Dimensions</label>
                                    <span class="text-surface-700 dark:text-surface-300 text-sm font-medium">{{ editForm.size || '&nbsp;' }}</span>
                                </div>

                                <div class="flex flex-col gap-1 min-h-[44px]">
                                    <label class="text-surface-500 text-xs font-medium uppercase tracking-wide">Uploaded</label>
                                    <span class="text-surface-700 dark:text-surface-300 text-sm font-medium">{{ editForm.uploadDate || '&nbsp;' }}</span>
                                </div>
                            </div>

                            <div class="flex flex-col gap-1 mt-3 pt-3 border-t border-surface-200 dark:border-surface-700 min-h-[44px]">
                                <label class="text-surface-500 text-xs font-medium uppercase tracking-wide">Last Modified</label>
                                <span class="text-surface-700 dark:text-surface-300 text-sm font-medium">{{ editForm.editDate || '&nbsp;' }}</span>
                            </div>
                        </div>
                    </div>

                    <div v-if="!isAddMode && editingItem?.comments" class="border-t border-surface-200 dark:border-surface-700 pt-6">
                        <h4 class="text-surface-950 dark:text-surface-0 text-base font-medium mb-4">Comments</h4>
                        <div class="flex flex-col gap-4">
                            <div v-for="comment in editingItem.comments" :key="comment.id" class="pb-4 border-b border-surface-200 dark:border-surface-700 last:border-b-0">
                                <div class="flex justify-between items-start mb-2">
                                    <span class="text-surface-950 dark:text-surface-0 text-base font-medium">{{ comment.author }}</span>
                                    <Button @click="toggleCommentMenu($event, comment.id)" icon="pi pi-ellipsis-h" text size="small" severity="secondary" class="cursor-pointer" />
                                    <Menu
                                        :ref="
                                            (el) => {
                                                if (el) commentMenuRefs[`commentMenu_${comment.id}`] = el;
                                            }
                                        "
                                        :model="createCommentMenuItems(comment.id)"
                                        :popup="true"
                                        class="!w-48"
                                    />
                                </div>
                                <p class="text-surface-600 dark:text-surface-400 text-sm mb-2">{{ comment.content }}</p>
                                <span class="text-surface-500 text-sm">{{ comment.time }}</span>
                            </div>
                        </div>
                    </div>

                    <div v-if="!isAddMode" class="border-t border-surface-200 dark:border-surface-700 pt-6">
                        <h4 class="text-surface-950 dark:text-surface-0 text-base font-medium mb-3">Add Comment</h4>
                        <div class="flex flex-col gap-3">
                            <Textarea v-model="newComment" rows="4" class="w-full" placeholder="Write your comment here..." />
                            <Button label="Post Comment" severity="secondary" outlined class="w-full cursor-pointer" @click="addComment" :disabled="!newComment.trim()" />
                        </div>
                    </div>
                </div>

                <div class="flex flex-col gap-3 py-6 pt-4 border-t border-surface-200 dark:border-surface-700 bg-surface-0 dark:bg-surface-900">
                    <Button :label="isAddMode ? 'Add Document' : 'Update Document'" severity="primary" class="w-full cursor-pointer" @click="updateDocument" />
                    <Button v-if="!isAddMode" label="Move to trash" icon="pi pi-trash" severity="danger" outlined class="w-full cursor-pointer" @click="confirmMoveToTrash" />
                </div>
            </div>
        </Drawer>

        <ConfirmDialog />
    </div>
</template>
