<script setup>
import { FilterMatchMode } from '@primevue/core/api';
import { useConfirm } from 'primevue/useconfirm';
import { ref } from 'vue';
import { useRouter } from 'vue-router';

const confirm = useConfirm();
const router = useRouter();

const selectedUsers = ref([]);
const filters = ref({
    global: { value: null, matchMode: FilterMatchMode.CONTAINS }
});

const users = ref([
    {
        id: 1,
        name: 'Brook Simmons',
        avatar: '/demo/images/avatar/avatar-f-3.png',
        role: 'Admin',
        department: 'Sales',
        joinDate: 'Feb 5th, 2025',
        authorizationLevel: 'Full Access',
        status: 'Active'
    },
    {
        id: 2,
        name: 'Dianne Russell',
        avatar: '/demo/images/avatar/avatar-f-5.png',
        role: 'Manager',
        department: 'HR',
        joinDate: 'Feb 24th, 2025',
        authorizationLevel: 'Viewing Only',
        status: 'Deactive'
    },
    {
        id: 3,
        name: 'Amy Elsner',
        avatar: '/demo/images/avatar/amyelsner.png',
        role: 'Admin',
        department: 'Marketing',
        joinDate: 'Feb 24th, 2025',
        authorizationLevel: 'Restricted',
        status: 'Active'
    },
    {
        id: 4,
        name: 'Guy Hawkins',
        avatar: '/demo/images/avatar/avatar-m-2.png',
        role: 'Admin',
        department: 'Marketing',
        joinDate: 'Jan 28th, 2025',
        authorizationLevel: 'Restricted',
        status: 'Active'
    },
    {
        id: 5,
        name: 'Darrell Steward',
        avatar: '/demo/images/avatar/avatar-m-4.png',
        role: 'Employee',
        department: 'Sales',
        joinDate: 'Jan 21th, 2025',
        authorizationLevel: 'Viewing Only',
        status: 'Deactive'
    },
    {
        id: 6,
        name: 'Onyama Limba',
        avatar: '/demo/images/avatar/onyamalimba.png',
        role: 'Manager',
        department: 'HR',
        joinDate: 'Jan 21th, 2025',
        authorizationLevel: 'Full Access',
        status: 'Deactive'
    },
    {
        id: 7,
        name: 'Arlene McCoy',
        avatar: '/demo/images/avatar/avatar-f-7.png',
        role: 'Manager',
        department: 'HR',
        joinDate: 'Jan 21th, 2025',
        authorizationLevel: 'Full Access',
        status: 'Deactive'
    },
    {
        id: 8,
        name: 'Annette Black',
        avatar: '/demo/images/avatar/annafali.png',
        role: 'Employee',
        department: 'Marketing',
        joinDate: 'Jan 28th, 2025',
        authorizationLevel: 'Full Access',
        status: 'Active'
    }
]);

const tableMenuRefs = ref({});

const first = ref(0);
const rows = ref(8);

// Edit dialog state
const editDialogVisible = ref(false);
const editingUser = ref(null);
const editForm = ref({
    name: '',
    role: '',
    department: '',
    joinDate: '',
    authorizationLevel: '',
    status: ''
});

// Dropdown options
const roleOptions = ref(['Admin', 'Manager', 'Employee']);
const departmentOptions = ref(['Sales', 'HR', 'Marketing']);
const authorizationLevelOptions = ref(['Full Access', 'Viewing Only', 'Restricted']);
const statusOptions = ref(['Active', 'Deactive']);

const createTableMenuItems = (userId) => [
    {
        label: 'Edit',
        icon: 'pi pi-pencil',
        command: () => openEditDialog(userId)
    },
    {
        label: 'Delete',
        icon: 'pi pi-trash',
        command: () => confirmDelete(userId)
    }
];

const toggleTableMenu = (event, userId) => {
    const menuKey = `tableMenu_${userId}`;
    const menu = tableMenuRefs.value[menuKey];
    if (menu) {
        menu.toggle(event);
    }
};

const getStatusSeverity = (status) => {
    return status === 'Active' ? 'primary' : 'danger';
};

// Edit dialog functions
const openEditDialog = (userId) => {
    const user = users.value.find((u) => u.id === userId);
    if (user) {
        editingUser.value = user;
        editForm.value = {
            name: user.name,
            role: user.role,
            department: user.department,
            joinDate: user.joinDate,
            authorizationLevel: user.authorizationLevel,
            status: user.status
        };
        editDialogVisible.value = true;
    }
};

const saveUser = () => {
    if (editingUser.value) {
        const user = users.value.find((u) => u.id === editingUser.value.id);
        if (user) {
            user.name = editForm.value.name;
            user.role = editForm.value.role;
            user.department = editForm.value.department;
            user.joinDate = editForm.value.joinDate;
            user.authorizationLevel = editForm.value.authorizationLevel;
            user.status = editForm.value.status;
        }
        editDialogVisible.value = false;
        editingUser.value = null;
    }
};

const closeEditDialog = () => {
    editDialogVisible.value = false;
    editingUser.value = null;
};

// Navigate to create user page
const addNewUser = () => {
    router.push('/profile/create/basic-information');
};

// Delete confirmation
const confirmDelete = (userId) => {
    confirm.require({
        message: 'Are you sure you want to delete this user?',
        header: 'Confirm Deletion',
        icon: 'pi pi-exclamation-triangle',
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
            deleteUser(userId);
        }
    });
};

const deleteUser = (userId) => {
    const index = users.value.findIndex((u) => u.id === userId);
    if (index !== -1) {
        users.value.splice(index, 1);
    }
};
</script>

<template>
    <div class="flex flex-col bg-surface-0 dark:bg-surface-900 rounded-2xl border border-surface-200 dark:border-surface-700 overflow-hidden">
        <!-- Header -->
        <div class="px-6 py-5 border-b border-surface-200 dark:border-surface-700 flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
            <h1 class="text-surface-950 dark:text-surface-0 text-lg font-medium leading-7">User List</h1>

            <div class="flex flex-col sm:flex-row items-stretch sm:items-center gap-3 w-full sm:w-auto">
                <IconField class="w-full sm:w-[217px]">
                    <InputIcon>
                        <i class="pi pi-search" />
                    </InputIcon>
                    <InputText v-model="filters.global.value" placeholder="Search" class="w-full! py-2! rounded-xl!" />
                </IconField>

                <Button icon="pi pi-plus" label="Add New" severity="primary" rounded class="w-full sm:w-auto cursor-pointer" @click="addNewUser" />
            </div>
        </div>

        <!-- Table -->
        <div class="flex-1 px-6 py-5">
            <DataTable
                :value="users"
                v-model:selection="selectedUsers"
                v-model:filters="filters"
                :paginator="true"
                :rows="rows"
                :first="first"
                sortMode="multiple"
                tableClass="w-full"
                paginatorTemplate="FirstPageLink PrevPageLink PageLinks NextPageLink LastPageLink CurrentPageReport"
                :currentPageReportTemplate="`Shows {first} to {last} of {totalRecords} results`"
                :globalFilterFields="['name', 'role', 'department', 'joinDate', 'authorizationLevel', 'status']"
                class="bg-surface-0 dark:bg-surface-800 overflow-hidden"
                :pt="{ pcpaginator: { root: { class: 'rounded-none!' } } }"
            >
                <Column selectionMode="multiple" class="w-12" />

                <Column field="name" header="Name" sortable class="flex-1">
                    <template #body="slotProps">
                        <div class="flex items-center gap-2">
                            <img :src="slotProps.data.avatar" alt="" class="w-8 h-8 rounded-full" />
                            <span class="text-surface-950 dark:text-surface-0 text-sm font-medium leading-tight">{{ slotProps.data.name }}</span>
                        </div>
                    </template>
                </Column>

                <Column field="role" header="Role / Position" sortable class="flex-1">
                    <template #body="slotProps">
                        <span class="text-surface-500 dark:text-surface-400 text-sm font-normal leading-tight">{{ slotProps.data.role }}</span>
                    </template>
                </Column>

                <Column field="department" header="Department" sortable class="flex-1">
                    <template #body="slotProps">
                        <span class="text-surface-500 dark:text-surface-400 text-sm font-normal leading-tight">{{ slotProps.data.department }}</span>
                    </template>
                </Column>

                <Column field="joinDate" header="Join Date" sortable class="flex-1">
                    <template #body="slotProps">
                        <span class="text-surface-500 dark:text-surface-400 text-sm font-normal leading-tight">{{ slotProps.data.joinDate }}</span>
                    </template>
                </Column>

                <Column field="authorizationLevel" header="Authorization Level" sortable class="flex-1">
                    <template #body="slotProps">
                        <span class="text-surface-500 dark:text-surface-400 text-sm font-normal leading-tight">{{ slotProps.data.authorizationLevel }}</span>
                    </template>
                </Column>

                <Column field="status" header="Employment Status" sortable class="flex-1">
                    <template #body="slotProps">
                        <Tag :value="slotProps.data.status" :severity="getStatusSeverity(slotProps.data.status)" class="px-2 py-1 rounded-[6px]" />
                    </template>
                </Column>

                <Column header="Actions" class="w-24">
                    <template #body="slotProps">
                        <div class="flex items-center gap-1">
                            <Button @click="toggleTableMenu($event, slotProps.data.id)" rounded text icon="pi pi-ellipsis-h" size="small" severity="secondary" class="cursor-pointer" />
                            <Menu
                                :ref="
                                    (el) => {
                                        if (el) tableMenuRefs[`tableMenu_${slotProps.data.id}`] = el;
                                    }
                                "
                                :model="createTableMenuItems(slotProps.data.id)"
                                :popup="true"
                                class="w-48!"
                            />
                        </div>
                    </template>
                </Column>
            </DataTable>
        </div>

        <!-- Edit User Dialog -->
        <Dialog v-model:visible="editDialogVisible" modal header="Edit User" :style="{ width: '30rem' }" class="p-fluid">
            <div class="flex flex-col gap-4 py-4">
                <div class="flex flex-col gap-2">
                    <label for="name" class="text-surface-900 dark:text-surface-0 font-medium">Name</label>
                    <InputText id="name" v-model="editForm.name" class="w-full" />
                </div>

                <div class="flex flex-col gap-2">
                    <label for="role" class="text-surface-900 dark:text-surface-0 font-medium">Role / Position</label>
                    <Select id="role" v-model="editForm.role" :options="roleOptions" placeholder="Select a role" class="w-full" />
                </div>

                <div class="flex flex-col gap-2">
                    <label for="department" class="text-surface-900 dark:text-surface-0 font-medium">Department</label>
                    <Select id="department" v-model="editForm.department" :options="departmentOptions" placeholder="Select a department" class="w-full" />
                </div>

                <div class="flex flex-col gap-2">
                    <label for="joinDate" class="text-surface-900 dark:text-surface-0 font-medium">Join Date</label>
                    <InputText id="joinDate" v-model="editForm.joinDate" class="w-full" />
                </div>

                <div class="flex flex-col gap-2">
                    <label for="authorizationLevel" class="text-surface-900 dark:text-surface-0 font-medium">Authorization Level</label>
                    <Select id="authorizationLevel" v-model="editForm.authorizationLevel" :options="authorizationLevelOptions" placeholder="Select authorization level" class="w-full" />
                </div>

                <div class="flex flex-col gap-2">
                    <label for="status" class="text-surface-900 dark:text-surface-0 font-medium">Employment Status</label>
                    <Select id="status" v-model="editForm.status" :options="statusOptions" placeholder="Select status" class="w-full" />
                </div>
            </div>

            <template #footer>
                <div class="flex justify-end gap-2">
                    <Button label="Cancel" severity="secondary" outlined @click="closeEditDialog" />
                    <Button label="Save" @click="saveUser" />
                </div>
            </template>
        </Dialog>

        <!-- Delete Confirmation Dialog -->
        <ConfirmDialog />
    </div>
</template>
