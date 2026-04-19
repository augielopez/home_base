<script setup>
import { useConfirm } from 'primevue/useconfirm';
import { computed, ref } from 'vue';
import TaskDrawer from './TaskDrawer.vue';

const confirm = useConfirm();

const activeFilter = ref('All Tasks');
const searchQuery = ref('');

const openPanels = ref(['0', '1', '2']);

const isDrawerVisible = ref(false);
const selectedTask = ref(null);
const drawerMode = ref('create');

const taskData = ref([
    {
        id: 1,
        title: 'Design a SaaS Platform UI',
        description: null,
        status: 'pending',
        completed: false,
        startDate: '12.01.2025',
        endDate: '24.01.2025',
        members: [{ image: 'amyelsner.png' }, { image: 'annafali.png' }]
    },
    {
        id: 2,
        title: 'Create an E-Commerce Landing Page',
        description: null,
        status: 'pending',
        completed: false,
        startDate: '02.01.2025',
        endDate: '28.01.2025',
        members: [{ image: 'amyelsner.png' }, { image: 'annafali.png' }]
    },
    {
        id: 3,
        title: 'Build an Educational Website UI',
        description: 'A clean, professional and fast information access interface will be designed for an education-oriented website.',
        status: 'pending',
        completed: false,
        startDate: '02.02.2025',
        endDate: '06.02.2025',
        members: [{ image: 'amyelsner.png' }, { image: 'annafali.png' }, { image: 'asiyajavayant.png' }, { image: 'bernardodominic.png' }]
    },
    {
        id: 4,
        title: 'Develop a Tech Startup Landing Page',
        description: null,
        status: 'pending',
        completed: false,
        startDate: '12.02.2025',
        endDate: '27.02.2025',
        members: [{ image: 'amyelsner.png' }, { image: 'annafali.png' }]
    },
    {
        id: 5,
        title: 'Design a Healthcare Landing Page',
        description: null,
        status: 'pending',
        completed: false,
        startDate: '09.02.2025',
        endDate: '17.02.2025',
        members: [{ image: 'amyelsner.png' }, { image: 'annafali.png' }]
    },
    {
        id: 6,
        title: 'Create a Finance Dashboard UI',
        description: null,
        status: 'in-progress',
        completed: false,
        startDate: '15.02.2025',
        endDate: '28.03.2025',
        members: [{ image: 'amyelsner.png' }, { image: 'annafali.png' }]
    },
    {
        id: 7,
        title: 'Design a Fashion Landing Page',
        description: null,
        status: 'in-progress',
        completed: false,
        startDate: '12.02.2025',
        endDate: '19.02.2025',
        members: [{ image: 'amyelsner.png' }, { image: 'annafali.png' }]
    },
    {
        id: 8,
        title: 'Develop a Gaming Platform UI',
        description: null,
        status: 'completed',
        completed: true,
        startDate: '02.02.2025',
        endDate: '06.02.2025',
        members: [{ image: 'amyelsner.png' }, { image: 'annafali.png' }, { image: 'asiyajavayant.png' }, { image: 'bernardodominic.png' }]
    },
    {
        id: 9,
        title: 'Create a Corporate Website Landing Page',
        description: null,
        status: 'completed',
        completed: true,
        startDate: '12.02.2025',
        endDate: '27.02.2025',
        members: [{ image: 'amyelsner.png' }, { image: 'annafali.png' }]
    },
    {
        id: 10,
        title: 'Design a Personal Blog Landing Page',
        description: null,
        status: 'completed',
        completed: true,
        startDate: '12.01.2025',
        endDate: '24.01.2025',
        members: [{ image: 'amyelsner.png' }, { image: 'annafali.png' }]
    }
]);

const filteredTasks = computed(() => {
    let tasks = taskData.value;

    if (searchQuery.value.trim()) {
        tasks = tasks.filter((task) => task.title.toLowerCase().includes(searchQuery.value.toLowerCase()));
    }

    if (activeFilter.value === 'All Tasks') {
        return tasks;
    } else if (activeFilter.value === 'Pending') {
        return tasks.filter((task) => task.status === 'pending');
    } else if (activeFilter.value === 'In Progress') {
        return tasks.filter((task) => task.status === 'in-progress');
    } else if (activeFilter.value === 'Completed') {
        return tasks.filter((task) => task.status === 'completed');
    }
    return tasks;
});

const taskCounts = computed(() => ({
    all: taskData.value.length,
    inbox: taskData.value.filter((task) => task.status === 'pending').length,
    inProgress: taskData.value.filter((task) => task.status === 'in-progress').length,
    completed: taskData.value.filter((task) => task.status === 'completed').length
}));

const pendingTasks = computed(() => filteredTasks.value.filter((task) => task.status === 'pending'));
const inProgressTasks = computed(() => filteredTasks.value.filter((task) => task.status === 'in-progress'));
const completedTasks = computed(() => filteredTasks.value.filter((task) => task.status === 'completed'));

taskData.value.forEach((task) => {
    if (task.status === 'completed') {
        task.completed = true;
    } else {
        task.completed = false;
    }
});

const toggleTaskCompletion = (task, completed) => {
    setTimeout(() => {
        if (completed) {
            task.status = 'completed';
        } else {
            task.status = 'pending';
        }
    }, 400);
};

const deleteTask = (taskId) => {
    confirm.require({
        message: 'Are you sure you want to delete this task?',
        header: 'Delete Confirmation',
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
            taskData.value = taskData.value.filter((task) => task.id !== taskId);
        }
    });
};

const openNewTaskDrawer = () => {
    selectedTask.value = null;
    drawerMode.value = 'create';
    isDrawerVisible.value = true;
};

const openEditTaskDrawer = (task) => {
    selectedTask.value = task;
    drawerMode.value = 'edit';
    isDrawerVisible.value = true;
};

const handleDrawerSave = (newTaskData) => {
    if (drawerMode.value === 'create') {
        const newId = Math.max(...taskData.value.map((t) => t.id), 0) + 1;
        const newTask = {
            ...newTaskData,
            id: newId
        };
        taskData.value.push(newTask);
    } else {
        const taskIndex = taskData.value.findIndex((t) => t.id === newTaskData.id);
        if (taskIndex !== -1) {
            taskData.value[taskIndex] = newTaskData;
        }
    }
    isDrawerVisible.value = false;
};

const handleDrawerCancel = () => {
    isDrawerVisible.value = false;
    selectedTask.value = null;
};
</script>

<template>
    <div class="flex flex-col lg:flex-row h-full bg-surface-0 dark:bg-surface-900 card">
        <div class="lg:hidden flex flex-col gap-4 p-4 border-b border-surface-200 dark:border-surface-700">
            <div class="flex items-center justify-between">
                <h1 class="text-surface-900 dark:text-surface-0 text-lg font-semibold">Tasks</h1>
                <Button icon="pi pi-plus" label="New Task" severity="secondary" outlined size="small" @click="openNewTaskDrawer" />
            </div>

            <div class="flex gap-2 overflow-x-auto">
                <button
                    @click="activeFilter = 'All Tasks'"
                    :class="[
                        'px-4 py-2 rounded-lg flex items-center gap-2 whitespace-nowrap transition-colors cursor-pointer shrink-0',
                        activeFilter === 'All Tasks' ? 'bg-primary text-surface-0 dark:text-surface-900 shadow-sm' : 'text-surface-500 dark:text-surface-400 hover:bg-surface-100 dark:hover:bg-surface-700'
                    ]"
                >
                    <i class="pi pi-list text-sm" />
                    <span class="text-sm font-medium">All</span>
                    <div
                        v-if="taskCounts.all > 0"
                        :class="['px-2 py-1 rounded-sm text-sm font-semibold text-xs', activeFilter === 'All Tasks' ? 'bg-white text-primary-600' : 'bg-surface-200 dark:bg-surface-600 text-surface-900 dark:text-surface-100']"
                    >
                        {{ taskCounts.all }}
                    </div>
                </button>

                <button
                    @click="activeFilter = 'Pending'"
                    :class="[
                        'px-4 py-2 rounded-lg flex items-center gap-2 whitespace-nowrap transition-colors cursor-pointer shrink-0',
                        activeFilter === 'Pending' ? 'bg-primary text-surface-0 dark:text-surface-900 shadow-sm' : 'text-surface-500 dark:text-surface-400 hover:bg-surface-100 dark:hover:bg-surface-700'
                    ]"
                >
                    <i class="pi pi-inbox text-sm" />
                    <span class="text-sm font-medium">Pending</span>
                    <div
                        v-if="taskCounts.inbox > 0"
                        :class="['px-2 py-1 rounded-sm text-sm font-semibold text-xs', activeFilter === 'Pending' ? 'bg-white text-primary-600' : 'bg-surface-200 dark:bg-surface-600 text-surface-900 dark:text-surface-100']"
                    >
                        {{ taskCounts.inbox }}
                    </div>
                </button>

                <button
                    @click="activeFilter = 'In Progress'"
                    :class="[
                        'px-4 py-2 rounded-lg flex items-center gap-2 whitespace-nowrap transition-colors cursor-pointer shrink-0',
                        activeFilter === 'In Progress' ? 'bg-primary text-surface-0 dark:text-surface-900 shadow-sm' : 'text-surface-500 dark:text-surface-400 hover:bg-surface-100 dark:hover:bg-surface-700'
                    ]"
                >
                    <i class="pi pi-clock text-sm" />
                    <span class="text-sm font-medium">In Progress</span>
                    <div
                        v-if="taskCounts.inProgress > 0"
                        :class="['px-2 py-1 rounded-sm text-sm font-semibold text-xs', activeFilter === 'In Progress' ? 'bg-white text-primary-600' : 'bg-surface-200 dark:bg-surface-600 text-surface-900 dark:text-surface-100']"
                    >
                        {{ taskCounts.inProgress }}
                    </div>
                </button>

                <button
                    @click="activeFilter = 'Completed'"
                    :class="[
                        'px-4 py-2 rounded-lg flex items-center gap-2 whitespace-nowrap transition-colors cursor-pointer shrink-0',
                        activeFilter === 'Completed' ? 'bg-primary text-surface-0 dark:text-surface-900 shadow-sm' : 'text-surface-500 dark:text-surface-400 hover:bg-surface-100 dark:hover:bg-surface-700'
                    ]"
                >
                    <i class="pi pi-check-circle text-sm" />
                    <span class="text-sm font-medium">Completed</span>
                    <div
                        v-if="taskCounts.completed > 0"
                        :class="['px-2 py-1 rounded-sm text-sm font-semibold text-xs', activeFilter === 'Completed' ? 'bg-white text-primary-600' : 'bg-surface-200 dark:bg-surface-600 text-surface-900 dark:text-surface-100']"
                    >
                        {{ taskCounts.completed }}
                    </div>
                </button>
            </div>
        </div>

        <div class="hidden lg:flex w-[237px] bg-surface-0 dark:bg-surface-900 border-r border-surface-200 dark:border-surface-700 flex-col overflow-hidden">
            <div class="p-6 flex flex-col gap-5">
                <Button icon="pi pi-plus" label="New Task" severity="secondary" outlined class="w-full cursor-pointer" @click="openNewTaskDrawer" />

                <Divider class="my-1!" />

                <div class="flex flex-col gap-3">
                    <div class="text-surface-500 text-sm font-medium">Task</div>

                    <button
                        @click="activeFilter = 'All Tasks'"
                        :class="[
                            'w-full px-4 py-2 rounded-lg flex items-center gap-3 transition-colors cursor-pointer',
                            activeFilter === 'All Tasks' ? 'bg-primary text-surface-0 dark:text-surface-900 shadow-sm' : 'text-surface-500 dark:text-surface-400 hover:bg-surface-100 dark:hover:bg-surface-700'
                        ]"
                    >
                        <i class="pi pi-list text-base" />
                        <span class="flex-1 text-left text-base font-medium">All Tasks</span>
                        <div
                            v-if="taskCounts.all > 0"
                            :class="['px-2 py-1 rounded-sm text-sm font-semibold text-xs', activeFilter === 'All Tasks' ? 'bg-white text-primary-600' : 'bg-surface-200 dark:bg-surface-600 text-surface-900 dark:text-surface-100']"
                        >
                            {{ taskCounts.all }}
                        </div>
                    </button>

                    <button
                        @click="activeFilter = 'Pending'"
                        :class="[
                            'w-full px-4 py-2 rounded-lg flex items-center gap-3 transition-colors cursor-pointer',
                            activeFilter === 'Pending' ? 'bg-primary text-surface-0 dark:text-surface-900 shadow-sm' : 'text-surface-500 dark:text-surface-400 hover:bg-surface-100 dark:hover:bg-surface-700'
                        ]"
                    >
                        <i class="pi pi-inbox text-base" />
                        <span class="flex-1 text-left text-base font-medium">Pending</span>
                        <div
                            v-if="taskCounts.inbox > 0"
                            :class="['px-2 py-1 rounded-sm text-sm font-semibold text-xs', activeFilter === 'Pending' ? 'bg-white text-primary-600' : 'bg-surface-200 dark:bg-surface-600 text-surface-900 dark:text-surface-100']"
                        >
                            {{ taskCounts.inbox }}
                        </div>
                    </button>

                    <button
                        @click="activeFilter = 'In Progress'"
                        :class="[
                            'w-full px-4 py-2 rounded-lg flex items-center gap-3 transition-colors cursor-pointer',
                            activeFilter === 'In Progress' ? 'bg-primary text-surface-0 dark:text-surface-900 shadow-sm' : 'text-surface-500 dark:text-surface-400 hover:bg-surface-100 dark:hover:bg-surface-700'
                        ]"
                    >
                        <i class="pi pi-clock text-base" />
                        <span class="flex-1 text-left text-base font-medium">In Progress</span>
                        <div
                            v-if="taskCounts.inProgress > 0"
                            :class="['px-2 py-1 rounded-sm text-sm font-semibold text-xs', activeFilter === 'In Progress' ? 'bg-white text-primary-600' : 'bg-surface-200 dark:bg-surface-600 text-surface-900 dark:text-surface-100']"
                        >
                            {{ taskCounts.inProgress }}
                        </div>
                    </button>

                    <button
                        @click="activeFilter = 'Completed'"
                        :class="[
                            'w-full px-4 py-2 rounded-lg flex items-center gap-3 transition-colors cursor-pointer',
                            activeFilter === 'Completed' ? 'bg-primary text-surface-0 dark:text-surface-900 shadow-sm' : 'text-surface-500 dark:text-surface-400 hover:bg-surface-100 dark:hover:bg-surface-700'
                        ]"
                    >
                        <i class="pi pi-check-circle text-base" />
                        <span class="flex-1 text-left text-base font-medium">Completed</span>
                        <div
                            v-if="taskCounts.completed > 0"
                            :class="['px-2 py-1 rounded-sm text-sm font-semibold text-xs', activeFilter === 'Completed' ? 'bg-white text-primary-600' : 'bg-surface-200 dark:bg-surface-600 text-surface-900 dark:text-surface-100']"
                        >
                            {{ taskCounts.completed }}
                        </div>
                    </button>
                </div>
            </div>
        </div>

        <div class="flex-1 flex flex-col overflow-hidden">
            <div class="hidden lg:flex p-6 border-b border-surface-200 dark:border-surface-700 items-center gap-4 px-8">
                <div class="flex-1">
                    <IconField>
                        <InputIcon class="pi pi-search" />
                        <InputText v-model="searchQuery" placeholder="Search" class="w-full" />
                    </IconField>
                </div>
            </div>

            <div class="lg:hidden p-4 border-b border-surface-200 dark:border-surface-700">
                <IconField>
                    <InputIcon class="pi pi-search" />
                    <InputText v-model="searchQuery" placeholder="Search tasks..." class="w-full" />
                </IconField>
            </div>

            <div class="flex-1 overflow-y-auto">
                <Accordion
                    v-model:value="openPanels"
                    multiple
                    class="w-full"
                    :pt="{
                        root: { class: 'border-none!' },
                        panel: { class: 'border-none! shadow-none' },
                        header: {
                            class: 'border-none! shadow-none p-0 cursor-pointer hover:bg-surface-50 dark:hover:bg-surface-800 rounded-lg transition-colors'
                        }
                    }"
                >
                    <AccordionPanel
                        v-if="pendingTasks.length > 0"
                        value="0"
                        :pt="{
                            root: { class: 'border-none!' }
                        }"
                    >
                        <AccordionHeader>
                            <div class="flex items-center gap-4 px-4 lg:px-6">
                                <h2 class="text-surface-900 dark:text-surface-0 text-lg font-semibold">{{ pendingTasks.length }} Tasks Pending</h2>
                            </div>
                        </AccordionHeader>
                        <AccordionContent>
                            <div class="flex flex-col">
                                <div v-for="(task, index) in pendingTasks" :key="task.id" class="flex flex-col">
                                    <div class="px-4 lg:px-8 pt-4 pb-2">
                                        <div class="flex items-center gap-3">
                                            <Checkbox v-model="task.completed" binary :input-id="`task-${task.id}`" class="" @change="() => toggleTaskCompletion(task, task.completed)" />
                                            <div class="text-base font-medium leading-normal transition-all duration-300 flex-1" :class="task.completed ? 'text-surface-500 line-through' : 'text-surface-900 dark:text-surface-0'">
                                                {{ task.title }}
                                            </div>
                                        </div>
                                        <div v-if="task.description" class="text-surface-500 text-sm leading-tight line-clamp-3 pl-8 pt-1">
                                            {{ task.description }}
                                        </div>
                                    </div>

                                    <div class="pl-8 lg:pl-16 pr-4 lg:pr-14 pt-2 pb-4 flex flex-col lg:flex-row lg:items-center gap-3">
                                        <div class="hidden lg:flex items-center gap-2 flex-1">
                                            <template v-if="task.startDate || task.endDate">
                                                <div v-if="task.startDate" class="flex items-center gap-2">
                                                    <span class="text-surface-500 text-base">Start</span>
                                                    <Tag :value="task.startDate" severity="secondary" />
                                                </div>

                                                <div v-if="task.startDate && task.endDate" class="w-px h-2.5 bg-surface-200 dark:bg-surface-700" />

                                                <div v-if="task.endDate" class="flex items-center gap-2">
                                                    <span class="text-surface-500 text-base">End</span>
                                                    <Tag :value="task.endDate" severity="secondary" />
                                                </div>

                                                <div v-if="task.members?.length > 0" class="w-px h-2.5 bg-surface-200 dark:bg-surface-700" />
                                            </template>

                                            <div class="flex-1 flex items-start">
                                                <AvatarGroup v-if="task.members?.length > 0">
                                                    <Avatar
                                                        v-for="member in task.members.slice(0, 5)"
                                                        :key="member.image"
                                                        :image="`/demo/images/avatar/${member.image}`"
                                                        size="small"
                                                        shape="circle"
                                                        class="border border-surface-0 dark:border-surface-900"
                                                    />
                                                    <Avatar v-if="task.members.length > 5" :label="`+${task.members.length - 5}`" shape="circle" size="small" class="bg-primary-500 text-surface-0 border border-surface-0 dark:border-surface-900" />
                                                </AvatarGroup>
                                            </div>
                                        </div>

                                        <div class="flex lg:hidden items-center justify-between">
                                            <div class="flex items-center gap-2 flex-wrap">
                                                <div v-if="task.startDate" class="flex items-center gap-1">
                                                    <i class="pi pi-calendar text-xs text-surface-500" />
                                                    <Tag :value="task.startDate" severity="secondary" size="small" />
                                                </div>

                                                <div v-if="task.startDate && task.endDate" class="text-surface-500 text-sm">-</div>

                                                <div v-if="task.endDate" class="flex items-center gap-1">
                                                    <Tag :value="task.endDate" severity="secondary" size="small" />
                                                </div>

                                                <div v-if="(task.startDate || task.endDate) && task.members?.length > 0" class="w-px h-3 bg-surface-200 dark:bg-surface-700" />

                                                <AvatarGroup v-if="task.members?.length > 0">
                                                    <Avatar
                                                        v-for="member in task.members.slice(0, 3)"
                                                        :key="member.image"
                                                        :image="`/demo/images/avatar/${member.image}`"
                                                        size="small"
                                                        shape="circle"
                                                        class="border border-surface-0 dark:border-surface-900"
                                                    />
                                                    <Avatar v-if="task.members.length > 3" :label="`+${task.members.length - 3}`" shape="circle" size="small" class="bg-primary-500 text-surface-0 border border-surface-0 dark:border-surface-900" />
                                                </AvatarGroup>
                                            </div>
                                        </div>

                                        <div class="flex items-center gap-2 lg:ml-auto">
                                            <Button icon="pi pi-pencil" text rounded size="small" severity="secondary" class="cursor-pointer" @click="openEditTaskDrawer(task)" />
                                            <Button icon="pi pi-trash" text rounded size="small" severity="secondary" class="cursor-pointer" @click="deleteTask(task.id)" />
                                        </div>
                                    </div>

                                    <div v-if="index < pendingTasks.length - 1" class="px-4 lg:px-14 py-2">
                                        <div class="border-t border-dashed border-surface-200 dark:border-surface-700" />
                                    </div>
                                </div>
                            </div>
                        </AccordionContent>
                    </AccordionPanel>

                    <AccordionPanel
                        v-if="inProgressTasks.length > 0"
                        value="1"
                        :pt="{
                            root: { class: 'border-none!' }
                        }"
                    >
                        <AccordionHeader>
                            <div class="flex items-center gap-4 px-4 lg:px-6">
                                <h2 class="text-surface-900 dark:text-surface-0 text-lg font-semibold">{{ inProgressTasks.length }} Tasks In Progress</h2>
                            </div>
                        </AccordionHeader>
                        <AccordionContent>
                            <div class="flex flex-col">
                                <div v-for="(task, index) in inProgressTasks" :key="task.id" class="flex flex-col">
                                    <div class="px-4 lg:px-8 pt-4 pb-2">
                                        <div class="flex items-center gap-3">
                                            <Checkbox v-model="task.completed" binary :input-id="`task-${task.id}`" class="" @change="() => toggleTaskCompletion(task, task.completed)" />
                                            <div class="text-base font-medium leading-normal transition-all duration-300 flex-1" :class="task.completed ? 'text-surface-500 line-through' : 'text-surface-900 dark:text-surface-0'">
                                                {{ task.title }}
                                            </div>
                                        </div>
                                        <div v-if="task.description" class="text-surface-500 text-sm leading-tight line-clamp-3 pl-8 pt-1">
                                            {{ task.description }}
                                        </div>
                                    </div>

                                    <div class="pl-8 lg:pl-16 pr-4 lg:pr-14 pt-2 pb-4 flex flex-col lg:flex-row lg:items-center gap-3">
                                        <div class="hidden lg:flex items-center gap-2 flex-1">
                                            <template v-if="task.startDate || task.endDate">
                                                <div v-if="task.startDate" class="flex items-center gap-2">
                                                    <span class="text-surface-500 text-base">Start</span>
                                                    <Tag :value="task.startDate" severity="secondary" />
                                                </div>

                                                <div v-if="task.startDate && task.endDate" class="w-px h-2.5 bg-surface-200 dark:bg-surface-700" />

                                                <div v-if="task.endDate" class="flex items-center gap-2">
                                                    <span class="text-surface-500 text-base">End</span>
                                                    <Tag :value="task.endDate" severity="secondary" />
                                                </div>

                                                <div v-if="task.members?.length > 0" class="w-px h-2.5 bg-surface-200 dark:bg-surface-700" />
                                            </template>

                                            <div class="flex-1 flex items-start">
                                                <AvatarGroup v-if="task.members?.length > 0">
                                                    <Avatar
                                                        v-for="member in task.members.slice(0, 5)"
                                                        :key="member.image"
                                                        :image="`/demo/images/avatar/${member.image}`"
                                                        size="small"
                                                        shape="circle"
                                                        class="border border-surface-0 dark:border-surface-900"
                                                    />
                                                    <Avatar v-if="task.members.length > 5" :label="`+${task.members.length - 5}`" shape="circle" size="small" class="bg-primary-500 text-surface-0 border border-surface-0 dark:border-surface-900" />
                                                </AvatarGroup>
                                            </div>
                                        </div>

                                        <div class="flex lg:hidden items-center justify-between">
                                            <div class="flex items-center gap-2 flex-wrap">
                                                <div v-if="task.startDate" class="flex items-center gap-1">
                                                    <i class="pi pi-calendar text-xs text-surface-500" />
                                                    <Tag :value="task.startDate" severity="secondary" size="small" />
                                                </div>

                                                <div v-if="task.startDate && task.endDate" class="text-surface-500 text-sm">-</div>

                                                <div v-if="task.endDate" class="flex items-center gap-1">
                                                    <Tag :value="task.endDate" severity="secondary" size="small" />
                                                </div>

                                                <div v-if="(task.startDate || task.endDate) && task.members?.length > 0" class="w-px h-3 bg-surface-200 dark:bg-surface-700" />

                                                <AvatarGroup v-if="task.members?.length > 0">
                                                    <Avatar
                                                        v-for="member in task.members.slice(0, 3)"
                                                        :key="member.image"
                                                        :image="`/demo/images/avatar/${member.image}`"
                                                        size="small"
                                                        shape="circle"
                                                        class="border border-surface-0 dark:border-surface-900"
                                                    />
                                                    <Avatar v-if="task.members.length > 3" :label="`+${task.members.length - 3}`" shape="circle" size="small" class="bg-primary-500 text-surface-0 border border-surface-0 dark:border-surface-900" />
                                                </AvatarGroup>
                                            </div>
                                        </div>

                                        <div class="flex items-center gap-2 lg:ml-auto">
                                            <Button icon="pi pi-pencil" text rounded size="small" severity="secondary" class="cursor-pointer" @click="openEditTaskDrawer(task)" />
                                            <Button icon="pi pi-trash" text rounded size="small" severity="secondary" class="cursor-pointer" @click="deleteTask(task.id)" />
                                        </div>
                                    </div>

                                    <div v-if="index < inProgressTasks.length - 1" class="px-4 lg:px-14 py-2">
                                        <div class="border-t border-dashed border-surface-200 dark:border-surface-700" />
                                    </div>
                                </div>
                            </div>
                        </AccordionContent>
                    </AccordionPanel>

                    <AccordionPanel
                        v-if="completedTasks.length > 0"
                        value="2"
                        :pt="{
                            root: { class: 'border-none!' }
                        }"
                    >
                        <AccordionHeader>
                            <div class="flex items-center gap-4 px-4 lg:px-6">
                                <h2 class="text-surface-900 dark:text-surface-0 text-lg font-semibold">{{ completedTasks.length }} Tasks Completed</h2>
                            </div>
                        </AccordionHeader>
                        <AccordionContent>
                            <div class="flex flex-col">
                                <div v-for="(task, index) in completedTasks" :key="task.id" class="flex flex-col">
                                    <div class="px-4 lg:px-8 pt-4 pb-2">
                                        <div class="flex items-center gap-3">
                                            <Checkbox v-model="task.completed" binary :input-id="`task-${task.id}`" class="" @change="() => toggleTaskCompletion(task, task.completed)" />
                                            <div class="text-surface-500 text-base font-medium leading-normal line-through flex-1">
                                                {{ task.title }}
                                            </div>
                                        </div>
                                        <div v-if="task.description" class="text-surface-500 text-sm leading-tight line-clamp-3 pl-8 pt-1">
                                            {{ task.description }}
                                        </div>
                                    </div>

                                    <div class="pl-8 lg:pl-16 pr-4 lg:pr-14 pt-2 pb-4 flex flex-col lg:flex-row lg:items-center gap-3">
                                        <div class="hidden lg:flex items-center gap-2 flex-1">
                                            <template v-if="task.startDate || task.endDate">
                                                <div v-if="task.startDate" class="flex items-center gap-2">
                                                    <span class="text-surface-500 text-base">Start</span>
                                                    <Tag :value="task.startDate" severity="secondary" />
                                                </div>

                                                <div v-if="task.startDate && task.endDate" class="w-px h-2.5 bg-surface-200 dark:bg-surface-700" />

                                                <div v-if="task.endDate" class="flex items-center gap-2">
                                                    <span class="text-surface-500 text-base">End</span>
                                                    <Tag :value="task.endDate" severity="secondary" />
                                                </div>

                                                <div v-if="task.members?.length > 0" class="w-px h-2.5 bg-surface-200 dark:bg-surface-700" />
                                            </template>

                                            <div class="flex-1 flex items-start">
                                                <AvatarGroup v-if="task.members?.length > 0">
                                                    <Avatar
                                                        v-for="member in task.members.slice(0, 5)"
                                                        :key="member.image"
                                                        :image="`/demo/images/avatar/${member.image}`"
                                                        size="small"
                                                        shape="circle"
                                                        class="border border-surface-0 dark:border-surface-900"
                                                    />
                                                    <Avatar v-if="task.members.length > 5" :label="`+${task.members.length - 5}`" shape="circle" size="small" class="bg-primary-500 text-surface-0 border border-surface-0 dark:border-surface-900" />
                                                </AvatarGroup>
                                            </div>
                                        </div>

                                        <div class="flex lg:hidden items-center justify-between">
                                            <div class="flex items-center gap-2 flex-wrap">
                                                <div v-if="task.startDate" class="flex items-center gap-1">
                                                    <i class="pi pi-calendar text-xs text-surface-500" />
                                                    <Tag :value="task.startDate" severity="secondary" size="small" />
                                                </div>

                                                <div v-if="task.startDate && task.endDate" class="text-surface-500 text-sm">-</div>

                                                <div v-if="task.endDate" class="flex items-center gap-1">
                                                    <Tag :value="task.endDate" severity="secondary" size="small" />
                                                </div>

                                                <div v-if="(task.startDate || task.endDate) && task.members?.length > 0" class="w-px h-3 bg-surface-200 dark:bg-surface-700" />

                                                <AvatarGroup v-if="task.members?.length > 0">
                                                    <Avatar
                                                        v-for="member in task.members.slice(0, 3)"
                                                        :key="member.image"
                                                        :image="`/demo/images/avatar/${member.image}`"
                                                        size="small"
                                                        shape="circle"
                                                        class="border border-surface-0 dark:border-surface-900"
                                                    />
                                                    <Avatar v-if="task.members.length > 3" :label="`+${task.members.length - 3}`" shape="circle" size="small" class="bg-primary-500 text-surface-0 border border-surface-0 dark:border-surface-900" />
                                                </AvatarGroup>
                                            </div>
                                        </div>

                                        <div class="flex items-center gap-2 lg:ml-auto">
                                            <Button icon="pi pi-pencil" text rounded size="small" severity="secondary" class="cursor-pointer" @click="openEditTaskDrawer(task)" />
                                            <Button icon="pi pi-trash" text rounded size="small" severity="secondary" class="cursor-pointer" @click="deleteTask(task.id)" />
                                        </div>
                                    </div>

                                    <div v-if="index < completedTasks.length - 1" class="px-4 lg:px-14 py-2">
                                        <div class="border-t border-dashed border-surface-200 dark:border-surface-700" />
                                    </div>
                                </div>
                            </div>
                        </AccordionContent>
                    </AccordionPanel>
                </Accordion>

                <div class="px-4 lg:px-14 py-3 flex items-center gap-3 cursor-pointer hover:bg-surface-50 dark:hover:bg-surface-800 transition-colors" @click="openNewTaskDrawer">
                    <i class="pi pi-plus text-xs text-surface-500" />
                    <span class="text-surface-500 text-base font-medium">Add New Task</span>
                </div>
            </div>
        </div>

        <ConfirmDialog />

        <TaskDrawer v-model:visible="isDrawerVisible" :task="selectedTask" :mode="drawerMode" @save="handleDrawerSave" @cancel="handleDrawerCancel" />
    </div>
</template>
