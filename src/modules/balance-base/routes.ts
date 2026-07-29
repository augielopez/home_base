import type { ModuleNav } from '../../app/router';

export const balanceBaseNav: ModuleNav = {
    moduleCode: 'BALANCE_BASE',
    label: 'Balance Base',
    icon: 'pi pi-fw pi-folder',
    path: '/balance-base',
    children: [
        { path: '/balance-base', label: 'Dashboard', icon: 'pi pi-fw pi-th-large', routeName: 'balance-base-dashboard' },
        { path: '/balance-base/accounts', label: 'Accounts', icon: 'pi pi-fw pi-wallet', routeName: 'balance-base-accounts' },
        { path: '/balance-base/transactions', label: 'Transactions', icon: 'pi pi-fw pi-arrows-h', routeName: 'balance-base-transactions' },
        { path: '/balance-base/bills', label: 'Bills', icon: 'pi pi-fw pi-file', routeName: 'balance-base-bills' },
        { path: '/balance-base/bills-recon', label: 'Bills Recon', icon: 'pi pi-fw pi-check-square', routeName: 'balance-base-bills-recon' }
    ]
};

/** @deprecated Use balanceBaseNav */
export const balanceBaseRoutes = balanceBaseNav.children.map((child) => ({
    path: child.path,
    label: child.label
}));
