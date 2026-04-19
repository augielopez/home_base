<script setup>
defineProps({
    testimonial: {
        type: null,
        required: true
    },
    className: {
        type: String,
        default: ''
    }
});
</script>

<template>
    <div class="p-5 lg:p-6 border border-surface-200 dark:border-surface-800 rounded-2xl" :class="className">
        <p class="body-medium text-left">
            {{ testimonial.message }}
        </p>
        <div class="flex items-center gap-3 mt-6">
            <Avatar class="w-14! h-14! border border-surface-200 dark:border-surface-700" size="large" :image="testimonial.avatar" shape="circle" />
            <div class="flex-1">
                <div class="text-xl font-semibold text-surface-950 dark:text-surface-0">{{ testimonial.name }}</div>
                <span class="text-lg text-surface-500 mt-2">{{ testimonial.title }}</span>
            </div>
        </div>
    </div>
</template>
