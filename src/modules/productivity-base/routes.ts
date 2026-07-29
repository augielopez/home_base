import type { ModuleNav } from '../../app/router';

export const productivityBaseNav: ModuleNav = {
    moduleCode: 'PRODUCTIVITY_BASE',
    label: 'Productivity Base',
    icon: 'pi pi-fw pi-folder',
    path: '/productivity-base',
    children: [
        { path: '/productivity-base', label: 'Dashboard', icon: 'pi pi-fw pi-th-large', routeName: 'productivity-base' },
        { path: '/productivity-base/todos', label: 'Todos', icon: 'pi pi-fw pi-list', routeName: 'productivity-base-todos' }
    ]
};

/** @deprecated Use productivityBaseNav */
export const productivityBaseRoutes = productivityBaseNav.children.map((child) => ({
    path: child.path,
    label: child.label
}));
