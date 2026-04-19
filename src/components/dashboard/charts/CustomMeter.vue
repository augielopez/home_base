<script setup>
import { computed } from 'vue';

const props = defineProps({
    class: {
        type: String,
        default: ''
    },
    value: {
        type: Array,
        default: () => []
    },
    title: {
        type: String,
        default: ''
    }
});

const processedData = computed(() => {
    if (props.value && props.value.length > 0) {
        const total = props.value.reduce((acc, item) => acc + item.value, 0);
        return props.value.map((item) => ({
            ...item,
            value: (item.value / total) * 100
        }));
    }
    return null;
});
</script>

<template>
    <div>
        <div v-if="title" class="mb-2 body-xsmall text-left">{{ title }}</div>
        <MeterGroup
            :value="processedData"
            labelPosition="end"
            :pt="{
                meters: {
                    class: 'bg-transparent!'
                }
            }"
        >
            <template #label="{ value }">
                <div class="flex flex-nowrap">
                    <template v-for="val of value" :key="val.label">
                        <div :style="{ width: val.value + '%' }" class="flex flex-col gap-1 min-w-[25%]! w-fit">
                            <span class="body-xsmall text-left">{{ val.label }}</span>
                            <span class="label-small text-left text-surface-950 dark:text-surface-0">{{ val.title }}</span>
                        </div>
                    </template>
                </div>
            </template>
            <template #meter="slotProps">
                <span :class="[slotProps.class, slotProps.value.colorClass]" class="rounded-full! min-w-[25%]! w-fit" :style="{ background: slotProps.value.colorClass ? '' : slotProps.value.color, width: slotProps.size }" />
            </template>
        </MeterGroup>
    </div>
</template>
