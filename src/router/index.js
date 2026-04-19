import AppLayout from '@/layout/AppLayout.vue';
import AuthLayout from '@/layout/AuthLayout.vue';
import LandingLayout from '@/layout/LandingLayout.vue';
import { createRouter, createWebHistory } from 'vue-router';

const routes = [
    {
        path: '/',
        component: AppLayout,
        children: [
            {
                path: '/dashboard/e-commerce',
                alias: '',
                name: 'e-commerce',
                meta: {
                    breadcrumb: ['E-Commerce Dashboard']
                },
                component: () => import('@/views/dashboard/EcommerceView.vue')
            },
            {
                path: '/dashboard/banking',
                name: 'dashboard-banking',
                meta: {
                    breadcrumb: ['Banking Dashboard']
                },
                component: () => import('@/views/dashboard/BankingView.vue')
            },
            {
                path: '/dashboard/marketing',
                name: 'dashboard-marketing',
                meta: {
                    breadcrumb: ['Marketing Dashboard']
                },
                component: () => import('@/views/dashboard/MarketingView.vue')
            },
            {
                path: '/apps/cms/list',
                meta: {
                    breadcrumb: ['CMS', 'List'],
                    title: 'CMS List'
                },
                component: () => import('@/views/apps/cms/List.vue')
            },
            {
                path: '/apps/cms/detail',
                meta: {
                    breadcrumb: ['CMS', 'Detail'],
                    title: 'CMS Detail'
                },
                component: () => import('@/views/apps/cms/Detail.vue')
            },
            {
                path: '/apps/cms/detail2',
                meta: {
                    breadcrumb: ['CMS', 'Detail-2'],
                    title: 'CMS Detail 2'
                },
                component: () => import('@/views/apps/cms/Detail2.vue')
            },
            {
                path: '/apps/cms/edit',
                name: 'cms-edit',
                meta: {
                    breadcrumb: ['CMS', 'Edit'],
                    title: 'CMS Edit'
                },
                component: () => import('@/views/apps/cms/Edit.vue')
            },
            {
                path: '/apps/files',
                name: 'files',
                component: () => import('@/views/apps/Files.vue')
            },
            {
                path: '/apps/chat',
                name: 'chat',
                component: () => import('@/views/apps/chat/Index.vue')
            },
            {
                path: '/apps/tasklist',
                name: 'tasklist',
                component: () => import('@/views/apps/tasklist/Index.vue')
            },
            {
                path: '/productivity-base',
                name: 'productivity-base',
                meta: {
                    breadcrumb: ['Productivity Base', 'Todos'],
                    title: 'Productivity Base'
                },
                component: () => import('@/modules/productivity-base/views/ProductivityTodosView.vue')
            },
            {
                path: '/apps/mail',
                meta: {
                    breadcrumb: ['Mail', 'Inbox'],
                    title: 'Mail Inbox'
                },
                component: () => import('@/views/apps/mail/Index.vue'),
                children: [
                    {
                        path: '',
                        redirect: '/apps/mail/inbox'
                    },
                    {
                        path: 'inbox',
                        name: 'mail-inbox',
                        component: () => import('@/views/apps/mail/Inbox.vue')
                    },
                    {
                        path: 'detail/:id',
                        name: 'mail-detail',
                        meta: {
                            breadcrumb: ['Mail', 'Detail'],
                            title: 'Mail Detail'
                        },
                        component: () => import('@/views/apps/mail/Detail.vue')
                    }
                ]
            },
            {
                path: '/uikit/formlayout',
                name: 'formlayout',
                meta: {
                    breadcrumb: ['UI Kit', 'Form Layout']
                },
                component: () => import('@/views/uikit/FormLayoutDoc.vue')
            },
            {
                path: '/uikit/input',
                name: 'input',
                meta: {
                    breadcrumb: ['UI Kit', 'Input']
                },
                component: () => import('@/views/uikit/InputDoc.vue')
            },
            {
                path: '/uikit/button',
                name: 'button',
                meta: {
                    breadcrumb: ['UI Kit', 'Button']
                },
                component: () => import('@/views/uikit/ButtonDoc.vue')
            },
            {
                path: '/uikit/table',
                name: 'table',
                meta: {
                    breadcrumb: ['UI Kit', 'Table']
                },
                component: () => import('@/views/uikit/TableDoc.vue')
            },
            {
                path: '/uikit/list',
                name: 'list',
                meta: {
                    breadcrumb: ['UI Kit', 'List']
                },
                component: () => import('@/views/uikit/ListDoc.vue')
            },
            {
                path: '/uikit/tree',
                name: 'tree',
                meta: {
                    breadcrumb: ['UI Kit', 'Tree']
                },
                component: () => import('@/views/uikit/TreeDoc.vue')
            },
            {
                path: '/uikit/panel',
                name: 'panel',
                meta: {
                    breadcrumb: ['UI Kit', 'Panel']
                },
                component: () => import('@/views/uikit/PanelsDoc.vue')
            },

            {
                path: '/uikit/overlay',
                name: 'overlay',
                meta: {
                    breadcrumb: ['UI Kit', 'Overlay']
                },
                component: () => import('@/views/uikit/OverlayDoc.vue')
            },
            {
                path: '/uikit/media',
                name: 'media',
                meta: {
                    breadcrumb: ['UI Kit', 'Media']
                },
                component: () => import('@/views/uikit/MediaDoc.vue')
            },
            {
                path: '/uikit/menu',
                meta: {
                    breadcrumb: ['UI Kit', 'Menu']
                },
                component: () => import('@/views/uikit/MenuDoc.vue')
            },
            {
                path: '/uikit/message',
                name: 'message',
                meta: {
                    breadcrumb: ['UI Kit', 'Message']
                },
                component: () => import('@/views/uikit/MessagesDoc.vue')
            },
            {
                path: '/uikit/file',
                name: 'file',
                meta: {
                    breadcrumb: ['UI Kit', 'File']
                },
                component: () => import('@/views/uikit/FileDoc.vue')
            },
            {
                path: '/uikit/charts',
                name: 'charts',
                meta: {
                    breadcrumb: ['UI Kit', 'Charts']
                },
                component: () => import('@/views/uikit/ChartDoc.vue')
            },
            {
                path: '/uikit/timeline',
                name: 'timeline',
                meta: {
                    breadcrumb: ['UI Kit', 'Timeline']
                },
                component: () => import('@/views/uikit/TimelineDoc.vue')
            },
            {
                path: '/uikit/misc',
                name: 'misc',
                meta: {
                    breadcrumb: ['UI Kit', 'Misc']
                },
                component: () => import('@/views/uikit/MiscDoc.vue')
            },
            {
                path: '/blocks/free',
                name: 'blocks',
                meta: {
                    breadcrumb: ['Prime Blocks', 'Free Blocks']
                },
                component: () => import('@/views/utilities/Blocks.vue')
            },
            {
                path: '/pages/empty',
                name: 'empty',
                component: () => import('@/views/pages/Empty.vue')
            },
            {
                path: '/pages/crud',
                name: 'crud',
                component: () => import('@/views/pages/Crud.vue')
            },
            {
                path: '/ecommerce/product-overview',
                name: 'product-overview',
                meta: {
                    breadcrumb: ['E-Commerce', 'Product Overview']
                },
                component: () => import('@/views/e-commerce/ProductOverview.vue')
            },
            {
                path: '/ecommerce/product-list',
                name: 'product-list',
                meta: {
                    breadcrumb: ['E-Commerce', 'Product List']
                },
                component: () => import('@/views/e-commerce/ProductList.vue')
            },
            {
                path: '/ecommerce/new-product',
                name: 'new-product',
                meta: {
                    breadcrumb: ['E-Commerce', 'New Product']
                },
                component: () => import('@/views/e-commerce/NewProduct.vue')
            },
            {
                path: '/ecommerce/shopping-cart',
                name: 'shopping-cart',
                meta: {
                    breadcrumb: ['E-Commerce', 'Shopping Cart']
                },
                component: () => import('@/views/e-commerce/ShoppingCart.vue')
            },
            {
                path: '/ecommerce/checkout-form',
                name: 'checkout-form',
                meta: {
                    breadcrumb: ['E-Commerce', 'Checkout Form']
                },
                component: () => import('@/views/e-commerce/CheckoutForm.vue')
            },
            {
                path: '/ecommerce/order-history',
                name: 'order-history',
                meta: {
                    breadcrumb: ['E-Commerce', 'Order History']
                },
                component: () => import('@/views/e-commerce/OrderHistory.vue')
            },
            {
                path: '/ecommerce/order-summary',
                name: 'order-summary',
                meta: {
                    breadcrumb: ['E-Commerce', 'Order Summary']
                },
                component: () => import('@/views/e-commerce/OrderSummary.vue')
            },

            {
                path: '/profile/create',
                meta: {
                    breadcrumb: ['User Management', 'Create']
                },
                component: () => import('@/views/user-management/create/CreateLayout.vue'),
                children: [
                    {
                        path: '',
                        redirect: '/profile/create/basic-information'
                    },
                    {
                        path: 'basic-information',
                        name: 'user-create-basic',
                        meta: {
                            breadcrumb: ['User Management', 'Create', 'Basic Information'],
                            title: 'Create User - Basic Information'
                        },
                        component: () => import('@/views/user-management/create/BasicInformation.vue')
                    },
                    {
                        path: 'business-information',
                        name: 'user-create-business',
                        meta: {
                            breadcrumb: ['User Management', 'Create', 'Business Information'],
                            title: 'Create User - Business Information'
                        },
                        component: () => import('@/views/user-management/create/BusinessInformation.vue')
                    },
                    {
                        path: 'location-information',
                        name: 'user-create-location',
                        meta: {
                            breadcrumb: ['User Management', 'Create', 'Location Information'],
                            title: 'Create User - Location Information'
                        },
                        component: () => import('@/views/user-management/create/LocationInformation.vue')
                    },
                    {
                        path: 'authorization',
                        name: 'user-create-authorization',
                        meta: {
                            breadcrumb: ['User Management', 'Create', 'Authorization'],
                            title: 'Create User - Authorization'
                        },
                        component: () => import('@/views/user-management/create/Authorization.vue')
                    },
                    {
                        path: 'account-status',
                        name: 'user-create-status',
                        meta: {
                            breadcrumb: ['User Management', 'Create', 'Account Status'],
                            title: 'Create User - Account Status'
                        },
                        component: () => import('@/views/user-management/create/AccountStatus.vue')
                    }
                ]
            },
            {
                path: '/profile/list',
                name: 'user-list',
                meta: {
                    breadcrumb: ['User Management', 'List']
                },
                component: () => import('@/views/user-management/UserList.vue')
            },
            {
                path: '/start/documentation',
                name: 'documentation',
                component: () => import('@/views/utilities/Documentation.vue')
            },
            {
                path: '/pages/aboutus',
                name: 'aboutus',
                meta: {
                    breadcrumb: ['Pages', 'About']
                },
                component: () => import('@/views/pages/AboutUs.vue')
            },
            {
                path: '/pages/faq',
                name: 'faq',
                meta: {
                    breadcrumb: ['Pages', 'FAQ']
                },
                component: () => import('@/views/pages/Faq.vue')
            },
            {
                path: '/pages/help',
                name: 'help',
                component: () => import('@/views/pages/Help.vue')
            },
            {
                path: '/pages/invoice',
                name: 'invoice',
                component: () => import('@/views/pages/Invoice.vue')
            }
        ]
    },
    {
        path: '/landing',
        component: LandingLayout,
        children: [
            {
                path: '',
                name: 'landing',
                component: () => import('@/views/landing/LandingView.vue')
            },
            {
                path: 'features',
                name: 'features',
                component: () => import('@/views/landing/FeaturesView.vue')
            },
            {
                path: 'pricing',
                name: 'pricing',
                component: () => import('@/views/landing/PricingView.vue')
            },
            {
                path: 'contact',
                name: 'contact',
                component: () => import('@/views/landing/ContactView.vue')
            }
        ],
        meta: { scrollToTop: true }
    },
    {
        path: '/auth',
        component: AuthLayout,
        children: [
            {
                path: 'login',
                name: 'login',
                component: () => import('@/views/auth/LoginView.vue')
            },
            {
                path: 'error',
                name: 'error',
                component: () => import('@/views/pages/NotFound.vue')
            },
            {
                path: 'register',
                name: 'register',
                component: () => import('@/views/auth/RegisterView.vue')
            },
            {
                path: 'register/verification',
                name: 'verification',
                component: () => import('@/views/auth/VerificationView.vue')
            },
            {
                path: 'forgot-password',
                name: 'forgot-password',
                component: () => import('@/views/auth/ForgotPassword.vue')
            },
            {
                path: 'new-password',
                name: 'new-password',
                component: () => import('@/views/auth/NewPassword.vue')
            },
            {
                path: 'lock-screen',
                name: 'lock-screen',
                component: () => import('@/views/auth/LockScreen.vue')
            },
            {
                path: 'access',
                name: 'access',
                component: () => import('@/views/pages/AccessDenied.vue')
            },
            {
                path: 'oops',
                name: 'oops',
                component: () => import('@/views/pages/Oops.vue')
            }
        ],
        meta: { scrollToTop: true }
    },
    {
        path: '/pages/notfound',
        component: AuthLayout,
        children: [
            {
                path: '',
                name: 'notfound',
                component: () => import('@/views/pages/NotFound.vue')
            }
        ]
    },
    {
        path: '/:pathMatch(.*)*',
        name: 'empty',
        component: () => import('@/views/pages/NotFound.vue')
    }
];

const router = createRouter({
    history: createWebHistory(),
    routes,
    scrollBehavior() {
        return { left: 0, top: 0 };
    }
});

export default router;
