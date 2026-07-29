-- Extend existing hb_* financial tables for SimpleFIN sync instead of parallel balance_base_* tables.
-- Local secret setup for syncing:
--   supabase secrets set SIMPLEFIN_ACCESS_URL="your_access_url_here"
--
-- Do not put SIMPLEFIN_ACCESS_URL in a Vite .env file.
-- Do not create VITE_SIMPLEFIN_ACCESS_URL.
-- The browser must never receive the SimpleFIN setup token or access URL.

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- SimpleFIN account identifiers on existing bank accounts table
ALTER TABLE hb_bank_accounts
  ADD COLUMN IF NOT EXISTS simplefin_account_id TEXT,
  ADD COLUMN IF NOT EXISTS external_source TEXT DEFAULT 'manual',
  ADD COLUMN IF NOT EXISTS metadata JSONB DEFAULT '{}'::jsonb;

-- Prefer a non-partial unique index so PostgREST/upsert conflict targets work reliably.
DROP INDEX IF EXISTS idx_hb_bank_accounts_user_simplefin;
CREATE UNIQUE INDEX IF NOT EXISTS idx_hb_bank_accounts_user_simplefin
  ON hb_bank_accounts (user_id, simplefin_account_id);

-- Optional provider metadata on existing transactions table
ALTER TABLE hb_transactions
  ADD COLUMN IF NOT EXISTS source_metadata JSONB DEFAULT '{}'::jsonb;

-- Generic sync-run tracking for SimpleFIN and future providers.
-- user_id stores master_users.user_id as text (home_base app auth), not auth.users.
CREATE TABLE IF NOT EXISTS hb_sync_runs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id TEXT NOT NULL,
  sync_type TEXT NOT NULL,
  status TEXT NOT NULL,
  started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  finished_at TIMESTAMPTZ,
  error_message TEXT,
  records_processed INTEGER NOT NULL DEFAULT 0,
  metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_hb_sync_runs_user_id ON hb_sync_runs(user_id);
CREATE INDEX IF NOT EXISTS idx_hb_sync_runs_started_at ON hb_sync_runs(started_at DESC);

DROP TRIGGER IF EXISTS trg_hb_sync_runs_updated_at ON hb_sync_runs;
CREATE TRIGGER trg_hb_sync_runs_updated_at
BEFORE UPDATE ON hb_sync_runs
FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

ALTER TABLE hb_bank_accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE hb_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE hb_sync_runs ENABLE ROW LEVEL SECURITY;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE schemaname = 'public' AND tablename = 'hb_sync_runs' AND policyname = 'Users can select own sync runs'
  ) THEN
    CREATE POLICY "Users can select own sync runs"
    ON hb_sync_runs FOR SELECT TO authenticated
    USING (user_id = (SELECT auth.uid()::text));
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE schemaname = 'public' AND tablename = 'hb_sync_runs' AND policyname = 'Users can insert own sync runs'
  ) THEN
    CREATE POLICY "Users can insert own sync runs"
    ON hb_sync_runs FOR INSERT TO authenticated
    WITH CHECK (user_id = (SELECT auth.uid()::text));
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE schemaname = 'public' AND tablename = 'hb_sync_runs' AND policyname = 'Users can update own sync runs'
  ) THEN
    CREATE POLICY "Users can update own sync runs"
    ON hb_sync_runs FOR UPDATE TO authenticated
    USING (user_id = (SELECT auth.uid()::text))
    WITH CHECK (user_id = (SELECT auth.uid()::text));
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE schemaname = 'public' AND tablename = 'hb_sync_runs' AND policyname = 'Users can delete own sync runs'
  ) THEN
    CREATE POLICY "Users can delete own sync runs"
    ON hb_sync_runs FOR DELETE TO authenticated
    USING (user_id = (SELECT auth.uid()::text));
  END IF;
END $$;
