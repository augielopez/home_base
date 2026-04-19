<script setup>
import { useLayout } from '@/layout/composables/layout';
import { computed, watch } from 'vue';
import { useRoute } from 'vue-router';
import AppBreadcrumb from './AppBreadcrumb.vue';
import AppConfig from './AppConfig.vue';
import AppFooter from './AppFooter.vue';
import AppMenu from './AppMenu.vue';
import AppRightMenu from './AppRightMenu.vue';
import AppSearch from './AppSearch.vue';
import AppSidebar from './AppSidebar.vue';
import AppTopbar from './AppTopbar.vue';

const route = useRoute();
const { layoutConfig, layoutState, hideMobileMenu } = useLayout();

watch(
    () => route.path,
    () => {
        layoutState.uiKitDrawerVisible = false;
    }
);

const containerClass = computed(() => {
    return [
        `layout-sidebar-${layoutConfig.menuTheme}`,
        `layout-card-${layoutConfig.cardStyle}`,
        {
            'layout-overlay': layoutConfig.menuMode === 'overlay',
            'layout-static': layoutConfig.menuMode === 'static',
            'layout-slim': layoutConfig.menuMode === 'slim',
            'layout-horizontal': layoutConfig.menuMode === 'horizontal',
            'layout-compact': layoutConfig.menuMode === 'compact',
            'layout-reveal': layoutConfig.menuMode === 'reveal',
            'layout-drawer': layoutConfig.menuMode === 'drawer',
            'layout-overlay-active': layoutState.overlayMenuActive,
            'layout-mobile-active': layoutState.mobileMenuActive,
            'layout-static-inactive': layoutState.staticMenuInactive,
            'layout-sidebar-expanded': layoutState.sidebarExpanded,
            'layout-sidebar-anchored': layoutState.anchored
        }
    ];
});
</script>

<template>
    <div class="layout-wrapper" :class="containerClass">
        <AppSidebar />
        <div class="layout-content-wrapper">
            <div class="layout-content-wrapper-inside">
                <AppTopbar />
                <div class="layout-content">
                    <AppBreadcrumb />
                    <router-view />
                </div>
                <AppFooter />
            </div>
        </div>
        <AppConfig />
        <Drawer
            v-model:visible="layoutState.uiKitDrawerVisible"
            position="right"
            header="UI Kit"
            class="layout-ui-kit-drawer w-[17rem] max-w-[100vw]"
            :pt="{
                content: { class: 'p-0 flex flex-col flex-1 min-h-0 overflow-hidden' },
                pcCloseButton: { root: 'ml-auto' }
            }"
        >
            <div :class="`layout-sidebar-${layoutConfig.menuTheme} flex flex-col flex-1 min-h-0 h-full`">
                <div class="layout-sidebar !rounded-none !shadow-none !w-full flex-1 min-h-0 flex flex-col">
                    <div class="sidebar-header">
                        <router-link :to="{ name: 'e-commerce' }" class="logo">
                            <img
                                class="logo-image"
                                :src="layoutConfig.menuTheme === 'light' ? '/layout/images/logo-dark.svg' : '/layout/images/logo-white.svg'"
                                alt="diamond-layout"
                            />
                            <span class="app-name title-h7">DIAMOND</span>
                        </router-link>
                        <button class="layout-sidebar-anchor" type="button" @click="layoutState.anchored = !layoutState.anchored" />
                    </div>
                    <div class="layout-menu-container flex-1 min-h-0">
                        <AppMenu />
                    </div>
                </div>
            </div>
        </Drawer>
        <AppSearch />
        <AppRightMenu />
        <Toast />
        <Transition name="p-overlay-mask">
            <div v-if="layoutState.mobileMenuActive" class="layout-mask" @click="hideMobileMenu" />
        </Transition>
    </div>
</template>
