<script setup>
import { computed, ref, watch } from 'vue';

const props = defineProps({
    visible: {
        type: Boolean,
        default: false
    },
    task: {
        type: Object,
        default: null
    },
    mode: {
        type: String,
        default: 'create',
        validator: (value) => ['create', 'edit'].includes(value)
    }
});

const emit = defineEmits(['update:visible', 'save', 'cancel']);

const isVisible = computed({
    get: () => props.visible,
    set: (value) => emit('update:visible', value)
});

const formData = ref({
    id: null,
    title: '',
    description: '',
    status: 'pending',
    completed: false,
    startDate: null,
    endDate: null,
    members: []
});

const statusOptions = [
    { label: 'Pending', value: 'pending' },
    { label: 'In Progress', value: 'in-progress' },
    { label: 'Completed', value: 'completed' }
];

const filteredMembers = ref([]);

const availableMembers = [
    { name: 'Amy Elsner', image: 'amyelsner.png' },
    { name: 'Anna Fali', image: 'annafali.png' },
    { name: 'Asiya Javayant', image: 'asiyajavayant.png' },
    { name: 'Bernardo Dominic', image: 'bernardodominic.png' }
];

watch(
    () => props.task,
    (newTask) => {
        if (newTask) {
            formData.value = {
                id: newTask.id,
                title: newTask.title || '',
                description: newTask.description || '',
                status: newTask.status || 'pending',
                completed: newTask.completed || false,
                startDate: newTask.startDate ? new Date(newTask.startDate.split('.').reverse().join('-')) : null,
                endDate: newTask.endDate ? new Date(newTask.endDate.split('.').reverse().join('-')) : null,
                members: newTask.members || []
            };
        } else {
            resetForm();
        }
    },
    { immediate: true }
);

function resetForm() {
    formData.value = {
        id: null,
        title: '',
        description: '',
        status: 'pending',
        completed: false,
        startDate: null,
        endDate: null,
        members: []
    };
}

function filterMembers(event) {
    if (!event.query) {
        filteredMembers.value = availableMembers;
        return;
    }

    filteredMembers.value = availableMembers.filter((member) => member.name.toLowerCase().includes(event.query.toLowerCase()));
}

function formatDateForSave(date) {
    if (!date) return null;
    const d = new Date(date);
    return `${String(d.getDate()).padStart(2, '0')}.${String(d.getMonth() + 1).padStart(2, '0')}.${d.getFullYear()}`;
}

function handleSave() {
    const taskData = {
        ...formData.value,
        startDate: formatDateForSave(formData.value.startDate),
        endDate: formatDateForSave(formData.value.endDate),
        completed: formData.value.status === 'completed'
    };

    emit('save', taskData);
    handleCancel();
}

function handleCancel() {
    resetForm();
    emit('cancel');
}

function onHide() {
    handleCancel();
}

const drawerTitle = computed(() => {
    return props.mode === 'create' ? 'Create New Task' : 'Edit Task';
});
</script>

<template>
    <Drawer v-model:visible="isVisible" header="Task Details" position="right" class="!w-full md:!w-[420px]" @hide="onHide">
        <template #header>
            <div class="flex items-center gap-3">
                <i class="pi pi-list-check text-xl text-primary-500" />
                <span class="text-surface-900 dark:text-surface-0 font-semibold text-lg">{{ drawerTitle }}</span>
            </div>
        </template>

        <div class="flex flex-col gap-6 p-1">
            <div class="flex flex-col gap-2">
                <label for="task-title" class="text-surface-900 dark:text-surface-0 font-medium text-sm">Task Title</label>
                <InputText id="task-title" v-model="formData.title" placeholder="Enter task title..." class="w-full" />
            </div>

            <div class="flex flex-col gap-2">
                <label for="task-description" class="text-surface-900 dark:text-surface-0 font-medium text-sm">Description</label>
                <Textarea id="task-description" v-model="formData.description" placeholder="Enter task description..." rows="4" class="w-full" />
            </div>

            <div class="flex flex-col gap-2">
                <label for="task-status" class="text-surface-900 dark:text-surface-0 font-medium text-sm">Status</label>
                <Select id="task-status" v-model="formData.status" :options="statusOptions" option-label="label" option-value="value" placeholder="Select status" class="w-full" />
            </div>

            <Divider class="my-2" />

            <div class="flex flex-col gap-2">
                <label for="start-date" class="text-surface-900 dark:text-surface-0 font-medium text-sm">Start Date</label>
                <DatePicker id="start-date" v-model="formData.startDate" date-format="dd.mm.yy" placeholder="Select start date" class="w-full" />
            </div>

            <div class="flex flex-col gap-2">
                <label for="end-date" class="text-surface-900 dark:text-surface-0 font-medium text-sm">End Date</label>
                <DatePicker id="end-date" v-model="formData.endDate" date-format="dd.mm.yy" placeholder="Select end date" class="w-full" />
            </div>

            <Divider class="my-2" />

            <div class="flex flex-col gap-2">
                <label for="team-members" class="text-surface-900 dark:text-surface-0 font-medium text-sm">Team Members</label>
                <AutoComplete id="team-members" v-model="formData.members" :suggestions="filteredMembers" option-label="name" multiple placeholder="Search team members..." @complete="filterMembers" class="w-full">
                    <template #chip="{ value }">
                        <div class="flex items-center gap-2 bg-surface-50 dark:bg-surface-900 px-2 py-1 rounded">
                            <img :src="`/demo/images/avatar/${value.image}`" :alt="value.name" class="w-5 h-5 rounded-full border border-surface-200 dark:border-surface-700" />
                        </div>
                    </template>
                    <template #option="{ option }">
                        <div class="flex items-center gap-3">
                            <img :src="`/demo/images/avatar/${option.image}`" :alt="option.name" class="w-8 h-8 rounded-full border border-surface-200 dark:border-surface-700" />
                            <span class="text-surface-900 dark:text-surface-0 font-medium">{{ option.name }}</span>
                        </div>
                    </template>
                </AutoComplete>
            </div>
        </div>

        <template #footer>
            <div class="flex justify-end gap-3 pt-4 border-t border-surface-200 dark:border-surface-700">
                <Button label="Cancel" icon="pi pi-times" outlined severity="secondary" @click="handleCancel" class="flex-1" />
                <Button :label="mode === 'create' ? 'Create Task' : 'Update Task'" :icon="mode === 'create' ? 'pi pi-plus' : 'pi pi-check'" @click="handleSave" class="flex-1" />
            </div>
        </template>
    </Drawer>
</template>
