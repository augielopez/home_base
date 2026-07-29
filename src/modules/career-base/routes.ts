import type { ModuleNav } from '../../app/router';

export const careerBaseNav: ModuleNav = {
    moduleCode: 'CAREER_BASE',
    label: 'Career Base',
    icon: 'pi pi-fw pi-folder',
    path: '/career-base',
    children: [
        { path: '/career-base', label: 'Dashboard', icon: 'pi pi-fw pi-th-large', routeName: 'career-base-dashboard' }
    ]
};

/** @deprecated Use careerBaseNav */
export const careerBaseRoutes = careerBaseNav.children.map((child) => ({
    path: child.path,
    label: child.label
}));
