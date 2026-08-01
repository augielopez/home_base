-- Separate category provenance from bill-match provenance on hb_transactions.
-- category_match_method / category_confidence = how category_id was set
-- match_method / match_confidence / match_timestamp = how bill_id was set

alter table public.hb_transactions
  add column if not exists category_match_method text
    default 'unmatched';

alter table public.hb_transactions
  drop constraint if exists hb_transactions_category_match_method_check;

alter table public.hb_transactions
  add constraint hb_transactions_category_match_method_check
  check (
    category_match_method = any (
      array['unmatched'::text, 'manual'::text, 'auto'::text, 'ai'::text]
    )
  );

alter table public.hb_transactions
  add column if not exists recon_excluded boolean not null default false;

-- Move category provenance out of match_method when no bill is linked.
update public.hb_transactions
set
  category_match_method = case
    when category_id is null then 'unmatched'
    when lower(coalesce(match_method, 'unmatched')) in ('manual', 'auto', 'ai')
      then lower(match_method)
    else 'auto'
  end,
  match_method = 'unmatched',
  match_confidence = 0,
  match_timestamp = null
where bill_id is null
  and recon_excluded = false
  and (
    category_id is not null
    or lower(coalesce(match_method, 'unmatched')) in ('manual', 'auto', 'ai')
  );

-- Rows that already have a bill keep match_method for bill matching;
-- still seed category_match_method from category_id presence.
update public.hb_transactions
set category_match_method = case
  when category_id is null then 'unmatched'
  when lower(coalesce(category_match_method, 'unmatched')) = 'unmatched' then 'manual'
  else category_match_method
end
where bill_id is not null
  and category_id is not null
  and coalesce(category_match_method, 'unmatched') = 'unmatched';

comment on column public.hb_transactions.category_match_method is
  'How category_id was assigned: unmatched | manual | auto | ai';

comment on column public.hb_transactions.recon_excluded is
  'When true, transaction is hidden from Bills Recon unmatched queue without a bill_id';
