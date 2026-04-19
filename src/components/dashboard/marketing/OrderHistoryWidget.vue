<script setup>
import { ref } from 'vue';
import { FilterMatchMode } from '@primevue/core/api';

const filters = ref({
    global: { value: null, matchMode: FilterMatchMode.CONTAINS }
});
const history = ref([
    {
        id: '#1260',
        date: 'May 5th, 2024',
        name: {
            value: 'Jerome Bell',
            bgColor: 'lime',
            capName: 'JB'
        },
        templateName: 'Apollo',
        emailAddress: 'jeromebell@gmail.com',
        process: 'paid',
        revenue: '$59'
    },
    {
        id: '#1259',
        date: 'Mar 17th, 2024',
        name: {
            value: 'Annette Black',
            bgColor: 'indigo',
            capName: 'AB'
        },
        templateName: 'Verona',
        emailAddress: 'hi@annetteblack.com',
        process: 'paid',
        revenue: '$59'
    },
    {
        id: '#1258',
        date: 'May 24th, 2024',
        name: {
            value: 'Onyama Limba',
            bgColor: 'rose',
            capName: 'OL'
        },
        templateName: 'Freya',
        emailAddress: 'hi@onyamalimba.co',
        process: 'paid',
        revenue: '$59'
    },
    {
        id: '#1257',
        date: 'Jun 28th, 2024',
        name: {
            value: 'Courtney Henry',
            bgColor: 'violet',
            capName: 'CH'
        },
        templateName: 'Sakai',
        emailAddress: 'hi@courtneyhenry.com',
        process: 'free',
        revenue: null
    },
    {
        id: '#1256',
        date: 'Jul 21th, 2024',
        name: {
            value: 'Dianne Russell',
            bgColor: 'cyan',
            capName: 'DR'
        },
        templateName: 'Ultima',
        emailAddress: 'hi@diannerussell.com',
        process: 'paid',
        revenue: '$59'
    },
    {
        id: '#1255',
        date: 'Jul 21th, 2024',
        name: {
            value: 'Amy Elsner',
            bgColor: 'yellow',
            capName: 'AE'
        },
        templateName: 'Sakai',
        emailAddress: 'hi@amyelsner.com',
        process: 'free',
        revenue: null
    },
    {
        id: '#1254',
        date: 'Jun 28th, 2024',
        name: {
            value: 'Arlene McCoy',
            bgColor: 'blue',
            capName: 'AM'
        },
        templateName: 'Altantis',
        emailAddress: 'hi@arlenemccoy.com',
        process: 'paid',
        revenue: '$59'
    },
    {
        id: '#1298',
        date: 'Jul 21th, 2024',
        name: {
            value: 'Amy Elsner',
            bgColor: 'yellow',
            capName: 'AE'
        },
        templateName: 'Sakai',
        emailAddress: 'hi@amyelsner.com',
        process: 'free',
        revenue: null
    },
    {
        id: '#1299',
        date: 'Jun 28th, 2024',
        name: {
            value: 'Arlene McCoy',
            bgColor: 'blue',
            capName: 'AM'
        },
        templateName: 'Altantis',
        emailAddress: 'hi@arlenemccoy.com',
        process: 'paid',
        revenue: '$59'
    }
]);
const selectedHistory = ref(null);
defineProps({
    class: {
        type: String
    }
});
</script>

<template>
    <div :class="class" class="w-full overflow-auto">
        <div class="flex lg:flex-row flex-col lg:items-center justify-between mb-4 w-full gap-6">
            <div class="flex-1">
                <div class="label-medium">Order History</div>
                <span class="mt-1 body-xsmall">This field displays the order history</span>
            </div>
            <div class="flex items-center gap-3.5">
                <IconField>
                    <InputIcon class="pi pi-search" />
                    <InputText class="rounded-lg! py-1.5! w-56!" v-model="filters['global'].value" placeholder="Search" />
                </IconField>
                <Button label="Filter" icon="pi pi-filter" severity="secondary" outlined class="text-surface-950! dark:text-surface-0! py-1.5! rounded-lg!" />
                <Button label="Export" icon="pi pi-download" severity="contrast" class="text-surface-0! dark:text-surface-950! py-1.5! rounded-lg!" />
            </div>
        </div>
        <div class="w-full overflow-hidden">
            <DataTable
                :rows="7"
                tableStyle="min-width: 90rem"
                paginator
                paginatorTemplate="PrevPageLink PageLinks NextPageLink  CurrentPageReport RowsPerPageDropdown"
                currentPageReportTemplate="Showing page {currentPage} of {totalPages} pages"
                pt:pcpaginator:root="bg-transparent!"
                :pt="{
                    thead: {
                        class: 'label-small!'
                    }
                }"
                :dt="{
                    header: {
                        background: 'transparent'
                    },
                    headerCell: {
                        background: 'transparent'
                    },
                    row: {
                        background: 'transparent'
                    }
                }"
                v-model:selection="selectedHistory"
                v-model:filters="filters"
                :value="history"
                :globalFilterFields="['id', 'date', 'name.value', 'templateName', 'emailAddress', 'process', 'revenue']"
                dataKey="id"
            >
                <Column selectionMode="multiple" headerStyle="width: 3rem" />
                <Column field="id" header="ID">
                    <template #body="{ data }">
                        <div class="body-xsmall text-left">
                            {{ data.id }}
                        </div>
                    </template>
                </Column>
                <Column field="date" header="Date">
                    <template #body="{ data }">
                        <div class="body-xsmall text-left">
                            {{ data.date }}
                        </div>
                    </template>
                </Column>
                <Column field="name" header="Name">
                    <template #body="{ data }">
                        <div class="flex items-center">
                            <Avatar
                                :label="data.name.capName"
                                class="mr-2 w-8! h-8! text-xs! font-medium"
                                size="small"
                                :style="{ backgroundColor: 'var(--p-' + data.name.bgColor + '-100)', color: 'var(--p-' + data.name.bgColor + '-950)' }"
                                shape="circle"
                            />
                            <div class="label-xsmall text-surface-950 dark:text-surface-0">{{ data.name.value }}</div>
                        </div>
                    </template>
                </Column>
                <Column field="templateName" header="Template Name">
                    <template #body="{ data }">
                        <div class="body-xsmall text-left">
                            {{ data.templateName }}
                        </div>
                    </template>
                </Column>
                <Column field="emailAddress" header="Email Address">
                    <template #body="{ data }">
                        <div class="body-xsmall text-left">
                            {{ data.emailAddress }}
                        </div>
                    </template>
                </Column>
                <Column field="process" header="Process">
                    <template #body="{ data }">
                        <div class="body-xsmall capitalize text-left text-surface-950 dark:text-surface-0">
                            <Tag :severity="data.process === 'paid' ? 'success' : 'warn'" :value="data.process" pt:label:class="font-normal!" class="px-2! py-1! rounded-lg!" />
                        </div>
                    </template>
                </Column>
                <Column field="revenue" header="Revenue">
                    <template #body="{ data }">
                        <div class="body-xsmall text-left text-surface-950 dark:text-surface-0">
                            {{ data.revenue ?? '-' }}
                        </div>
                    </template>
                </Column>
                <Column>
                    <template #body>
                        <div class="flex items-end justify-end">
                            <button class="text-right text-surface-700 dark:text-surface-300">
                                <i class="pi pi-ellipsis-h" />
                            </button>
                        </div>
                    </template>
                </Column>
            </DataTable>
        </div>
    </div>
</template>
