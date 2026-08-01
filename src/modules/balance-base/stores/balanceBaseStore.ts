import { defineStore } from 'pinia';
import { balanceBaseService } from '../services/balanceBaseService';
import type {
    Bill,
    BillFrequency,
    BillInput,
    CategorizeResult,
    FinancialAccount,
    FinancialTransaction,
    ReconTransaction,
    SimpleFinSyncResult,
    SyncRun,
    TransactionCategory,
    TransactionFilters
} from '../types/balanceBase.types';

const defaultFilters = (): TransactionFilters => ({
    search: '',
    accountId: null,
    categoryId: null,
    startDate: null,
    endDate: null
});

function currentYearMonth() {
    const now = new Date();
    return { year: now.getFullYear(), month: now.getMonth() + 1 };
}

type BalanceBaseState = {
    accounts: FinancialAccount[];
    categories: TransactionCategory[];
    transactions: FinancialTransaction[];
    syncRuns: SyncRun[];
    bills: Bill[];
    billFrequencies: BillFrequency[];
    reconYear: number;
    reconMonth: number;
    reconBills: Bill[];
    reconUnmatched: ReconTransaction[];
    reconMatched: ReconTransaction[];
    reconExcluded: ReconTransaction[];
    reconHighConfidence: number;
    loading: boolean;
    syncing: boolean;
    categorizing: boolean;
    aiClassifying: boolean;
    savingBill: boolean;
    reconSaving: boolean;
    updatingCategoryId: string | null;
    error: string | null;
    lastSyncResult: SimpleFinSyncResult | null;
    lastCategorizeResult: CategorizeResult | null;
    lastAiResult: CategorizeResult | null;
    filters: TransactionFilters;
};

function errorMessage(err: unknown) {
    if (err instanceof Error) return err.message;
    if (typeof err === 'object' && err && 'message' in err) return String((err as { message?: unknown }).message);
    return 'Something went wrong while loading Balance Base.';
}

export const useBalanceBaseStore = defineStore('balanceBase', {
    state: (): BalanceBaseState => ({
        accounts: [],
        categories: [],
        transactions: [],
        syncRuns: [],
        bills: [],
        billFrequencies: [],
        reconYear: currentYearMonth().year,
        reconMonth: currentYearMonth().month,
        reconBills: [],
        reconUnmatched: [],
        reconMatched: [],
        reconExcluded: [],
        reconHighConfidence: 85,
        loading: false,
        syncing: false,
        categorizing: false,
        aiClassifying: false,
        savingBill: false,
        reconSaving: false,
        updatingCategoryId: null,
        error: null,
        lastSyncResult: null,
        lastCategorizeResult: null,
        lastAiResult: null,
        filters: defaultFilters()
    }),

    actions: {
        async fetchAccounts() {
            this.accounts = await balanceBaseService.getAccounts();
        },

        async fetchCategories() {
            this.categories = await balanceBaseService.getCategories();
        },

        async fetchTransactions() {
            this.transactions = await balanceBaseService.getTransactions(this.filters);
        },

        async fetchSyncRuns() {
            this.syncRuns = await balanceBaseService.getSyncRuns();
        },

        async updateTransactionCategory(transactionId: string, categoryId: string | null) {
            this.updatingCategoryId = transactionId;
            this.error = null;

            try {
                const updated = await balanceBaseService.updateTransactionCategory(transactionId, categoryId);
                const categoryName = this.categories.find((category) => category.id === categoryId)?.name || updated.category;

                this.transactions = this.transactions.map((transaction) =>
                    transaction.id === transactionId
                        ? {
                              ...transaction,
                              category_id: categoryId,
                              category: categoryId ? categoryName : null,
                              category_match_method: categoryId ? 'manual' : 'unmatched',
                              category_confidence: categoryId ? 1 : 0
                          }
                        : transaction
                );
            } catch (err) {
                this.error = errorMessage(err);
                throw err;
            } finally {
                this.updatingCategoryId = null;
            }
        },

        async syncSimplefin() {
            this.syncing = true;
            this.error = null;

            try {
                this.lastSyncResult = await balanceBaseService.syncSimplefin();
                await Promise.all([this.fetchAccounts(), this.fetchCategories(), this.fetchTransactions(), this.fetchSyncRuns()]);
            } catch (err) {
                this.error = errorMessage(err);
                throw err;
            } finally {
                this.syncing = false;
            }
        },

        async applyCategoryRules() {
            this.categorizing = true;
            this.error = null;

            try {
                this.lastCategorizeResult = await balanceBaseService.applyCategoryRules();
                await this.fetchTransactions();
            } catch (err) {
                this.error = errorMessage(err);
                throw err;
            } finally {
                this.categorizing = false;
            }
        },

        async applyAiClassification(domain: 'transactions' | 'bills-recon' = 'transactions') {
            this.aiClassifying = true;
            this.error = null;

            try {
                this.lastAiResult = await balanceBaseService.applyAiClassification(domain);
                if (domain === 'transactions') {
                    await this.fetchTransactions();
                }
            } catch (err) {
                this.error = errorMessage(err);
                throw err;
            } finally {
                this.aiClassifying = false;
            }
        },

        async fetchBills() {
            const result = await balanceBaseService.getBills();
            this.bills = result.bills;
            this.billFrequencies = result.frequencies;
        },

        async createBill(input: BillInput) {
            this.savingBill = true;
            this.error = null;

            try {
                const bill = await balanceBaseService.createBill(input);
                this.bills = [...this.bills, bill].sort((a, b) => a.bill_name.localeCompare(b.bill_name));
                return bill;
            } catch (err) {
                this.error = errorMessage(err);
                throw err;
            } finally {
                this.savingBill = false;
            }
        },

        async updateBill(id: string, input: BillInput) {
            this.savingBill = true;
            this.error = null;

            try {
                const bill = await balanceBaseService.updateBill(id, input);
                this.bills = this.bills
                    .map((row) => (row.id === id ? bill : row))
                    .sort((a, b) => a.bill_name.localeCompare(b.bill_name));
                return bill;
            } catch (err) {
                this.error = errorMessage(err);
                throw err;
            } finally {
                this.savingBill = false;
            }
        },

        async deleteBill(id: string) {
            this.savingBill = true;
            this.error = null;

            try {
                await balanceBaseService.deleteBill(id);
                this.bills = this.bills.filter((bill) => bill.id !== id);
            } catch (err) {
                this.error = errorMessage(err);
                throw err;
            } finally {
                this.savingBill = false;
            }
        },

        setFilters(filters: Partial<TransactionFilters>) {
            this.filters = { ...this.filters, ...filters };
        },

        clearFilters() {
            this.filters = defaultFilters();
        },

        async refreshTransactionsPage() {
            this.loading = true;
            this.error = null;

            try {
                await Promise.all([this.fetchAccounts(), this.fetchCategories(), this.fetchTransactions(), this.fetchSyncRuns()]);
            } catch (err) {
                this.error = errorMessage(err);
            } finally {
                this.loading = false;
            }
        },

        async refreshAccountsPage() {
            this.loading = true;
            this.error = null;

            try {
                await this.fetchAccounts();
            } catch (err) {
                this.error = errorMessage(err);
            } finally {
                this.loading = false;
            }
        },

        async refreshBillsPage() {
            this.loading = true;
            this.error = null;

            try {
                await this.fetchBills();
            } catch (err) {
                this.error = errorMessage(err);
            } finally {
                this.loading = false;
            }
        },

        async fetchBillsRecon(year?: number, month?: number) {
            const targetYear = year ?? this.reconYear;
            const targetMonth = month ?? this.reconMonth;
            const result = await balanceBaseService.getBillsReconMonth(targetYear, targetMonth);
            this.reconYear = result.year;
            this.reconMonth = result.month;
            this.reconHighConfidence = result.highConfidence;
            this.reconBills = result.bills;
            this.reconUnmatched = result.unmatched;
            this.reconMatched = result.matched;
            this.reconExcluded = result.excluded;
        },

        async refreshBillsReconPage(year?: number, month?: number) {
            this.loading = true;
            this.error = null;
            const targetYear = year ?? this.reconYear;
            const targetMonth = month ?? this.reconMonth;
            this.reconYear = targetYear;
            this.reconMonth = targetMonth;

            try {
                await this.fetchBillsRecon(targetYear, targetMonth);
            } catch (err) {
                this.error = errorMessage(err);
            } finally {
                this.loading = false;
            }
        },

        async matchReconTransaction(transactionId: string, billId: string, opts?: { matchMethod?: 'manual' | 'auto'; confidence?: number }) {
            this.reconSaving = true;
            this.error = null;

            try {
                await balanceBaseService.matchTransactionToBill({
                    transactionId,
                    billId,
                    matchMethod: opts?.matchMethod || 'manual',
                    confidence: opts?.confidence
                });
                await this.fetchBillsRecon();
            } catch (err) {
                this.error = errorMessage(err);
                throw err;
            } finally {
                this.reconSaving = false;
            }
        },

        async unmatchReconTransaction(transactionId: string) {
            this.reconSaving = true;
            this.error = null;

            try {
                await balanceBaseService.unmatchTransaction(transactionId);
                await this.fetchBillsRecon();
            } catch (err) {
                this.error = errorMessage(err);
                throw err;
            } finally {
                this.reconSaving = false;
            }
        },

        async excludeReconTransaction(transactionId: string) {
            this.reconSaving = true;
            this.error = null;

            try {
                await balanceBaseService.excludeTransactionFromRecon(transactionId);
                await this.fetchBillsRecon();
            } catch (err) {
                this.error = errorMessage(err);
                throw err;
            } finally {
                this.reconSaving = false;
            }
        },

        async includeReconTransaction(transactionId: string) {
            this.reconSaving = true;
            this.error = null;

            try {
                await balanceBaseService.includeTransactionInRecon(transactionId);
                await this.fetchBillsRecon();
            } catch (err) {
                this.error = errorMessage(err);
                throw err;
            } finally {
                this.reconSaving = false;
            }
        },

        async acceptHighConfidenceReconMatches() {
            this.reconSaving = true;
            this.error = null;

            try {
                const result = await balanceBaseService.acceptHighConfidenceMatches(this.reconYear, this.reconMonth);
                await this.fetchBillsRecon();
                return result;
            } catch (err) {
                this.error = errorMessage(err);
                throw err;
            } finally {
                this.reconSaving = false;
            }
        }
    }
});
