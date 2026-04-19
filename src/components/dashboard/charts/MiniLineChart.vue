<script setup>
import { useLayout } from '@/layout/composables/layout';

import { ref, watch } from 'vue';

const props = defineProps({
    class: {
        type: String,
        default: ''
    },
    data: {
        type: Array,
        required: true
    },
    bgColor: {
        type: Array,
        default: null
    },
    borderColor: {
        type: String,
        default: null
    },
    tooltipPrefix: {
        type: String,
        default: ''
    }
});

const plugins = ref([]);
const chartData = ref({});
const chartOptions = ref({});
const { isDarkTheme } = useLayout();

watch(
    () => isDarkTheme.value,
    () => {
        chartData.value = setChartData();
        chartOptions.value = setChartOptions(props.tooltipPrefix);
        plugins.value = setLineChartPlugins();
    },
    { immediate: true }
);

function setLineChartPlugins() {
    const darkMode = isDarkTheme.value ?? false;
    const hoverLine = {
        id: 'hoverLine',
        afterDatasetsDraw: (chart) => {
            const {
                ctx,
                tooltip,
                chartArea: { bottom },
                scales: { x, y }
            } = chart;
            if (tooltip && tooltip._active.length > 0) {
                const xCoor = x.getPixelForValue(tooltip.dataPoints[0].dataIndex);
                const yCoor = y.getPixelForValue(tooltip.dataPoints[0].parsed.y);
                ctx.save();
                ctx.beginPath();
                ctx.lineWidth = 1.2;

                const gradient = ctx.createLinearGradient(0, yCoor, 0, bottom);
                if (props.borderColor) {
                    gradient.addColorStop(0, props.borderColor);
                    let endColor = props.borderColor.replace('rgb', 'rgba').replace(')', ', 0)');
                    gradient.addColorStop(0.9, endColor);
                } else {
                    const rootStyles = getComputedStyle(document.documentElement);
                    const surface0Color = rootStyles.getPropertyValue('--p-surface-0');
                    const surface950Color = rootStyles.getPropertyValue('--p-surface-950');
                    const hexToRgba = (hex, alpha) => {
                        let r = parseInt(hex.slice(1, 3), 16);
                        let g = parseInt(hex.slice(3, 5), 16);
                        let b = parseInt(hex.slice(5, 7), 16);
                        return `rgba(${r}, ${g}, ${b}, ${alpha})`;
                    };
                    const startColor = darkMode ? surface0Color : surface950Color;
                    const endColor = darkMode ? hexToRgba(surface0Color, 0) : hexToRgba(surface950Color, 0);
                    gradient.addColorStop(0, startColor);
                    gradient.addColorStop(1, endColor);
                }
                ctx.strokeStyle = gradient;
                ctx.setLineDash([4, 2]);
                ctx.moveTo(xCoor, yCoor + 4);
                ctx.lineTo(xCoor, bottom);
                ctx.stroke();
                ctx.closePath();
                ctx.restore();
            }
        }
    };
    return [hoverLine];
}

function setChartData() {
    const darkMode = isDarkTheme.value ?? false;

    return {
        labels: Array(props.data.length)
            .fill(null)
            .map((_, i) => i),
        datasets: [
            {
                label: 'Dataset',
                data: props.data,
                fill: true,
                borderColor: props.borderColor ?? (darkMode ? '#FAFAFA' : '#030616'),
                tension: 0.2,
                borderWidth: 1.2,
                pointBorderColor: 'rgba(0, 0, 0, 0)',
                pointBackgroundColor: 'rgba(0, 0, 0, 0)',
                pointHoverBackgroundColor: props.borderColor ?? (darkMode ? 'var(--p-surface-0)' : '#030616'),
                pointHoverBorderColor: darkMode ? '#030616' : '#FFF',
                pointBorderWidth: 0,
                hideInLegendAndTooltip: false,
                pointStyle: 'circle',
                pointRadius: 4,
                backgroundColor: (context) => {
                    const defaultColor = [darkMode ? 'rgba(255, 255, 255, 0.24)' : 'rgba(3, 6, 22, 0.24)', darkMode ? 'rgba(255, 255, 255, 0)' : 'rgba(3, 6, 22, 0)'];
                    const bg = props.bgColor ?? defaultColor;

                    if (!context.chart.chartArea) {
                        return;
                    }

                    const {
                        ctx,
                        chartArea: { top, bottom }
                    } = context.chart;
                    const gradientBg = ctx.createLinearGradient(0, top, 0, bottom);
                    const colorTranches = 1 / (bg.length - 1);

                    bg.forEach((color, index) => {
                        gradientBg.addColorStop(index * colorTranches, color);
                    });

                    return gradientBg;
                }
            }
        ]
    };
}

function setChartOptions(tooltipPrefix) {
    return {
        interaction: {
            intersect: false,
            mode: 'index'
        },
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            tooltip: {
                enabled: false,
                position: 'nearest',
                external: function (context) {
                    const { chart, tooltip } = context;
                    let tooltipEl = chart.canvas.parentNode.querySelector('div.chartjs-tooltip');
                    if (!tooltipEl) {
                        tooltipEl = document.createElement('div');
                        tooltipEl.classList.add(
                            'chartjs-tooltip',
                            'label-small',
                            'px-2',
                            'py-1',
                            'dark:bg-surface-950',
                            'bg-surface-0',
                            'rounded-[8px]',
                            'opacity-100',
                            'flex',
                            'items-center',
                            'justify-center',
                            'border',
                            'border-surface',
                            'pointer-events-none',
                            'absolute',
                            '-translate-x-1/2',
                            'transition-all',
                            'duration-[0.05s]',
                            'shadow-[0px_1px_2px_0px_rgba(18,18,23,0.05)]'
                        );
                        chart.canvas.parentNode.appendChild(tooltipEl);
                    }

                    if (tooltip.opacity === 0) {
                        tooltipEl.style.opacity = 0;
                        return;
                    }

                    if (tooltip.body) {
                        const bodyLines = tooltip.body.map((b) => {
                            const strArr = b.lines[0].split(':');
                            return {
                                text: strArr[0].trim(),
                                value: strArr[1].trim()
                            };
                        });

                        tooltipEl.innerHTML = '';
                        bodyLines.forEach((body) => {
                            const text = document.createElement('div');
                            text.appendChild(document.createTextNode(tooltipPrefix + body.value));
                            text.classList.add('label-small', 'text-surface-950', 'dark:text-surface-0', 'font-medium');
                            text.style.fontSize = '14px';
                            tooltipEl.appendChild(text);
                        });
                    }

                    const { offsetLeft: positionX, offsetTop: positionY } = chart.canvas;

                    tooltipEl.style.opacity = 1;
                    tooltipEl.style.left = positionX + tooltip.caretX + 'px';
                    tooltipEl.style.top = positionY + tooltip.caretY - 45 + 'px';
                }
            },
            legend: {
                display: false
            },
            title: {
                display: false
            }
        },
        scales: {
            x: {
                display: false,
                stacked: true
            },
            y: {
                display: false,
                min: 0
            }
        }
    };
}
</script>

<template>
    <Chart type="line" :data="chartData" :plugins="plugins" :options="chartOptions" class="h-full w-full px-1 cursor-pointer" :class="class" />
</template>
