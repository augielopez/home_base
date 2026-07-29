-- Support app auth user ids (text) and fill keyword conditions for existing rules.

DROP POLICY IF EXISTS "Users can view their own categorization rules" ON public.hb_categorization_rules;
DROP POLICY IF EXISTS "Users can insert their own categorization rules" ON public.hb_categorization_rules;
DROP POLICY IF EXISTS "Users can update their own categorization rules" ON public.hb_categorization_rules;

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
    AND tc.table_name = 'hb_categorization_rules'
    AND tc.constraint_type = 'FOREIGN KEY'
    AND kcu.column_name = 'user_id'
  LIMIT 1;

  IF constraint_name IS NOT NULL THEN
    EXECUTE format('ALTER TABLE public.hb_categorization_rules DROP CONSTRAINT %I', constraint_name);
  END IF;
END $$;

ALTER TABLE public.hb_categorization_rules
  ALTER COLUMN user_id TYPE TEXT USING user_id::text;

CREATE POLICY "Users can view their own categorization rules"
  ON public.hb_categorization_rules FOR SELECT
  USING (user_id = (SELECT auth.uid()::text) OR created_by = 'SYSTEM' OR user_id IS NULL);

CREATE POLICY "Users can insert their own categorization rules"
  ON public.hb_categorization_rules FOR INSERT
  WITH CHECK (user_id = (SELECT auth.uid()::text) OR user_id IS NULL);

CREATE POLICY "Users can update their own categorization rules"
  ON public.hb_categorization_rules FOR UPDATE
  USING (user_id = (SELECT auth.uid()::text) OR created_by = 'SYSTEM' OR user_id IS NULL);

UPDATE public.hb_categorization_rules
SET rule_conditions = jsonb_build_object(
  'keywords', jsonb_build_array('DIRECT DEPOSIT', 'PAYROLL'),
  'fields', jsonb_build_array('description', 'name', 'merchant_name')
),
updated_at = NOW()
WHERE rule_type = 'keyword'
  AND lower(rule_name) = 'direct deposit';

UPDATE public.hb_categorization_rules
SET rule_conditions = jsonb_build_object(
  'keywords', jsonb_build_array('DEPOSIT', 'CHECK RECEIVED', 'MOBILE DEPOSIT', 'CASH DEPOSIT'),
  'fields', jsonb_build_array('description', 'name', 'merchant_name')
),
updated_at = NOW()
WHERE rule_type = 'keyword'
  AND lower(rule_name) = 'deposit';

UPDATE public.hb_categorization_rules
SET rule_conditions = jsonb_build_object(
  'keywords', jsonb_build_array('CHECK RECEIVED', 'CHECK'),
  'fields', jsonb_build_array('description', 'name', 'merchant_name')
),
updated_at = NOW()
WHERE rule_type = 'keyword'
  AND lower(rule_name) = 'check';

UPDATE public.hb_categorization_rules
SET rule_conditions = jsonb_build_object(
  'keywords', jsonb_build_array('INTEREST', 'INTEREST PAID', 'INTEREST CREDIT'),
  'fields', jsonb_build_array('description', 'name', 'merchant_name')
),
updated_at = NOW()
WHERE rule_type = 'keyword'
  AND lower(rule_name) = 'interest';

UPDATE public.hb_categorization_rules
SET rule_conditions = jsonb_build_object(
  'keywords', jsonb_build_array('TRANSFER', 'ZELLE', 'VENMO', 'WIRE TRANSFER'),
  'fields', jsonb_build_array('description', 'name', 'merchant_name')
),
updated_at = NOW()
WHERE rule_type = 'keyword'
  AND lower(rule_name) = 'transfer';

INSERT INTO public.hb_categorization_rules (
  user_id, rule_name, rule_type, rule_conditions, category_id, priority, is_active, created_by, updated_by
)
SELECT
  NULL,
  'Verizon Utilities',
  'keyword',
  jsonb_build_object(
    'keywords', jsonb_build_array('VERIZON'),
    'fields', jsonb_build_array('description', 'name', 'merchant_name')
  ),
  c.id,
  10,
  true,
  'SYSTEM',
  'SYSTEM'
FROM public.hb_transaction_categories c
WHERE c.name = 'Utilities'
  AND NOT EXISTS (
    SELECT 1 FROM public.hb_categorization_rules r
    WHERE r.rule_name = 'Verizon Utilities' AND r.created_by = 'SYSTEM'
  )
LIMIT 1;

INSERT INTO public.hb_categorization_rules (
  user_id, rule_name, rule_type, rule_conditions, category_id, priority, is_active, created_by, updated_by
)
SELECT
  NULL,
  'Amazon Shopping',
  'keyword',
  jsonb_build_object(
    'keywords', jsonb_build_array('AMAZON', 'AMZN'),
    'fields', jsonb_build_array('description', 'name', 'merchant_name')
  ),
  c.id,
  11,
  true,
  'SYSTEM',
  'SYSTEM'
FROM public.hb_transaction_categories c
WHERE c.name = 'Online Shopping'
  AND NOT EXISTS (
    SELECT 1 FROM public.hb_categorization_rules r
    WHERE r.rule_name = 'Amazon Shopping' AND r.created_by = 'SYSTEM'
  )
LIMIT 1;

INSERT INTO public.hb_categorization_rules (
  user_id, rule_name, rule_type, rule_conditions, category_id, priority, is_active, created_by, updated_by
)
SELECT
  NULL,
  'Amazon Shopping',
  'keyword',
  jsonb_build_object(
    'keywords', jsonb_build_array('AMAZON', 'AMZN'),
    'fields', jsonb_build_array('description', 'name', 'merchant_name')
  ),
  c.id,
  11,
  true,
  'SYSTEM',
  'SYSTEM'
FROM public.hb_transaction_categories c
WHERE c.name = 'Shopping'
  AND NOT EXISTS (
    SELECT 1 FROM public.hb_categorization_rules r
    WHERE r.rule_name = 'Amazon Shopping' AND r.created_by = 'SYSTEM'
  )
LIMIT 1;
