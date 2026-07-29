import { balanceBaseNav } from '../../modules/balance-base/routes';
import { careerBaseNav } from '../../modules/career-base/routes';
import { celebrationBaseNav } from '../../modules/celebration-base/routes';
import { productivityBaseNav } from '../../modules/productivity-base/routes';
import { supplyBaseNav } from '../../modules/supply-base/routes';

export type ModuleNavChild = {
    path: string;
    label: string;
    icon?: string;
    routeName?: string;
};

export type ModuleNav = {
    moduleCode: string;
    label: string;
    icon?: string;
    path: string;
    children: ModuleNavChild[];
};

/** @deprecated Use ModuleNav children instead */
export type AppRoute = {
    path: string;
    label: string;
};

export const moduleNavRegistry: Record<string, ModuleNav> = {
    BALANCE_BASE: balanceBaseNav,
    CAREER_BASE: careerBaseNav,
    CELEBRATION_BASE: celebrationBaseNav,
    PRODUCTIVITY_BASE: productivityBaseNav,
    SUPPLY_BASE: supplyBaseNav
};

export const moduleNavs: ModuleNav[] = Object.values(moduleNavRegistry);

export const appRoutes: AppRoute[] = moduleNavs.flatMap((nav) =>
    nav.children.map((child) => ({ path: child.path, label: child.label }))
);
