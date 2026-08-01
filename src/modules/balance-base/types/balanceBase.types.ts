export type JsonRecord = Record<string, unknown>;

export type FinancialAccount = {
    id: string;
    user_id: string;
    simplefin_account_id: string | null;
    name: string;
    bank_name: string;
    account_type: string;
    external_source: string | null;
    is_active: boolean;
    currency: string;
    balance: number | null;
    available_balance: number | null;
    balance_date: string | null;
    metadata: JsonRecord | null;
    created_at: string;
    updated_at: string;
};

export type FinancialTransaction = {
    id: string;
    user_id: string;
    account_id: string;
    transaction_id: string | null;
    posted_date: string | null;
    amount: number;
    description: string | null;
    payee: string | null;
    category_id: string | null;
    category: string | null;
    category_match_method: 'unmatched' | 'manual' | 'auto' | 'ai' | string | null;
    category_confidence: number | null;
    bill_id: string | null;
    match_method: 'unmatched' | 'manual' | 'auto' | 'ai' | string | null;
    match_confidence: number | null;
    recon_excluded: boolean;
    pending: boolean;
    reviewed: boolean;
    currency: string;
    bank_source: string | null;
    import_method: string | null;
    source_metadata: JsonRecord | null;
    created_at: string;
    updated_at: string;
    account?: Pick<FinancialAccount, 'id' | 'name' | 'currency' | 'bank_name'> | null;
};

export type TransactionCategory = {
    id: string;
    name: string;
    description: string | null;
    color: string | null;
    icon: string | null;
    is_active: boolean;
};

export type SyncRun = {
    id: string;
    user_id: string;
    sync_type: string;
    status: string;
    started_at: string | null;
    finished_at: string | null;
    error_message: string | null;
    records_processed: number;
    metadata: JsonRecord | null;
    created_at: string;
    updated_at: string;
};

export type SimpleFinSyncResult = {
    success: boolean;
    accountsProcessed: number;
    transactionsProcessed: number;
    categorized?: {
        examined: number;
        updated: number;
        skipped: number;
    };
    warnings?: string[];
    error?: string;
};

export type CategorizeResult = {
    success: boolean;
    examined: number;
    updated: number;
    skipped: number;
    lowConfidence?: number;
    domain?: string;
    error?: string;
};

export type TransactionFilters = {
    search: string;
    accountId: string | null;
    categoryId: string | null;
    startDate: string | null;
    endDate: string | null;
};

export type BillFrequency = {
    id: string;
    name: string;
    description: string | null;
};

export type Bill = {
    id: string;
    bill_name: string;
    amount_due: number | null;
    due_date: string | null;
    status: string;
    description: string | null;
    frequency_id: string | null;
    frequency_name: string | null;
    last_paid: string | null;
    is_fixed_bill: boolean;
    is_included_in_monthly_payment: boolean;
    created_at: string;
    updated_at: string;
    created_by: string;
    updated_by: string;
};

export type BillInput = {
    bill_name: string;
    amount_due: number | null;
    due_date: string | null;
    status: string;
    description: string | null;
    frequency_id: string | null;
    last_paid: string | null;
    is_fixed_bill: boolean;
    is_included_in_monthly_payment: boolean;
};

export const BILL_STATUS_OPTIONS = [
    { label: 'Active', value: 'Active' },
    { label: 'Inactive', value: 'Inactive' }
] as const;

export type BillMatchSuggestion = {
    bill_id: string;
    bill_name: string;
    confidence: number;
    reasons: string[];
};

export type ReconTransaction = {
    id: string;
    date: string;
    amount: number;
    description: string | null;
    payee: string | null;
    bill_id: string | null;
    bill_name: string | null;
    match_method: string | null;
    match_confidence: number | null;
    recon_excluded: boolean;
    suggestion: BillMatchSuggestion | null;
};

export type BillsReconMonth = {
    year: number;
    month: number;
    unmatched: ReconTransaction[];
    matched: ReconTransaction[];
    excluded: ReconTransaction[];
    bills: Bill[];
};

type HbBankAccountRow = {
    id: string;
    user_id: string;
    name: string;
    bank_name: string;
    account_type: string;
    simplefin_account_id: string | null;
    external_source: string | null;
    is_active: boolean;
    metadata: JsonRecord | null;
    created_at: string;
    updated_at: string;
};

type HbTransactionRow = {
    id: string;
    user_id: string;
    account_id: string;
    transaction_id: string | null;
    amount: number;
    date: string;
    name: string;
    merchant_name: string | null;
    description: string | null;
    pending: boolean;
    is_reconciled: boolean;
    iso_currency_code: string | null;
    bank_source: string | null;
    import_method: string | null;
    source_metadata: JsonRecord | null;
    category_id: string | null;
    category_match_method?: string | null;
    category_confidence?: number | null;
    bill_id?: string | null;
    match_method?: string | null;
    match_confidence?: number | null;
    recon_excluded?: boolean | null;
    created_at: string;
    updated_at: string;
    category?: { name: string } | null;
};

function parseMetadataNumber(value: unknown): number | null {
    if (value === null || typeof value === 'undefined' || value === '') return null;
    const parsed = Number(value);
    return Number.isFinite(parsed) ? parsed : null;
}

function formatBalanceDate(value: unknown): string | null {
    if (typeof value === 'number') return new Date(value * 1000).toISOString();
    if (typeof value === 'string' && /^\d+$/.test(value)) return new Date(Number(value) * 1000).toISOString();
    if (typeof value === 'string' && value.trim()) return value;
    return null;
}

export function mapHbBankAccount(row: HbBankAccountRow): FinancialAccount {
    const metadata = (row.metadata || {}) as JsonRecord;

    return {
        id: row.id,
        user_id: row.user_id,
        simplefin_account_id: row.simplefin_account_id,
        name: row.name,
        bank_name: row.bank_name,
        account_type: row.account_type,
        external_source: row.external_source,
        is_active: row.is_active,
        currency: String(metadata.currency || 'USD'),
        balance: parseMetadataNumber(metadata.balance),
        available_balance: parseMetadataNumber(metadata.available_balance),
        balance_date: formatBalanceDate(metadata.balance_date),
        metadata: row.metadata,
        created_at: row.created_at,
        updated_at: row.updated_at
    };
}

function categoryFromRow(row: HbTransactionRow) {
    if (row.category?.name) return row.category.name;

    const metadata = (row.source_metadata || {}) as JsonRecord;
    if (typeof metadata.category === 'string' && metadata.category) return metadata.category;

    return null;
}

export function mapHbTransaction(row: HbTransactionRow, account?: FinancialAccount | null): FinancialTransaction {
    return {
        id: row.id,
        user_id: row.user_id,
        account_id: row.account_id,
        transaction_id: row.transaction_id,
        posted_date: row.date,
        amount: Number(row.amount),
        description: row.description || row.name,
        payee: row.merchant_name,
        category_id: row.category_id,
        category: categoryFromRow(row),
        category_match_method: row.category_match_method || (row.category_id ? 'auto' : 'unmatched'),
        category_confidence: row.category_confidence == null ? null : Number(row.category_confidence),
        bill_id: row.bill_id || null,
        match_method: row.match_method || (row.bill_id ? 'manual' : 'unmatched'),
        match_confidence: row.match_confidence == null ? null : Number(row.match_confidence),
        recon_excluded: Boolean(row.recon_excluded),
        pending: row.pending,
        reviewed: row.is_reconciled,
        currency: row.iso_currency_code || account?.currency || 'USD',
        bank_source: row.bank_source,
        import_method: row.import_method,
        source_metadata: row.source_metadata,
        created_at: row.created_at,
        updated_at: row.updated_at,
        account: account
            ? {
                  id: account.id,
                  name: account.name,
                  currency: account.currency,
                  bank_name: account.bank_name
              }
            : null
    };
}

export function mapHbTransactionCategory(row: {
    id: string;
    name: string;
    description?: string | null;
    color?: string | null;
    icon?: string | null;
    is_active?: boolean;
}): TransactionCategory {
    return {
        id: row.id,
        name: row.name,
        description: row.description ?? null,
        color: row.color ?? null,
        icon: row.icon ?? null,
        is_active: row.is_active !== false
    };
}

type HbBillRow = {
    id: string;
    bill_name: string | null;
    amount_due: number | null;
    due_date: string | null;
    status: string | null;
    description: string | null;
    frequency_id: string | null;
    last_paid: string | null;
    is_fixed_bill: boolean | null;
    is_included_in_monthly_payment: boolean | null;
    created_at: string;
    updated_at: string;
    created_by: string;
    updated_by: string;
    frequency?: { id: string; name: string } | null;
};

export function mapHbBill(row: HbBillRow): Bill {
    return {
        id: row.id,
        bill_name: row.bill_name || 'Untitled bill',
        amount_due: row.amount_due == null ? null : Number(row.amount_due),
        due_date: row.due_date,
        status: row.status || 'Active',
        description: row.description,
        frequency_id: row.frequency_id,
        frequency_name: row.frequency?.name || null,
        last_paid: row.last_paid,
        is_fixed_bill: Boolean(row.is_fixed_bill),
        is_included_in_monthly_payment: row.is_included_in_monthly_payment !== false,
        created_at: row.created_at,
        updated_at: row.updated_at,
        created_by: row.created_by,
        updated_by: row.updated_by
    };
}

export function mapHbFrequency(row: { id: string; name: string; description?: string | null }): BillFrequency {
    return {
        id: row.id,
        name: row.name,
        description: row.description ?? null
    };
}
