<script setup>
import { ref, onMounted } from 'vue';
import AppMenuItem from './AppMenuItem.vue';
import { loadPermissions, getModules } from '@/lib/composables/usePermissions';

const model = ref([]);

onMounted(async () => {
  try {
    await loadPermissions();
    const modules = getModules();
    const moduleItems = modules.map((code) => {
      const label = code.replace(/_/g, ' ').replace(/\b\w/g, (c) => c.toUpperCase());
      const to = '/' + code.toLowerCase().replace(/_/g, '-');
      return { label, icon: 'pi pi-fw pi-folder', to };
    });

    model.value = [
      {
        label: 'Modules',
        icon: 'pi pi-fw pi-th-large',
        items: moduleItems
      },
      { separator: true }
    ];
  } catch (err) {
    console.error('Failed to load modules for UI kit menu', err);
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
