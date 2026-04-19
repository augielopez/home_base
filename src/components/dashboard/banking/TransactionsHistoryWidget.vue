<script setup>
import { ref } from 'vue';

const selectedTransactions = ref(null);

const transactions = ref([
    {
        id: '1',
        name: {
            value: 'Jerome Bell',
            bgColor: 'lime',
            capName: 'JB'
        },
        date: 'May 5th, 2024',
        amount: '+£12.875,98',
        account: '**** **** 8288'
    },
    {
        id: '2',
        name: {
            value: 'Annette Black',
            bgColor: 'indigo',
            capName: 'AB'
        },
        date: 'Mar 17th, 2024',
        amount: '+€7.245,44',
        account: '**** **** 9284'
    },
    {
        id: '3',
        name: {
            value: 'Onyama Limba',
            bgColor: 'rose',
            capName: 'OL'
        },
        date: 'May 24th, 2024',
        amount: '-₺76.276,90',
        account: '**** **** 2534'
    },
    {
        id: '4',
        name: {
            value: 'Courtney Henry',
            bgColor: 'violet',
            capName: 'CH'
        },
        date: 'Jun 28th, 2024',
        amount: '-£2.875,98',
        account: '**** **** 8288'
    },
    {
        id: '5',
        name: {
            value: 'Dianne Russell',
            bgColor: 'cyan',
            capName: 'DR'
        },
        date: 'Jul 21th, 2024',
        amount: '+$12.423,04',
        account: '**** **** 8234'
    },
    {
        id: '6',
        name: {
            value: 'Amy Elsner',
            bgColor: 'yellow',
            capName: 'AE'
        },
        date: 'Jul 21th, 2024',
        amount: '+€17.876,24',
        account: '**** **** 9284'
    },
    {
        id: '7',
        name: {
            value: 'Arlene McCoy',
            bgColor: 'blue',
            capName: 'AM'
        },
        date: 'Jun 28th, 2024',
        amount: '-$12.423,04',
        account: '**** **** 8234'
    },
    {
        id: '8',
        name: {
            value: 'Amy Elsner',
            bgColor: 'yellow',
            capName: 'AE'
        },
        date: 'Jul 21th, 2024',
        amount: '+€17.876,24',
        account: '**** **** 9284'
    },
    {
        id: '9',
        name: {
            value: 'Arlene McCoy',
            bgColor: 'blue',
            capName: 'AM'
        },
        date: 'Jun 28th, 2024',
        amount: '-$12.423,04',
        account: '**** **** 8234'
    }
]);
</script>

<template>
    <div class="card xl:w-auto w-full xl:flex-1 mb-0! flex-1 px-7! pb-7! pt-6! border rounded-3xl border-surface flex flex-col justify-between overflow-hidden">
        <div class="flex items-center gap-2">
            <div class="flex-1 flex flex-col gap-1">
                <span class="label-medium">Transactions History</span>
                <span class="body-xsmall text-left">Track money coming in and going out from this area.</span>
            </div>
            <Button label="See All" severity="secondary" outlined class="text-surface-950! dark:text-surface-0! px-3! py-1! rounded-lg!" />
        </div>
        <div class="w-full overflow-auto flex-1 mt-5">
            <DataTable
                :rows="7"
                paginator
                paginatorTemplate="PrevPageLink PageLinks NextPageLink  CurrentPageReport RowsPerPageDropdown"
                currentPageReportTemplate="Showing page {currentPage} of {totalPages} pages"
                pt:pcpaginator:root="bg-transparent!"
                :pt="{
                    root: {
                        class: 'h-full flex flex-col justify-between'
                    },
                    thead: {
                        class: 'label-small!'
                    },
                    tableContainer: {
                        class: 'flex-1!'
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
                v-model:selection="selectedTransactions"
                :value="transactions"
                dataKey="id"
                tableStyle="min-width: 40rem"
            >
                <Column selectionMode="multiple" headerStyle="width: 3rem" />
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
                <Column field="date" header="Date">
                    <template #body="{ data }">
                        <div class="body-xsmall text-left">
                            {{ data.date }}
                        </div>
                    </template>
                </Column>
                <Column field="amount" header="Amount">
                    <template #body="{ data }">
                        <div class="body-xsmall text-left" :style="{ color: data.amount.startsWith('+') ? 'var(--p-green-500)' : 'var(--p-red-500)' }">
                            {{ data.amount }}
                        </div>
                    </template>
                </Column>
                <Column field="account" header="Account">
                    <template #body="{ data }">
                        <div class="body-xsmall text-left">
                            {{ data.account }}
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
