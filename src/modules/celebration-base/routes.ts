import type { ModuleNav } from '../../app/router';

export const celebrationBaseNav: ModuleNav = {
    moduleCode: 'CELEBRATION_BASE',
    label: 'Celebration Base',
    icon: 'pi pi-fw pi-folder',
    path: '/celebration-base',
    children: [
        { path: '/celebration-base', label: 'Dashboard', icon: 'pi pi-fw pi-th-large', routeName: 'celebration-base-dashboard' }
    ]
};

/** @deprecated Use celebrationBaseNav */
export const celebrationBaseRoutes = celebrationBaseNav.children.map((child) => ({
    path: child.path,
    label: child.label
}));
