<script setup lang="ts">
import { computed, reactive, watch } from 'vue';
import type { Bill, BillFrequency, BillInput } from '../types/balanceBase.types';
import { BILL_STATUS_OPTIONS } from '../types/balanceBase.types';

const props = defineProps<{
    visible: boolean;
    bill: Bill | null;
    frequencies: BillFrequency[];
    saving?: boolean;
}>();

const emit = defineEmits<{
    'update:visible': [value: boolean];
    save: [payload: BillInput];
}>();

const form = reactive<BillInput>({
    bill_name: '',
    amount_due: null,
    due_date: null,
    status: 'Active',
    description: null,
    frequency_id: null,
    last_paid: null,
    is_fixed_bill: false,
    is_included_in_monthly_payment: true
});

const isEdit = computed(() => Boolean(props.bill?.id));
const header = computed(() => (isEdit.value ? 'Edit Bill' : 'Add Bill'));

watch(
    () => [props.visible, props.bill] as const,
    ([visible, bill]) => {
        if (!visible) return;
        form.bill_name = bill?.bill_name || '';
        form.amount_due = bill?.amount_due ?? null;
        form.due_date = bill?.due_date || null;
        form.status = bill?.status || 'Active';
        form.description = bill?.description || null;
        form.frequency_id = bill?.frequency_id || null;
        form.last_paid = bill?.last_paid || null;
        form.is_fixed_bill = Boolean(bill?.is_fixed_bill);
        form.is_included_in_monthly_payment = bill?.is_included_in_monthly_payment !== false;
    },
    { immediate: true }
);

function close() {
    emit('update:visible', false);
}

function submit() {
    if (!form.bill_name.trim()) return;
    emit('save', {
        bill_name: form.bill_name.trim(),
        amount_due: form.amount_due,
        due_date: form.due_date?.trim() || null,
        status: form.status || 'Active',
        description: form.description?.trim() || null,
        frequency_id: form.frequency_id || null,
        last_paid: form.last_paid || null,
        is_fixed_bill: form.is_fixed_bill,
        is_included_in_monthly_payment: form.is_included_in_monthly_payment
    });
}
</script>

<template>
    <Dialog
        :visible="visible"
        modal
        :header="header"
        class="w-full max-w-xl"
        :style="{ width: 'min(36rem, 95vw)' }"
        @update:visible="emit('update:visible', $event)"
    >
        <div class="flex flex-col gap-4">
            <div>
                <label class="block text-sm font-medium mb-2" for="bill-name">Bill name</label>
                <InputText id="bill-name" v-model="form.bill_name" class="w-full" placeholder="e.g. Verizon Wireless" />
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                    <label class="block text-sm font-medium mb-2" for="bill-amount">Amount due</label>
                    <InputNumber
                        id="bill-amount"
                        v-model="form.amount_due"
                        mode="currency"
                        currency="USD"
                        locale="en-US"
                        class="w-full"
                        input-class="w-full"
                    />
                </div>
                <div>
                    <label class="block text-sm font-medium mb-2" for="bill-due">Due date</label>
                    <InputText id="bill-due" v-model="form.due_date" class="w-full" placeholder="e.g. 29th or 2026-08-01" />
                </div>
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                    <label class="block text-sm font-medium mb-2">Status</label>
                    <Select
                        v-model="form.status"
                        :options="[...BILL_STATUS_OPTIONS]"
                        option-label="label"
                        option-value="value"
                        class="w-full"
                    />
                </div>
                <div>
                    <label class="block text-sm font-medium mb-2">Frequency</label>
                    <Select
                        v-model="form.frequency_id"
                        :options="frequencies"
                        option-label="name"
                        option-value="id"
                        placeholder="Select frequency"
                        show-clear
                        class="w-full"
                    />
                </div>
            </div>

            <div>
                <label class="block text-sm font-medium mb-2" for="bill-description">Description</label>
                <Textarea id="bill-description" v-model="form.description" rows="3" class="w-full" auto-resize />
            </div>

            <div class="flex flex-col gap-3 sm:flex-row sm:items-center sm:gap-6">
                <div class="flex items-center gap-2">
                    <Checkbox v-model="form.is_fixed_bill" binary input-id="bill-fixed" />
                    <label for="bill-fixed" class="text-sm">Fixed amount</label>
                </div>
                <div class="flex items-center gap-2">
                    <Checkbox v-model="form.is_included_in_monthly_payment" binary input-id="bill-monthly" />
                    <label for="bill-monthly" class="text-sm">Include in monthly payments</label>
                </div>
            </div>
        </div>

        <template #footer>
            <div class="flex justify-end gap-2">
                <Button label="Cancel" severity="secondary" text :disabled="saving" @click="close" />
                <Button :label="isEdit ? 'Save' : 'Create'" icon="pi pi-check" :loading="saving" :disabled="!form.bill_name.trim()" @click="submit" />
            </div>
        </template>
    </Dialog>
</template>
