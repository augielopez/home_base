import { authHeaders, getHbToken } from '@/lib/auth/token';
import {
    mapHbBankAccount,
    mapHbBill,
    mapHbFrequency,
    mapHbTransaction,
    mapHbTransactionCategory,
    type Bill,
    type BillInput,
    type BillsReconMonth,
    type CategorizeResult,
    type FinancialAccount,
    type FinancialTransaction,
    type ReconTransaction,
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

export async function applyAiClassification(domain: 'transactions' | 'bills-recon' = 'transactions') {
    const json = await callBalanceFunction(
        'ai-classify',
        {
            method: 'POST',
            body: JSON.stringify({ domain, limit: 60 })
        }
    );

    if (json && json.success === false) {
        throw new Error(String(json.error || 'AI classification failed'));
    }

    return json as CategorizeResult;
}

export async function getBills() {
    const json = await callBalanceFunction('balance-base-bills', { method: 'GET' }, { include: 'bills,frequencies' });
    return {
        bills: ((json.bills || []) as Parameters<typeof mapHbBill>[0][]).map(mapHbBill),
        frequencies: ((json.frequencies || []) as Parameters<typeof mapHbFrequency>[0][]).map(mapHbFrequency)
    };
}

export async function createBill(input: BillInput) {
    const json = await callBalanceFunction('balance-base-bills', {
        method: 'POST',
        body: JSON.stringify(input)
    });

    if (json && json.success === false) {
        throw new Error(String(json.error || 'Failed to create bill'));
    }

    return mapHbBill(json.bill) as Bill;
}

export async function updateBill(id: string, input: BillInput) {
    const json = await callBalanceFunction('balance-base-bills', {
        method: 'PATCH',
        body: JSON.stringify({ id, ...input })
    });

    if (json && json.success === false) {
        throw new Error(String(json.error || 'Failed to update bill'));
    }

    return mapHbBill(json.bill) as Bill;
}

export async function deleteBill(id: string) {
    const json = await callBalanceFunction('balance-base-bills', { method: 'DELETE' }, { id });

    if (json && json.success === false) {
        throw new Error(String(json.error || 'Failed to delete bill'));
    }

    return String(json.deletedId || id);
}

function mapReconTransaction(row: Record<string, unknown>): ReconTransaction {
    const suggestion = row.suggestion && typeof row.suggestion === 'object' ? (row.suggestion as Record<string, unknown>) : null;
    return {
        id: String(row.id),
        date: String(row.date || ''),
        amount: Number(row.amount || 0),
        description: (row.description as string | null) || null,
        payee: (row.payee as string | null) || null,
        bill_id: (row.bill_id as string | null) || null,
        bill_name: (row.bill_name as string | null) || null,
        match_method: (row.match_method as string | null) || null,
        match_confidence: row.match_confidence == null ? null : Number(row.match_confidence),
        recon_excluded: Boolean(row.recon_excluded),
        suggestion: suggestion
            ? {
                  bill_id: String(suggestion.bill_id),
                  bill_name: String(suggestion.bill_name || ''),
                  confidence: Number(suggestion.confidence || 0),
                  reasons: Array.isArray(suggestion.reasons) ? suggestion.reasons.map(String) : []
              }
            : null
    };
}

export async function getBillsReconMonth(year: number, month: number): Promise<BillsReconMonth & { highConfidence: number }> {
    const json = await callBalanceFunction('balance-base-recon', { method: 'GET' }, { year: String(year), month: String(month) });

    return {
        year: Number(json.year || year),
        month: Number(json.month || month),
        highConfidence: Number(json.highConfidence || 85),
        bills: ((json.bills || []) as Parameters<typeof mapHbBill>[0][]).map(mapHbBill),
        unmatched: ((json.unmatched || []) as Record<string, unknown>[]).map(mapReconTransaction),
        matched: ((json.matched || []) as Record<string, unknown>[]).map(mapReconTransaction),
        excluded: ((json.excluded || []) as Record<string, unknown>[]).map(mapReconTransaction)
    };
}

export async function matchTransactionToBill(payload: {
    transactionId: string;
    billId: string;
    matchMethod?: 'manual' | 'auto';
    confidence?: number;
}) {
    const json = await callBalanceFunction('balance-base-recon', {
        method: 'POST',
        body: JSON.stringify({
            action: 'match',
            transactionId: payload.transactionId,
            billId: payload.billId,
            matchMethod: payload.matchMethod || 'manual',
            confidence: payload.confidence
        })
    });

    if (json && json.success === false) {
        throw new Error(String(json.error || 'Failed to match transaction'));
    }

    return json;
}

export async function unmatchTransaction(transactionId: string) {
    const json = await callBalanceFunction('balance-base-recon', {
        method: 'POST',
        body: JSON.stringify({ action: 'unmatch', transactionId })
    });

    if (json && json.success === false) {
        throw new Error(String(json.error || 'Failed to unmatch transaction'));
    }

    return json;
}

export async function excludeTransactionFromRecon(transactionId: string) {
    const json = await callBalanceFunction('balance-base-recon', {
        method: 'POST',
        body: JSON.stringify({ action: 'exclude', transactionId })
    });

    if (json && json.success === false) {
        throw new Error(String(json.error || 'Failed to exclude transaction'));
    }

    return json;
}

export async function includeTransactionInRecon(transactionId: string) {
    const json = await callBalanceFunction('balance-base-recon', {
        method: 'POST',
        body: JSON.stringify({ action: 'include', transactionId })
    });

    if (json && json.success === false) {
        throw new Error(String(json.error || 'Failed to include transaction'));
    }

    return json;
}

export async function acceptHighConfidenceMatches(year: number, month: number) {
    const json = await callBalanceFunction('balance-base-recon', {
        method: 'POST',
        body: JSON.stringify({ action: 'accept_high_confidence', year, month })
    });

    if (json && json.success === false) {
        throw new Error(String(json.error || 'Failed to accept high-confidence matches'));
    }

    return json as { success: boolean; examined: number; updated: number; minConfidence: number };
}

export const balanceBaseService = {
    getAccounts,
    getCategories,
    getTransactions,
    getSyncRuns,
    updateTransactionCategory,
    syncSimplefin,
    applyCategoryRules,
    applyAiClassification,
    getBills,
    createBill,
    updateBill,
    deleteBill,
    getBillsReconMonth,
    matchTransactionToBill,
    unmatchTransaction,
    excludeTransactionFromRecon,
    includeTransactionInRecon,
    acceptHighConfidenceMatches
};
