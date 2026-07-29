import type { ModuleNav } from '../../app/router';

export const supplyBaseNav: ModuleNav = {
    moduleCode: 'SUPPLY_BASE',
    label: 'Supply Base',
    icon: 'pi pi-fw pi-folder',
    path: '/supply-base',
    children: [
        { path: '/supply-base', label: 'Dashboard', icon: 'pi pi-fw pi-th-large', routeName: 'supply-base-dashboard' }
    ]
};

/** @deprecated Use supplyBaseNav */
export const supplyBaseRoutes = supplyBaseNav.children.map((child) => ({
    path: child.path,
    label: child.label
}));
