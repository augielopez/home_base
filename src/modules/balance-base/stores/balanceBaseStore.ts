import { defineStore } from 'pinia';
import { balanceBaseService } from '../services/balanceBaseService';
import type {
    CategorizeResult,
    FinancialAccount,
    FinancialTransaction,
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

type BalanceBaseState = {
    accounts: FinancialAccount[];
    categories: TransactionCategory[];
    transactions: FinancialTransaction[];
    syncRuns: SyncRun[];
    loading: boolean;
    syncing: boolean;
    categorizing: boolean;
    updatingCategoryId: string | null;
    error: string | null;
    lastSyncResult: SimpleFinSyncResult | null;
    lastCategorizeResult: CategorizeResult | null;
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
        loading: false,
        syncing: false,
        categorizing: false,
        updatingCategoryId: null,
        error: null,
        lastSyncResult: null,
        lastCategorizeResult: null,
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
                              category: categoryId ? categoryName : null
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
        }
    }
});
