-- hb_transactions_csv_unique applied to ALL import methods and blocked SimpleFIN re-syncs.
-- Keep CSV-only uniqueness via unique_csv_transaction (already scoped with WHERE import_method = 'csv').

DROP INDEX IF EXISTS public.hb_transactions_csv_unique;
