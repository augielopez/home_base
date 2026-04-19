<script setup>
import LogoWidget from '@/components/landing/LogoWidget.vue';
import { ref } from 'vue';

const products = ref([
    {
        description: 'Green T-Shirt',
        quantity: '1',
        price: '$49',
        total: '$49'
    },
    {
        description: 'Game Controller',
        quantity: '1',
        price: '$56',
        total: '$56'
    },
    {
        description: 'Mini Speakers',
        quantity: '1',
        price: '$72',
        total: '$72'
    }
]);
</script>
<template>
    <div class="card p-5 overflow-auto shadow-[0px_1px_2px_0px_rgba(18,18,23,0.05)]">
        <div class="flex items-start pt-6 px-6 pb-9 gap-6 flex-wrap-reverse">
            <div class="flex-1">
                <LogoWidget />
                <div class="mt-3 body-xsmall text-left">9137 3rd Lane California CityCA 93504, U.S.A.</div>
            </div>
            <div class="flex flex-col text-right">
                <h1 class="title-h6">Invoice</h1>
                <span class="mt-1.5 body-medium">#09022023</span>
            </div>
        </div>
        <Divider />
        <div class="px-6 pb-9 pt-6 flex items-start gap-6 flex-wrap sm:flex-row flex-col">
            <div class="flex-1">
                <div class="label-medium text-surface-500">Bill To:</div>
                <div class="mt-2 label-medium">AlphaHex</div>
                <div class="body-small text-left mt-0.5">
                    Claire Williams, 148 Hope LanePalo <br />
                    Alto, CA 94304.
                </div>
            </div>
            <div class="flex flex-col gap-3 min-w-64">
                <div class="flex items-center justify-between gap-6">
                    <span class="body-small">Client Name</span>
                    <span class="label-small text-surface-950 dark:text-surface-0">Amy Elsner</span>
                </div>
                <div class="flex items-center justify-between gap-6">
                    <span class="body-small">Date</span>
                    <span class="label-small text-surface-950 dark:text-surface-0">04/19/2023</span>
                </div>
                <div class="flex items-center justify-between gap-6">
                    <span class="body-small">Customer</span>
                    <span class="label-small text-surface-950 dark:text-surface-0">A123</span>
                </div>
            </div>
        </div>
        <Divider />
        <div>
            <DataTable :value="products" tableStyle="min-width: 50rem">
                <Column field="description" header="Description" />
                <Column field="quantity" header="Quantity" />
                <Column field="price" header="Unit Price" />
                <Column field="total" header="Line Total" />
            </DataTable>
            <div class="py-6 px-4 flex items-start gap-6 flex-wrap sm:flex-row flex-col">
                <div class="flex-1 body-small text-left text-surface-950 dark:text-surface-0">Notes</div>
                <div class="flex flex-col gap-3 min-w-52">
                    <div class="flex items-center justify-between">
                        <span class="label-small text-surface-950 dark:text-surface-0">Subtotal</span>
                        <span>$216.00</span>
                    </div>
                    <div class="flex items-center justify-between">
                        <span class="label-small text-surface-950 dark:text-surface-0">Vat</span>
                        <span>0</span>
                    </div>
                    <div class="flex items-center justify-between">
                        <span class="label-small text-surface-950 dark:text-surface-0">Total</span>
                        <span>$216.00</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
