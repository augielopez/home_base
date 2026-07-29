<script setup>
import { ref, onMounted } from 'vue';
import AppMenuItem from './AppMenuItem.vue';
import { moduleNavRegistry } from '@/app/router';
import { loadPermissions, getModules } from '@/lib/composables/usePermissions';

const model = ref([]);
const temporaryModules = ['BALANCE_BASE'];

function moduleCodeToMenuItem(code) {
    const nav = moduleNavRegistry[code];
    if (!nav) {
        const label = code.replace(/_/g, ' ').replace(/\b\w/g, (c) => c.toUpperCase());
        const to = '/' + code.toLowerCase().replace(/_/g, '-');
        return { label, icon: 'pi pi-fw pi-folder', to };
    }

    return {
        label: nav.label,
        icon: nav.icon || 'pi pi-fw pi-folder',
        path: nav.path,
        items: nav.children.map((child) => ({
            label: child.label,
            icon: child.icon || 'pi pi-fw pi-circle',
            to: child.path
        }))
    };
}

function setMenu(modules) {
    const moduleItems = [...new Set([...temporaryModules, ...modules])].map(moduleCodeToMenuItem);

    model.value = [
        {
            label: 'Modules',
            icon: 'pi pi-fw pi-th-large',
            items: moduleItems
        },
        { separator: true }
    ];
}

onMounted(async () => {
    try {
        await loadPermissions();
        setMenu(getModules());
    } catch (err) {
        console.error('Failed to load modules for UI kit menu', err);
        setMenu([]);
    }
});
</script>

<template>
    <ul v-if="model" class="layout-menu">
        <template v-for="(item, i) of model" :key="item">
            <AppMenuItem v-if="!item.separator" :item="item" :index="i" root />
            <li v-if="item.separator" class="menu-separator" />
        </template>
    </ul>
</template>
