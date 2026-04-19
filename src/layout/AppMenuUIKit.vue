<script setup>
import { ref } from 'vue';
import AppMenuItem from './AppMenuItem.vue';

const model = ref([
    // Add your UI Kit menu items here
]);
</script>

<template>
    <ul v-if="model" class="layout-menu">
        <template v-for="(item, i) of model" :key="item">
            <AppMenuItem v-if="!item.separator" :item="item" :index="i" root />
            <li v-if="item.separator" class="menu-separator" />
        </template>
    </ul>
</template>
