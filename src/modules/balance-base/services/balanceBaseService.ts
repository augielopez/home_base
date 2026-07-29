import { authHeaders, getHbToken } from '@/lib/auth/token';
import {
    mapHbBankAccount,
    mapHbTransaction,
    mapHbTransactionCategory,
    type CategorizeResult,
    type FinancialAccount,
    type FinancialTransaction,
    type SimpleFinSyncResult,
    type SyncRun,
    type TransactionCategory,
    type TransactionFilters
} from '../types/balanceBase.types';

const FUNCTIONS_BASE = import.meta.env.VITE_FUNCTIONS_URL || '';
const SIGN_IN_ERROR = 'Sign in to view Balance Base data.';

function buildUrl(path: string, query?: Record<string, string | undefined | null>) {
    const base = FUNCTIONS_BASE ? `${FUNCTIONS_BASE}/${path}` : `/api/${path}`;
    const url = new URL(base, typeof window !== 'undefined' ? window.location.origin : 'http://localhost');

    if (query) {
        for (const [key, value] of Object.entries(query)) {
            if (value !== undefined && value !== null && value !== '') {
                url.searchParams.set(key, value);
            }
        }
    }

    return FUNCTIONS_BASE ? url.toString() : `${url.pathname}${url.search}`;
}

async function callBalanceFunction(path: string, opts: RequestInit = {}, query?: Record<string, string | undefined | null>) {
    if (!getHbToken()) {
        throw new Error(SIGN_IN_ERROR);
    }

    const res = await fetch(buildUrl(path, query), {
        ...opts,
        credentials: 'include',
        headers: authHeaders((opts.headers as Record<string, string>) || {})
    });

    const json = await res.json().catch(() => ({}));

    if (res.status === 401) {
        throw new Error(SIGN_IN_ERROR);
    }

    if (!res.ok) {
        const message = (json && (json.error || json.message)) || `Request failed (${res.status})`;
        throw new Error(String(message));
    }

    return json;
}

function accountMapFromList(accounts: FinancialAccount[]) {
    return new Map(
        accounts.filter((account) => account.simplefin_account_id).map((account) => [account.simplefin_account_id as string, account])
    );
}

export async function getAccounts() {
    const json = await callBalanceFunction('balance-base-data', { method: 'GET' }, { include: 'accounts' });
    return ((json.accounts || []) as Parameters<typeof mapHbBankAccount>[0][]).map(mapHbBankAccount) as FinancialAccount[];
}

export async function getCategories() {
    const json = await callBalanceFunction('balance-base-data', { method: 'GET' }, { include: 'categories' });
    return ((json.categories || []) as Parameters<typeof mapHbTransactionCategory>[0][]).map(mapHbTransactionCategory);
}

export async function getTransactions(filters?: Partial<TransactionFilters>) {
    const json = await callBalanceFunction(
        'balance-base-data',
        { method: 'GET' },
        {
            include: 'accounts,transactions',
            search: filters?.search || undefined,
            accountId: filters?.accountId || undefined,
            categoryId: filters?.categoryId || undefined,
            startDate: filters?.startDate || undefined,
            endDate: filters?.endDate || undefined
        }
    );

    const accounts = ((json.accounts || []) as Parameters<typeof mapHbBankAccount>[0][]).map(mapHbBankAccount) as FinancialAccount[];
    const accountByExternalId = accountMapFromList(accounts);

    return ((json.transactions || []) as Parameters<typeof mapHbTransaction>[0][]).map((row) =>
        mapHbTransaction(row, accountByExternalId.get(row.account_id) || null)
    ) as FinancialTransaction[];
}

export async function getSyncRuns() {
    const json = await callBalanceFunction('balance-base-data', { method: 'GET' }, { include: 'syncRuns' });
    return (json.syncRuns || []) as SyncRun[];
}

export async function updateTransactionCategory(transactionId: string, categoryId: string | null) {
    const json = await callBalanceFunction('balance-base-data', {
        method: 'PATCH',
        body: JSON.stringify({ transactionId, categoryId })
    });

    return mapHbTransaction(json.transaction) as FinancialTransaction;
}

export async function syncSimplefin() {
    const json = await callBalanceFunction('sync-simplefin', { method: 'POST', body: '{}' });

    if (json && json.success === false) {
        throw new Error(String(json.error || 'SimpleFIN sync failed'));
    }

    return json as SimpleFinSyncResult;
}

export async function applyCategoryRules() {
    const json = await callBalanceFunction('categorize-transactions', { method: 'POST', body: '{}' });

    if (json && json.success === false) {
        throw new Error(String(json.error || 'Failed to apply category rules'));
    }

    return json as CategorizeResult;
}

export const balanceBaseService = {
    getAccounts,
    getCategories,
    getTransactions,
    getSyncRuns,
    updateTransactionCategory,
    syncSimplefin,
    applyCategoryRules
};
