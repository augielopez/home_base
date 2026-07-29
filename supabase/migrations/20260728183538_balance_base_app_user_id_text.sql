-- Allow Balance Base ownership via master_users.user_id (bigint as text)
-- instead of requiring native Supabase Auth auth.users UUIDs.
-- Edge functions authenticate with hb_token and write/read with the service role.

-- Drop dependent RLS policies before altering column types
DROP POLICY IF EXISTS "Users can select own sync runs" ON public.hb_sync_runs;
DROP POLICY IF EXISTS "Users can insert own sync runs" ON public.hb_sync_runs;
DROP POLICY IF EXISTS "Users can update own sync runs" ON public.hb_sync_runs;
DROP POLICY IF EXISTS "Users can delete own sync runs" ON public.hb_sync_runs;

DROP POLICY IF EXISTS "Users can view their own bank accounts" ON public.hb_bank_accounts;
DROP POLICY IF EXISTS "Users can insert their own bank accounts" ON public.hb_bank_accounts;
DROP POLICY IF EXISTS "Users can update their own bank accounts" ON public.hb_bank_accounts;

DROP POLICY IF EXISTS "Users can view their own transactions" ON public.hb_transactions;
DROP POLICY IF EXISTS "Users can insert their own transactions" ON public.hb_transactions;
DROP POLICY IF EXISTS "Users can update their own transactions" ON public.hb_transactions;

-- Views that depend on hb_transactions.user_id must be recreated after the type change
DROP VIEW IF EXISTS public.hb_plaid_transactions_view;

-- hb_sync_runs: drop auth.users FK and store app user ids as text
DO $$
DECLARE
  constraint_name text;
BEGIN
  SELECT tc.constraint_name INTO constraint_name
  FROM information_schema.table_constraints tc
  JOIN information_schema.key_column_usage kcu
    ON tc.constraint_name = kcu.constraint_name
   AND tc.table_schema = kcu.table_schema
  WHERE tc.table_schema = 'public'
    AND tc.table_name = 'hb_sync_runs'
    AND tc.constraint_type = 'FOREIGN KEY'
    AND kcu.column_name = 'user_id'
  LIMIT 1;

  IF constraint_name IS NOT NULL THEN
    EXECUTE format('ALTER TABLE public.hb_sync_runs DROP CONSTRAINT %I', constraint_name);
  END IF;
END $$;

ALTER TABLE public.hb_sync_runs
  ALTER COLUMN user_id TYPE TEXT USING user_id::text;

-- hb_bank_accounts.user_id → text for master_users ids
DO $$
DECLARE
  constraint_name text;
BEGIN
  SELECT tc.constraint_name INTO constraint_name
  FROM information_schema.table_constraints tc
  JOIN information_schema.key_column_usage kcu
    ON tc.constraint_name = kcu.constraint_name
   AND tc.table_schema = kcu.table_schema
  WHERE tc.table_schema = 'public'
    AND tc.table_name = 'hb_bank_accounts'
    AND tc.constraint_type = 'FOREIGN KEY'
    AND kcu.column_name = 'user_id'
  LIMIT 1;

  IF constraint_name IS NOT NULL THEN
    EXECUTE format('ALTER TABLE public.hb_bank_accounts DROP CONSTRAINT %I', constraint_name);
  END IF;
END $$;

ALTER TABLE public.hb_bank_accounts
  ALTER COLUMN user_id TYPE TEXT USING user_id::text;

-- hb_transactions.user_id → text for master_users ids
DO $$
DECLARE
  constraint_name text;
BEGIN
  SELECT tc.constraint_name INTO constraint_name
  FROM information_schema.table_constraints tc
  JOIN information_schema.key_column_usage kcu
    ON tc.constraint_name = kcu.constraint_name
   AND tc.table_schema = kcu.table_schema
  WHERE tc.table_schema = 'public'
    AND tc.table_name = 'hb_transactions'
    AND tc.constraint_type = 'FOREIGN KEY'
    AND kcu.column_name = 'user_id'
  LIMIT 1;

  IF constraint_name IS NOT NULL THEN
    EXECUTE format('ALTER TABLE public.hb_transactions DROP CONSTRAINT %I', constraint_name);
  END IF;
END $$;

ALTER TABLE public.hb_transactions
  ALTER COLUMN user_id TYPE TEXT USING user_id::text;

-- Recreate dependent view
CREATE VIEW public.hb_plaid_transactions_view
            (id, user_id, item_id, account_id, transaction_id, amount, date, name, merchant_name, category, category_id,
             pending, payment_channel, personal_finance_category, location, iso_currency_code, unofficial_currency_code,
             created_at)
AS
SELECT hb_transactions.id,
       hb_transactions.user_id,
       hb_transactions.item_id,
       hb_transactions.account_id,
       hb_transactions.transaction_id,
       hb_transactions.amount,
       hb_transactions.date,
       hb_transactions.name,
       hb_transactions.merchant_name,
       hb_transactions.plaid_category AS category,
       hb_transactions.category_id,
       hb_transactions.pending,
       hb_transactions.payment_channel,
       hb_transactions.personal_finance_category,
       hb_transactions.location,
       hb_transactions.iso_currency_code,
       hb_transactions.unofficial_currency_code,
       hb_transactions.created_at
FROM hb_transactions
WHERE hb_transactions.import_method::text = 'plaid'::text;

GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON public.hb_plaid_transactions_view TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON public.hb_plaid_transactions_view TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON public.hb_plaid_transactions_view TO service_role;

-- Recreate RLS policies using text comparison with auth.uid()
CREATE POLICY "Users can select own sync runs"
  ON public.hb_sync_runs FOR SELECT TO authenticated
  USING (user_id = (SELECT auth.uid()::text));

CREATE POLICY "Users can insert own sync runs"
  ON public.hb_sync_runs FOR INSERT TO authenticated
  WITH CHECK (user_id = (SELECT auth.uid()::text));

CREATE POLICY "Users can update own sync runs"
  ON public.hb_sync_runs FOR UPDATE TO authenticated
  USING (user_id = (SELECT auth.uid()::text))
  WITH CHECK (user_id = (SELECT auth.uid()::text));

CREATE POLICY "Users can delete own sync runs"
  ON public.hb_sync_runs FOR DELETE TO authenticated
  USING (user_id = (SELECT auth.uid()::text));

CREATE POLICY "Users can view their own bank accounts"
  ON public.hb_bank_accounts FOR SELECT
  USING (user_id = (SELECT auth.uid()::text));

CREATE POLICY "Users can insert their own bank accounts"
  ON public.hb_bank_accounts FOR INSERT
  WITH CHECK (user_id = (SELECT auth.uid()::text));

CREATE POLICY "Users can update their own bank accounts"
  ON public.hb_bank_accounts FOR UPDATE
  USING (user_id = (SELECT auth.uid()::text));

CREATE POLICY "Users can view their own transactions"
  ON public.hb_transactions FOR SELECT
  USING (user_id = (SELECT auth.uid()::text));

CREATE POLICY "Users can insert their own transactions"
  ON public.hb_transactions FOR INSERT
  WITH CHECK (user_id = (SELECT auth.uid()::text));

CREATE POLICY "Users can update their own transactions"
  ON public.hb_transactions FOR UPDATE
  USING (user_id = (SELECT auth.uid()::text));
