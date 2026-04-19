<script setup>
import { ref } from 'vue';
import AppMenuItem from './AppMenuItem.vue';

const model = ref([
    {
        label: 'Dashboards',
        icon: 'pi pi-home',
        path: '/dashboard',
        items: [
            {
                label: 'E-Commerce',
                icon: 'pi pi-fw pi-warehouse',
                to: '/dashboard/e-commerce'
            },
            {
                label: 'Banking',
                icon: 'pi pi-fw pi-building-columns',
                to: '/dashboard/banking'
            },
            {
                label: 'Marketing',
                icon: 'pi pi-fw pi-gauge',
                to: '/dashboard/marketing'
            }
        ]
    },
    { separator: true },
    {
        label: 'Apps',
        icon: 'pi pi-th-large',
        path: '/apps',
        items: [
            {
                label: 'CMS',
                icon: 'pi pi-fw pi-comment',
                path: '/cms',
                items: [
                    {
                        label: 'Detail',
                        icon: 'pi pi-fw pi-list',
                        to: '/apps/cms/detail'
                    },
                    {
                        label: 'Detail-2',
                        icon: 'pi pi-fw pi-list',
                        to: '/apps/cms/detail2'
                    },
                    {
                        label: 'List',
                        icon: 'pi pi-fw pi-image',
                        to: '/apps/cms/list'
                    },
                    {
                        label: 'Edit',
                        icon: 'pi pi-fw pi-pencil',
                        to: '/apps/cms/edit'
                    }
                ]
            },
            {
                label: 'Chat',
                icon: 'pi pi-fw pi-comments',
                to: '/apps/chat'
            },
            {
                label: 'Files',
                icon: 'pi pi-fw pi-folder',
                to: '/apps/files'
            },
            {
                label: 'Mail',
                icon: 'pi pi-fw pi-envelope',
                to: '/apps/mail/inbox'
            },
            {
                label: 'Task List',
                icon: 'pi pi-fw pi-check-square',
                to: '/apps/tasklist'
            },
            {
                label: 'Productivity Base',
                icon: 'pi pi-fw pi-list',
                to: '/productivity-base'
            }
        ]
    },
    { separator: true },
    {
        label: 'UI Kit',
        icon: 'pi pi-fw pi-star-fill',
        path: '/uikit',
        items: [
            {
                label: 'Form Layout',
                icon: 'pi pi-fw pi-id-card',
                to: '/uikit/formlayout'
            },
            {
                label: 'Input',
                icon: 'pi pi-fw pi-check-square',
                to: '/uikit/input'
            },
            {
                label: 'Button',
                icon: 'pi pi-fw pi-box',
                to: '/uikit/button'
            },
            {
                label: 'Table',
                icon: 'pi pi-fw pi-table',
                to: '/uikit/table'
            },
            {
                label: 'List',
                icon: 'pi pi-fw pi-list',
                to: '/uikit/list'
            },
            {
                label: 'Tree',
                icon: 'pi pi-fw pi-share-alt',
                to: '/uikit/tree'
            },
            {
                label: 'Panel',
                icon: 'pi pi-fw pi-tablet',
                to: '/uikit/panel'
            },
            {
                label: 'Overlay',
                icon: 'pi pi-fw pi-clone',
                to: '/uikit/overlay'
            },
            {
                label: 'Media',
                icon: 'pi pi-fw pi-image',
                to: '/uikit/media'
            },
            {
                label: 'Menu',
                icon: 'pi pi-fw pi-bars',
                to: '/uikit/menu'
            },
            {
                label: 'Message',
                icon: 'pi pi-fw pi-comment',
                to: '/uikit/message'
            },
            {
                label: 'File',
                icon: 'pi pi-fw pi-file',
                to: '/uikit/file'
            },
            {
                label: 'Chart',
                icon: 'pi pi-fw pi-chart-bar',
                to: '/uikit/charts'
            },
            {
                label: 'Timeline',
                icon: 'pi pi-fw pi-calendar',
                to: '/uikit/timeline'
            },
            {
                label: 'Misc',
                icon: 'pi pi-fw pi-circle-off',
                to: '/uikit/misc'
            }
        ]
    },
    { separator: true },
    {
        label: 'Prime Blocks',
        icon: 'pi pi-fw pi-prime',
        path: '/blocks',
        items: [
            {
                label: 'Free Blocks',
                icon: 'pi pi-fw pi-eye',
                to: '/blocks/free'
            },
            {
                label: 'All Blocks',
                icon: 'pi pi-fw pi-globe',
                url: 'https://primeblocks.org',
                target: '_blank'
            }
        ]
    },
    { separator: true },
    {
        label: 'Utilities',
        icon: 'pi pi-fw pi-compass',
        path: '/utilities',
        items: [
            {
                label: 'Figma',
                icon: 'pi pi-fw pi-pencil',
                url: 'https://www.figma.com/design/3BgdXCQjva5nUEO8OidU1B/Preview-%7C-Diamond?node-id=0-1&t=KdfljgRtYLzFPfKL-1',
                target: '_blank'
            }
        ]
    },
    { separator: true },
    {
        label: 'Pages',
        icon: 'pi pi-fw pi-briefcase',
        path: '/pages',
        items: [
            {
                label: 'Landing',
                icon: 'pi pi-fw pi-globe',
                to: '/landing'
            },
            {
                label: 'Auth',
                icon: 'pi pi-fw pi-user',
                path: '/auth',
                items: [
                    {
                        label: 'Login',
                        icon: 'pi pi-fw pi-sign-in',
                        to: '/auth/login'
                    },
                    {
                        label: 'Error',
                        icon: 'pi pi-fw pi-times-circle',
                        to: '/auth/error'
                    },
                    {
                        label: 'Access Denied',
                        icon: 'pi pi-fw pi-lock',
                        to: '/auth/access'
                    },
                    {
                        label: 'Register',
                        icon: 'pi pi-fw pi-user-plus',
                        to: '/auth/register'
                    },
                    {
                        label: 'Forgot Password',
                        icon: 'pi pi-fw pi-question',
                        to: '/auth/forgot-password'
                    },
                    {
                        label: 'New Password',
                        icon: 'pi pi-fw pi-cog',
                        to: '/auth/new-password'
                    },
                    {
                        label: 'Verification',
                        icon: 'pi pi-fw pi-envelope',
                        to: '/auth/register/verification'
                    },
                    {
                        label: 'Lock Screen',
                        icon: 'pi pi-fw pi-eye-slash',
                        to: '/auth/lock-screen'
                    }
                ]
            },
            {
                label: 'Crud',
                icon: 'pi pi-fw pi-pencil',
                to: '/pages/crud'
            },
            {
                label: 'Invoice',
                icon: 'pi pi-fw pi-dollar',
                to: '/pages/invoice'
            },
            {
                label: 'About Us',
                icon: 'pi pi-fw pi-user',
                to: '/pages/aboutus'
            },
            {
                label: 'Help',
                icon: 'pi pi-fw pi-question-circle',
                to: '/pages/help'
            },
            {
                label: 'Oops',
                icon: 'pi pi-fw pi-exclamation-circle',
                to: '/auth/oops'
            },
            {
                label: 'Not Found',
                icon: 'pi pi-fw pi-exclamation-circle',
                to: '/pages/notfound'
            },
            {
                label: 'Empty',
                icon: 'pi pi-fw pi-circle-off',
                to: '/pages/empty'
            },
            {
                label: 'FAQ',
                icon: 'pi pi-fw pi-question',
                to: '/pages/faq'
            }
        ]
    },
    { separator: true },
    {
        label: 'E-Commerce',
        icon: 'pi pi-fw pi-wallet',
        path: '/ecommerce',
        items: [
            {
                label: 'Product Overview',
                icon: 'pi pi-fw pi-image',
                to: '/ecommerce/product-overview'
            },
            {
                label: 'Product List',
                icon: 'pi pi-fw pi-list',
                to: '/ecommerce/product-list'
            },
            {
                label: 'New Product',
                icon: 'pi pi-fw pi-plus',
                to: '/ecommerce/new-product'
            },
            {
                label: 'Shopping Cart',
                icon: 'pi pi-fw pi-shopping-cart',
                to: '/ecommerce/shopping-cart'
            },
            {
                label: 'Checkout Form',
                icon: 'pi pi-fw pi-check-square',
                to: '/ecommerce/checkout-form'
            },
            {
                label: 'Order History',
                icon: 'pi pi-fw pi-history',
                to: '/ecommerce/order-history'
            },
            {
                label: 'Order Summary',
                icon: 'pi pi-fw pi-file',
                to: '/ecommerce/order-summary'
            }
        ]
    },
    { separator: true },
    {
        label: 'User Management',
        icon: 'pi pi-fw pi-user',
        path: '/profile',
        items: [
            {
                label: 'List',
                icon: 'pi pi-fw pi-list',
                to: '/profile/list'
            },
            {
                label: 'Create',
                icon: 'pi pi-fw pi-plus',
                to: '/profile/create'
            }
        ]
    },
    { separator: true },
    {
        label: 'Hierarchy',
        icon: 'pi pi-fw pi-align-left',
        path: '/hierarchy',
        items: [
            {
                label: 'Submenu 1',
                icon: 'pi pi-fw pi-align-left',
                path: '/submenu_1',
                items: [
                    {
                        label: 'Submenu 1.1',
                        icon: 'pi pi-fw pi-align-left',
                        path: '/submenu_1_1',
                        items: [
                            {
                                label: 'Submenu 1.1.1',
                                icon: 'pi pi-fw pi-align-left'
                            },
                            {
                                label: 'Submenu 1.1.2',
                                icon: 'pi pi-fw pi-align-left'
                            },
                            {
                                label: 'Submenu 1.1.3',
                                icon: 'pi pi-fw pi-align-left'
                            }
                        ]
                    },
                    {
                        label: 'Submenu 1.2',
                        icon: 'pi pi-fw pi-align-left',
                        path: '/submenu_1_2',
                        items: [
                            {
                                label: 'Submenu 1.2.1',
                                icon: 'pi pi-fw pi-align-left'
                            }
                        ]
                    }
                ]
            },
            {
                label: 'Submenu 2',
                icon: 'pi pi-fw pi-align-left',
                path: '/submenu_2',
                items: [
                    {
                        label: 'Submenu 2.1',
                        icon: 'pi pi-fw pi-align-left',
                        path: '/submenu_2_1',
                        items: [
                            {
                                label: 'Submenu 2.1.1',
                                icon: 'pi pi-fw pi-align-left'
                            },
                            {
                                label: 'Submenu 2.1.2',
                                icon: 'pi pi-fw pi-align-left'
                            }
                        ]
                    },
                    {
                        label: 'Submenu 2.2',
                        icon: 'pi pi-fw pi-align-left',
                        path: '/submenu_2_2',
                        items: [
                            {
                                label: 'Submenu 2.2.1',
                                icon: 'pi pi-fw pi-align-left'
                            }
                        ]
                    }
                ]
            }
        ]
    },
    { separator: true },
    {
        label: 'Start',
        icon: 'pi pi-fw pi-download',
        path: '/start',
        items: [
            {
                label: 'Buy Now',
                icon: 'pi pi-fw pi-shopping-cart',
                url: 'https://www.primefaces.org/store'
            },
            {
                label: 'Documentation',
                icon: 'pi pi-fw pi-info-circle',
                to: '/start/documentation'
            }
        ]
    }
]);
</script>

<template>
    <ul class="layout-menu">
        <template v-for="(item, index) in model" :key="item.label + '_' + (item.to || item.path || index)">
            <AppMenuItem v-if="!item.separator" :item="item" :index="index" root />

            <li v-else class="menu-separator" />
        </template>
    </ul>
</template>
