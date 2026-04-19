<script setup>
import { useLayout } from '@/layout/composables/layout';
import { sampleDataByFixedLength } from '@/lib/utils';
import { ref, watch } from 'vue';

const props = defineProps({
    class: {
        type: String,
        default: ''
    },
    show: {
        type: Number,
        default: 6
    },
    meterOptionsProps: {
        type: Object,
        default: () => ({
            max: null,
            bgColors: null,
            labels: null,
            showX: false,
            showY: false,
            yAxis: null,
            data: null,
            xAxisPosition: 'bottom',
            timeUnit: 'week',
            showTooltip: true
        })
    },
    currency: {
        type: String,
        default: '$'
    }
});

const data = ref(null);
const meterOptions = ref(null);
const tooltipPosition = ref({
    x: 0,
    y: 0
});
const tooltipIndex = ref(0);
const showTooltip = ref(false);
const container = ref(null);
const { isDarkTheme } = useLayout();

function handleMouseOver(event, index) {
    if (container.value) {
        const containerRect = container.value.getBoundingClientRect();
        const rect = event.currentTarget.getBoundingClientRect();
        const offsetX = rect.left - containerRect.left + rect.width / 2;
        const offsetY = rect.height + 25;

        tooltipPosition.value = { x: offsetX, y: offsetY };
        showTooltip.value = true;
        tooltipIndex.value = index;
    }
}

function handleMouseLeave() {
    showTooltip.value = false;
}

function setMeterOptions(option, _data) {
    const darkMode = isDarkTheme.value ?? false;
    const rootStyles = getComputedStyle(document.documentElement);
    const surface0Color = rootStyles.getPropertyValue('--p-surface-0');
    const surface950Color = rootStyles.getPropertyValue('--p-surface-950');

    const data = _data;
    let totalsByYAxis = null;
    const max = () => {
        let maxy;
        if (typeof data[0].y == 'number') {
            maxy = data.reduce((max, obj) => (obj.y > max ? obj.y : max), data[0].y);
        } else {
            let max = -Infinity;
            totalsByYAxis = [];
            for (let i = 0; i < data.length; i++) {
                const sum = data[i].y.reduce((acc, val) => acc + parseFloat(val), 0);
                totalsByYAxis.push(sum);
                if (sum > max) {
                    max = sum;
                }
            }
            maxy = max;
        }
        return maxy;
    };
    const createLabes = () => {
        const labels = data.map((element) => {
            let val;
            const date = new Date(element.x);
            const days = ['Mn', 'Tu', 'Wd', 'Th', 'Fr', 'St', 'Su'];
            val = days[date.getDay()];
            return val;
        });
        return labels;
    };

    const maxVal = max();
    const defaultBgColors = [darkMode ? surface0Color : surface950Color];

    return {
        max: props.meterOptionsProps.max ?? maxVal * 1.25,
        bgColors: props.meterOptionsProps.bgColors ?? defaultBgColors,
        labels: props.meterOptionsProps.showX && (props.meterOptionsProps.labels ?? createLabes()),
        showX: props.meterOptionsProps.showX,
        showY: props.meterOptionsProps.showY,
        yAxis:
            props.meterOptionsProps.showY &&
            (props.meterOptionsProps.yAxis ??
                Array(4)
                    .fill(null)
                    .map((_, i) => Math.ceil(maxVal * (1 - i / 3)))),
        data: data,
        xAxisPosition: props.meterOptionsProps.xAxisPosition,
        totalsByYAxis: totalsByYAxis,
        timeUnit: option,
        showTooltip: Array.isArray(data[0].y) ? false : props.meterOptionsProps.showTooltip
    };
}
const emit = defineEmits(['computed-data']);
watch(
    [() => props.meterOptionsProps.timeUnit, () => isDarkTheme.value],
    ([newTimeUnit]) => {
        const sampledData = sampleDataByFixedLength(props.meterOptionsProps.data, newTimeUnit, props.show);
        data.value = sampledData;
        meterOptions.value = setMeterOptions(newTimeUnit, data.value);

        emit('computed-data', data.value);
    },
    { immediate: true }
);
</script>
<template>
    <div :class="class" class="flex gap-5 flex-1">
        <div v-if="meterOptions?.showY" class="flex flex-col justify-between" :class="meterOptions.showX ? (meterOptionsProps.xAxisPosition === 'top' ? 'pt-8' : 'pb-8') : 'p-0'">
            <template v-for="(val, index) of meterOptions?.yAxis" :key="index">
                <div class="body-xsmall leading-none text-right">
                    {{ index === meterOptions?.yAxis.length - 1 ? 0 : (val / 1000).toFixed(1) + 'K' }}
                </div>
            </template>
        </div>
        <div class="flex-1 flex flex-col">
            <div ref="container" class="flex-1 relative flex justify-between w-full h-full">
                <div
                    v-if="showTooltip && !Array.isArray(data[0].y)"
                    class="px-2 py-1 rounded-lg label-small leading-snug text-surface-950 dark:text-surface-0 absolute z-50 bg-surface-0 dark:bg-surface-950 border border-surface transition-all duration-75 -translate-x-1/2 shadow-[0px_2px_6px_0px_rgba(0,0,0,0.08),0px_1px_2px_0px_rgba(18,18,23,0.05)]"
                    :class="showTooltip ? 'opacity-100' : 'opacity-0'"
                    :style="{ bottom: tooltipPosition.y + 'px', left: tooltipPosition.x + 'px' }"
                >
                    {{ currency + data?.[tooltipIndex ?? 0]?.y?.toFixed(2) }}
                </div>
                <template v-for="(data, index) of meterOptions?.data" :key="index">
                    <div class="h-full flex items-center gap-3.5 transition-all" :class="meterOptionsProps?.xAxisPosition === 'top' ? 'flex-col-reverse' : 'flex-col'">
                        <div class="flex-1 h-full flex flex-col items-center gap-2 transition-all">
                            <div class="w-[1px] h-1.5 bg-surface-950 dark:bg-surface-0 rounded-full" />
                            <div class="relative w-3 flex-1 flex flex-col justify-end cursor-pointer">
                                <div class="bg-surface-200 dark:bg-surface-800 rounded-full w-[0.5px] h-full absolute top-0 left-1/2 -translate-x-1/2" />
                                <div
                                    v-if="Array.isArray(data.y)"
                                    @mouseover="handleMouseOver($event, index)"
                                    @mouseleave="handleMouseLeave"
                                    class="flex flex-col-reverse relative z-10 w-full rounded-full transition-all duration-300 overflow-hidden"
                                    :style="{ height: (parseFloat(meterOptions.totalsByYAxis[index]) / meterOptions?.max) * 100 + '%' }"
                                >
                                    <div
                                        v-for="(val, j) of data.y"
                                        :key="'inner-meter' + j"
                                        class="w-full min-h-4"
                                        :style="{ background: meterOptions.bgColors[j] ?? meterOptions.bgColors[0], height: (parseFloat(val) / meterOptions.totalsByYAxis[index]) * 100 + '%' }"
                                    />
                                </div>
                                <div
                                    v-else
                                    @mouseover="handleMouseOver($event, index)"
                                    @mouseleave="handleMouseLeave"
                                    class="relative z-10 w-full rounded-full cursor-pointer transition-all duration-300 min-h-4"
                                    :style="{ background: meterOptions.bgColors[0], height: (parseFloat(data.y) / meterOptions?.max) * 100 + '%' }"
                                />
                            </div>
                            <div class="w-[1px] h-1.5 bg-surface-950 dark:bg-surface-0 rounded-full" />
                        </div>
                        <span class="body-xsmall">
                            {{ meterOptions?.labels?.[index] }}
                        </span>
                    </div>
                </template>
            </div>
        </div>
    </div>
</template>
