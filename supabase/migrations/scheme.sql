create sequence accounts_pk_seq
    as integer;

alter sequence accounts_pk_seq owner to postgres;

grant select, update, usage on sequence accounts_pk_seq to anon;

grant select, update, usage on sequence accounts_pk_seq to authenticated;

grant select, update, usage on sequence accounts_pk_seq to service_role;

create sequence bill_type_pk_seq;

alter sequence bill_type_pk_seq owner to postgres;

grant select, update, usage on sequence bill_type_pk_seq to anon;

grant select, update, usage on sequence bill_type_pk_seq to authenticated;

grant select, update, usage on sequence bill_type_pk_seq to service_role;

create sequence bills_pk_seq
    as integer;

alter sequence bills_pk_seq owner to postgres;

grant select, update, usage on sequence bills_pk_seq to anon;

grant select, update, usage on sequence bills_pk_seq to authenticated;

grant select, update, usage on sequence bills_pk_seq to service_role;

create sequence charge_code_pk_seq;

alter sequence charge_code_pk_seq owner to postgres;

grant select, update, usage on sequence charge_code_pk_seq to anon;

grant select, update, usage on sequence charge_code_pk_seq to authenticated;

grant select, update, usage on sequence charge_code_pk_seq to service_role;

create sequence history_tb_fidelity_transactions__pk_seq;

alter sequence history_tb_fidelity_transactions__pk_seq owner to postgres;

grant select, update, usage on sequence history_tb_fidelity_transactions__pk_seq to anon;

grant select, update, usage on sequence history_tb_fidelity_transactions__pk_seq to authenticated;

grant select, update, usage on sequence history_tb_fidelity_transactions__pk_seq to service_role;

create sequence logins_pk_seq
    as integer;

alter sequence logins_pk_seq owner to postgres;

grant select, update, usage on sequence logins_pk_seq to anon;

grant select, update, usage on sequence logins_pk_seq to authenticated;

grant select, update, usage on sequence logins_pk_seq to service_role;

create sequence owner_pk_seq;

alter sequence owner_pk_seq owner to postgres;

grant select, update, usage on sequence owner_pk_seq to anon;

grant select, update, usage on sequence owner_pk_seq to authenticated;

grant select, update, usage on sequence owner_pk_seq to service_role;

create sequence payment_methods_pk_seq
    as integer;

alter sequence payment_methods_pk_seq owner to postgres;

grant select, update, usage on sequence payment_methods_pk_seq to anon;

grant select, update, usage on sequence payment_methods_pk_seq to authenticated;

grant select, update, usage on sequence payment_methods_pk_seq to service_role;

create sequence payment_type_pk_seq;

alter sequence payment_type_pk_seq owner to postgres;

grant select, update, usage on sequence payment_type_pk_seq to anon;

grant select, update, usage on sequence payment_type_pk_seq to authenticated;

grant select, update, usage on sequence payment_type_pk_seq to service_role;

create sequence tb_first_tech_non_monthly_bills_pk_seq;

alter sequence tb_first_tech_non_monthly_bills_pk_seq owner to postgres;

grant select, update, usage on sequence tb_first_tech_non_monthly_bills_pk_seq to anon;

grant select, update, usage on sequence tb_first_tech_non_monthly_bills_pk_seq to authenticated;

grant select, update, usage on sequence tb_first_tech_non_monthly_bills_pk_seq to service_role;

create sequence type_bill_priority_id_seq
    as integer;

alter sequence type_bill_priority_id_seq owner to postgres;

grant select, update, usage on sequence type_bill_priority_id_seq to anon;

grant select, update, usage on sequence type_bill_priority_id_seq to authenticated;

grant select, update, usage on sequence type_bill_priority_id_seq to service_role;

create sequence us_bank_transactions_pk_seq;

alter sequence us_bank_transactions_pk_seq owner to postgres;

grant select, update, usage on sequence us_bank_transactions_pk_seq to anon;

grant select, update, usage on sequence us_bank_transactions_pk_seq to authenticated;

grant select, update, usage on sequence us_bank_transactions_pk_seq to service_role;

create sequence x_payment_bill_pk_seq
    as integer;

alter sequence x_payment_bill_pk_seq owner to postgres;

grant select, update, usage on sequence x_payment_bill_pk_seq to anon;

grant select, update, usage on sequence x_payment_bill_pk_seq to authenticated;

grant select, update, usage on sequence x_payment_bill_pk_seq to service_role;

create sequence master_users_user_id_seq;

alter sequence master_users_user_id_seq owner to postgres;

grant select, update, usage on sequence master_users_user_id_seq to anon;

grant select, update, usage on sequence master_users_user_id_seq to authenticated;

grant select, update, usage on sequence master_users_user_id_seq to service_role;

create sequence master_users_user_id_seq1;

alter sequence master_users_user_id_seq1 owner to postgres;

grant select, update, usage on sequence master_users_user_id_seq1 to anon;

grant select, update, usage on sequence master_users_user_id_seq1 to authenticated;

grant select, update, usage on sequence master_users_user_id_seq1 to service_role;

-- Unknown how to generate base type type

alter type gtrgm owner to supabase_admin;

-- Unknown how to generate base type type

alter type vector owner to supabase_admin;

-- Unknown how to generate base type type

alter type halfvec owner to supabase_admin;

-- Unknown how to generate base type type

alter type sparsevec owner to supabase_admin;

create type phone_carrier_enum as enum ('vtext.com', 'tmomail.net', 'txt.att.net', 'messaging.sprintpcs.com', 'sms.myboostmobile.com');

alter type phone_carrier_enum owner to postgres;

create type session_status as enum ('not_started', 'active', 'completed', 'paused');

alter type session_status owner to postgres;

create type task_type as enum ('parent', 'child');

alter type task_type owner to postgres;

create type task_status as enum ('not_started', 'active', 'completed', 'skipped');

alter type task_status owner to postgres;

create type task_event_type as enum ('imported', 'started', 'extended', 'completed_early', 'completed_on_time', 'auto_advanced', 'skipped', 'resumed');

alter type task_event_type owner to postgres;

create table bank_account_names
(
    id        uuid default gen_random_uuid() not null
        primary key,
    name      text                           not null,
    bank_name text                           not null
);

alter table bank_account_names
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on bank_account_names to anon;

grant delete, insert, references, select, trigger, truncate, update on bank_account_names to authenticated;

grant delete, insert, references, select, trigger, truncate, update on bank_account_names to service_role;

create table combined_transactions
(
    id               uuid                     default gen_random_uuid() not null
        primary key,
    account_id       uuid
        references bank_account_names
            on delete cascade,
    date             date                                               not null,
    amount           numeric                                            not null,
    description      text,
    source_file_name text,
    tags             text[],
    created_at       timestamp with time zone default now(),
    updated_at       timestamp with time zone default now()
);

alter table combined_transactions
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on combined_transactions to anon;

grant delete, insert, references, select, trigger, truncate, update on combined_transactions to authenticated;

grant delete, insert, references, select, trigger, truncate, update on combined_transactions to service_role;

create table tags
(
    id   uuid default gen_random_uuid() not null
        primary key,
    name text                           not null
        unique
);

alter table tags
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on tags to anon;

grant delete, insert, references, select, trigger, truncate, update on tags to authenticated;

grant delete, insert, references, select, trigger, truncate, update on tags to service_role;

create table transaction_tags
(
    transaction_id uuid not null
        references combined_transactions,
    tag_id         uuid not null
        references tags,
    primary key (transaction_id, tag_id)
);

alter table transaction_tags
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on transaction_tags to anon;

grant delete, insert, references, select, trigger, truncate, update on transaction_tags to authenticated;

grant delete, insert, references, select, trigger, truncate, update on transaction_tags to service_role;

create table tb_accounts
(
    pk        integer default nextval('accounts_pk_seq'::regclass) not null
        constraint accounts_pkey
            primary key,
    name      varchar(255)                                         not null,
    url       text                                                 not null,
    ownerpk   integer                                              not null,
    loginpk   integer                                              not null,
    updatedby varchar(255)                                         not null,
    updatedon date                                                 not null,
    createdby varchar(255)                                         not null,
    createdon date                                                 not null
);

alter table tb_accounts
    owner to postgres;

alter sequence accounts_pk_seq owned by tb_accounts.pk;

create policy "Public accounts are viewable by everyone." on tb_accounts
    as permissive
    for select
    using true;

create policy allow_insert_account on tb_accounts
    as permissive
    for insert
    with check true;

grant delete, insert, references, select, trigger, truncate, update on tb_accounts to anon;

grant delete, insert, references, select, trigger, truncate, update on tb_accounts to authenticated;

grant delete, insert, references, select, trigger, truncate, update on tb_accounts to service_role;

create table tb_type_bill
(
    pk        integer generated always as identity
        constraint bill_type_pkey
            primary key,
    name      text,
    updatedby text,
    updatedon date,
    createdby text,
    createdon date
);

alter table tb_type_bill
    owner to postgres;

alter sequence bill_type_pk_seq owned by tb_type_bill.pk;

create policy "Public owners are viewable by everyone." on tb_type_bill
    as permissive
    for select
    using true;

grant delete, insert, references, select, trigger, truncate, update on tb_type_bill to anon;

grant delete, insert, references, select, trigger, truncate, update on tb_type_bill to authenticated;

grant delete, insert, references, select, trigger, truncate, update on tb_type_bill to service_role;

create table tb_bills
(
    pk                         integer default nextval('bills_pk_seq'::regclass) not null
        constraint bills_pkey
            primary key,
    accountfk                  integer                                           not null,
    priorityfk                 integer                                           not null,
    isactive                   boolean                                           not null,
    transactiondescription     text,
    frequencyfk                integer                                           not null,
    duedate                    text,
    creditlimit                numeric,
    balance                    numeric,
    payment                    numeric,
    lastpaid                   text,
    isfixed                    boolean                                           not null,
    typefk                     integer                                           not null,
    paymenttypefk              integer                                           not null,
    sql                        text,
    isincludedinmonthlypayment boolean                                           not null,
    notes                      text,
    updatedby                  varchar(255)                                      not null,
    updatedon                  text                                              not null,
    createdby                  varchar(255),
    createdon                  text                                              not null
);

alter table tb_bills
    owner to postgres;

alter sequence bills_pk_seq owned by tb_bills.pk;

create table bill_reconciliation_history
(
    id              uuid                     default gen_random_uuid() not null
        primary key,
    bill_pk         integer
        references tb_bills
            on delete cascade,
    transaction_id  uuid
        references combined_transactions,
    match_status    text
        constraint bill_reconciliation_history_match_status_check
            check (match_status = ANY (ARRAY ['paid'::text, 'unpaid'::text, 'partial'::text, 'overpaid'::text])),
    match_type      text
        constraint bill_reconciliation_history_match_type_check
            check (match_type = ANY (ARRAY ['auto'::text, 'manual'::text])),
    matched_at      timestamp with time zone default now(),
    expected_amount numeric,
    actual_amount   numeric,
    month_start     date                                               not null,
    matched_by      uuid,
    notes           text
);

alter table bill_reconciliation_history
    owner to postgres;

create index idx_bill_recon_month
    on bill_reconciliation_history (month_start, bill_pk);

grant delete, insert, references, select, trigger, truncate, update on bill_reconciliation_history to anon;

grant delete, insert, references, select, trigger, truncate, update on bill_reconciliation_history to authenticated;

grant delete, insert, references, select, trigger, truncate, update on bill_reconciliation_history to service_role;

create policy "Public bills are viewable by everyone." on tb_bills
    as permissive
    for select
    using true;

create policy allow_insert_bill on tb_bills
    as permissive
    for insert
    with check true;

grant delete, insert, references, select, trigger, truncate, update on tb_bills to anon;

grant delete, insert, references, select, trigger, truncate, update on tb_bills to authenticated;

grant delete, insert, references, select, trigger, truncate, update on tb_bills to service_role;

create table tb_type_bill_frequency
(
    pk        integer generated always as identity
        constraint charge_code_pkey
            primary key,
    name      text,
    updatedby text,
    updatedon date,
    createdby text,
    createdon date
);

alter table tb_type_bill_frequency
    owner to postgres;

alter sequence charge_code_pk_seq owned by tb_type_bill_frequency.pk;

create policy "Public owners are viewable by everyone." on tb_type_bill_frequency
    as permissive
    for select
    using true;

grant delete, insert, references, select, trigger, truncate, update on tb_type_bill_frequency to anon;

grant delete, insert, references, select, trigger, truncate, update on tb_type_bill_frequency to authenticated;

grant delete, insert, references, select, trigger, truncate, update on tb_type_bill_frequency to service_role;

create table history_recon
(
    account_name               text,
    sql                        text,
    transaction_desc           text,
    transaction_date           date,
    due_date                   text,
    transaction_amount         numeric,
    expected_amount            numeric,
    source                     text,
    isfixed                    boolean,
    accountpk                  integer,
    ownerpk                    integer,
    loginpk                    integer,
    billpk                     integer,
    priorityfk                 integer,
    frequencyfk                integer,
    typefk                     integer,
    paymenttypefk              integer,
    isincludedinmonthlypayment boolean,
    isactive                   boolean
);

alter table history_recon
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on history_recon to anon;

grant delete, insert, references, select, trigger, truncate, update on history_recon to authenticated;

grant delete, insert, references, select, trigger, truncate, update on history_recon to service_role;

create table history_tb_fidelity_transactions
(
    run_date         date,
    action           varchar(100),
    symbol           varchar(50),
    description      varchar(100),
    type             varchar(20),
    quantity         integer,
    price            numeric(10, 2),
    commission       numeric(10, 2),
    fees             numeric(10, 2),
    accrued_interest numeric(10, 2),
    amount           numeric(10, 2),
    cash_balance     varchar(50),
    settlement_date  date,
    pk               integer generated by default as identity
        constraint history_tb_fidelity_transactions__pkey
            primary key
        constraint history_tb_fidelity_transactions__pk_key
            unique
);

comment on table history_tb_fidelity_transactions is 'This is a duplicate of tb_fidelity_transactions';

alter table history_tb_fidelity_transactions
    owner to postgres;

alter sequence history_tb_fidelity_transactions__pk_seq owned by history_tb_fidelity_transactions.pk;

grant delete, insert, references, select, trigger, truncate, update on history_tb_fidelity_transactions to anon;

grant delete, insert, references, select, trigger, truncate, update on history_tb_fidelity_transactions to authenticated;

grant delete, insert, references, select, trigger, truncate, update on history_tb_fidelity_transactions to service_role;

create table history_tb_first_tech_transactions
(
    transaction_id       text,
    posting_date         date,
    effective_date       date,
    transaction_type     text,
    amount               double precision,
    check_number         text,
    reference_number     bigint,
    description          text,
    transaction_category text,
    type                 text,
    balance              double precision,
    memo                 text,
    extended_description text,
    source               text,
    pk                   integer generated by default as identity
        primary key
        unique
);

comment on table history_tb_first_tech_transactions is 'This is a duplicate of tb_first_tech_augie';

comment on column history_tb_first_tech_transactions.source is 'source of data';

alter table history_tb_first_tech_transactions
    owner to postgres;

grant select, update, usage on sequence history_tb_first_tech_transactions_pk_seq to anon;

grant select, update, usage on sequence history_tb_first_tech_transactions_pk_seq to authenticated;

grant select, update, usage on sequence history_tb_first_tech_transactions_pk_seq to service_role;

grant delete, insert, references, select, trigger, truncate, update on history_tb_first_tech_transactions to anon;

grant delete, insert, references, select, trigger, truncate, update on history_tb_first_tech_transactions to authenticated;

grant delete, insert, references, select, trigger, truncate, update on history_tb_first_tech_transactions to service_role;

create table history_tb_manual_transactions
(
    pk     bigint,
    date   date,
    name   text,
    amount numeric,
    source text
);

alter table history_tb_manual_transactions
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on history_tb_manual_transactions to anon;

grant delete, insert, references, select, trigger, truncate, update on history_tb_manual_transactions to authenticated;

grant delete, insert, references, select, trigger, truncate, update on history_tb_manual_transactions to service_role;

create table history_tb_us_bank_transactions
(
    date        date,
    transaction text,
    name        text,
    memo        text,
    amount      numeric,
    pk          integer generated by default as identity
        primary key
        unique
);

alter table history_tb_us_bank_transactions
    owner to postgres;

grant select, update, usage on sequence history_tb_us_bank_transactions_pk_seq to anon;

grant select, update, usage on sequence history_tb_us_bank_transactions_pk_seq to authenticated;

grant select, update, usage on sequence history_tb_us_bank_transactions_pk_seq to service_role;

grant delete, insert, references, select, trigger, truncate, update on history_tb_us_bank_transactions to anon;

grant delete, insert, references, select, trigger, truncate, update on history_tb_us_bank_transactions to authenticated;

grant delete, insert, references, select, trigger, truncate, update on history_tb_us_bank_transactions to service_role;

create table tb_logins
(
    pk        integer default nextval('logins_pk_seq'::regclass) not null
        constraint logins_pkey
            primary key,
    username  varchar(255)                                       not null,
    password  text                                               not null,
    updatedby varchar(255)                                       not null,
    updatedon text                                               not null,
    createdby varchar(255)                                       not null,
    createdon text                                               not null
);

alter table tb_logins
    owner to postgres;

alter sequence logins_pk_seq owned by tb_logins.pk;

create policy "Public bills are viewable by everyone." on tb_logins
    as permissive
    for select
    using true;

create policy allow_insert_bill on tb_logins
    as permissive
    for insert
    with check true;

grant delete, insert, references, select, trigger, truncate, update on tb_logins to anon;

grant delete, insert, references, select, trigger, truncate, update on tb_logins to authenticated;

grant delete, insert, references, select, trigger, truncate, update on tb_logins to service_role;

create table tb_owner
(
    pk        integer generated always as identity
        constraint owner_pkey
            primary key,
    name      text,
    updatedby text,
    updatedon date,
    createdby text,
    createdon date
);

alter table tb_owner
    owner to postgres;

alter sequence owner_pk_seq owned by tb_owner.pk;

create policy "Public owners are viewable by everyone." on tb_owner
    as permissive
    for select
    using true;

grant delete, insert, references, select, trigger, truncate, update on tb_owner to anon;

grant delete, insert, references, select, trigger, truncate, update on tb_owner to authenticated;

grant delete, insert, references, select, trigger, truncate, update on tb_owner to service_role;

create table tb_type_payment_methods
(
    pk        integer default nextval('payment_methods_pk_seq'::regclass) not null
        constraint payment_methods_pkey
            primary key,
    name      varchar(255)                                                not null,
    updatedby text,
    updatedon date,
    createdby text,
    createdon date
);

alter table tb_type_payment_methods
    owner to postgres;

alter sequence payment_methods_pk_seq owned by tb_type_payment_methods.pk;

grant delete, insert, references, select, trigger, truncate, update on tb_type_payment_methods to anon;

grant delete, insert, references, select, trigger, truncate, update on tb_type_payment_methods to authenticated;

grant delete, insert, references, select, trigger, truncate, update on tb_type_payment_methods to service_role;

create table tb_type_payment
(
    pk        integer generated always as identity
        constraint payment_type_pkey
            primary key,
    name      text,
    isactive  boolean,
    updatedby text,
    updatedon date,
    createdby text,
    createdon date,
    ownerfk   integer
        constraint type_payment_ownerfk_fkey
            references tb_owner
);

alter table tb_type_payment
    owner to postgres;

alter sequence payment_type_pk_seq owned by tb_type_payment.pk;

create policy "Public owners are viewable by everyone." on tb_type_payment
    as permissive
    for select
    using true;

grant delete, insert, references, select, trigger, truncate, update on tb_type_payment to anon;

grant delete, insert, references, select, trigger, truncate, update on tb_type_payment to authenticated;

grant delete, insert, references, select, trigger, truncate, update on tb_type_payment to service_role;

create table profiles
(
    id         uuid not null
        primary key
        references ??? ()
        on delete cascade,
    updated_at timestamp with time zone,
    username   text
        unique
        constraint username_length
            check (char_length(username) >= 3),
    full_name  text,
    avatar_url text,
    website    text
);

alter table profiles
    owner to postgres;

create policy "Public profiles are viewable by everyone." on profiles
    as permissive
    for select
    using true;

create policy "Users can insert their own profile." on profiles
    as permissive
    for insert
    with check (auth.uid() = id);

create policy "Users can update own profile." on profiles
    as permissive
    for update
    using (auth.uid() = id);

grant delete, insert, references, select, trigger, truncate, update on profiles to anon;

grant delete, insert, references, select, trigger, truncate, update on profiles to authenticated;

grant delete, insert, references, select, trigger, truncate, update on profiles to service_role;

create table raw_transactions_fidelity_cash
(
    id               serial
        primary key,
    run_date         text,
    action           text,
    symbol           text,
    description      text,
    type             text,
    quantity         text,
    price            text,
    commission       text,
    fees             text,
    accrued_interest text,
    amount           text,
    cash_balance     text,
    settlement_date  text,
    source_file_name text
);

alter table raw_transactions_fidelity_cash
    owner to postgres;

grant select, update, usage on sequence raw_transactions_fidelity_cash_id_seq to anon;

grant select, update, usage on sequence raw_transactions_fidelity_cash_id_seq to authenticated;

grant select, update, usage on sequence raw_transactions_fidelity_cash_id_seq to service_role;

grant delete, insert, references, select, trigger, truncate, update on raw_transactions_fidelity_cash to anon;

grant delete, insert, references, select, trigger, truncate, update on raw_transactions_fidelity_cash to authenticated;

grant delete, insert, references, select, trigger, truncate, update on raw_transactions_fidelity_cash to service_role;

create table raw_transactions_first_tech
(
    id                   serial
        primary key,
    posting_date         text,
    effective_date       text,
    transaction_type     text,
    amount               text,
    reference_number     text,
    description          text,
    transaction_category text,
    type                 text,
    balance              text,
    extended_description text,
    source_file_name     text
);

alter table raw_transactions_first_tech
    owner to postgres;

grant select, update, usage on sequence raw_transactions_first_tech_id_seq to anon;

grant select, update, usage on sequence raw_transactions_first_tech_id_seq to authenticated;

grant select, update, usage on sequence raw_transactions_first_tech_id_seq to service_role;

grant delete, insert, references, select, trigger, truncate, update on raw_transactions_first_tech to anon;

grant delete, insert, references, select, trigger, truncate, update on raw_transactions_first_tech to authenticated;

grant delete, insert, references, select, trigger, truncate, update on raw_transactions_first_tech to service_role;

create table raw_transactions_us_bank_credit
(
    id               serial
        primary key,
    date             text,
    transaction      text,
    name             text,
    memo             text,
    amount           text,
    source_file_name text
);

alter table raw_transactions_us_bank_credit
    owner to postgres;

grant select, update, usage on sequence raw_transactions_us_bank_credit_id_seq to anon;

grant select, update, usage on sequence raw_transactions_us_bank_credit_id_seq to authenticated;

grant select, update, usage on sequence raw_transactions_us_bank_credit_id_seq to service_role;

grant delete, insert, references, select, trigger, truncate, update on raw_transactions_us_bank_credit to anon;

grant delete, insert, references, select, trigger, truncate, update on raw_transactions_us_bank_credit to authenticated;

grant delete, insert, references, select, trigger, truncate, update on raw_transactions_us_bank_credit to service_role;

create table stone_hill_tax_deductables
(
    pk           bigint not null
        primary key
        unique,
    posted_date  text,
    amount       double precision,
    check_number text,
    description  text
);

alter table stone_hill_tax_deductables
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on stone_hill_tax_deductables to anon;

grant delete, insert, references, select, trigger, truncate, update on stone_hill_tax_deductables to authenticated;

grant delete, insert, references, select, trigger, truncate, update on stone_hill_tax_deductables to service_role;

create table tb_emails
(
    pk               text                     not null
        primary key,
    attachment_count integer                  not null,
    bcc              text                     not null,
    cc               text                     not null,
    date             timestamp with time zone not null,
    "from"           text                     not null,
    html_body        text,
    message_id       text                     not null,
    subject          text                     not null,
    text_body        text,
    "to"             text                     not null,
    user_name        text,
    domain           text
);

alter table tb_emails
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on tb_emails to anon;

grant delete, insert, references, select, trigger, truncate, update on tb_emails to authenticated;

grant delete, insert, references, select, trigger, truncate, update on tb_emails to service_role;

create table tb_error_logs
(
    id            serial
        primary key,
    method_name   text not null,
    error_message text not null,
    created_at    timestamp default CURRENT_TIMESTAMP
);

alter table tb_error_logs
    owner to postgres;

grant select, update, usage on sequence tb_error_logs_id_seq to anon;

grant select, update, usage on sequence tb_error_logs_id_seq to authenticated;

grant select, update, usage on sequence tb_error_logs_id_seq to service_role;

grant delete, insert, references, select, trigger, truncate, update on tb_error_logs to anon;

grant delete, insert, references, select, trigger, truncate, update on tb_error_logs to authenticated;

grant delete, insert, references, select, trigger, truncate, update on tb_error_logs to service_role;

create table tb_fidelity_transactions
(
    run_date         date,
    action           varchar(100),
    symbol           varchar(50),
    description      varchar(100),
    type             varchar(20),
    quantity         integer,
    price            numeric(10, 2),
    commission       numeric(10, 2),
    fees             numeric(10, 2),
    accrued_interest numeric(10, 2),
    amount           numeric(10, 2),
    cash_balance     varchar(50),
    settlement_date  date,
    pk               integer generated by default as identity
        primary key
        unique
);

alter table tb_fidelity_transactions
    owner to postgres;

grant select, update, usage on sequence tb_fidelity_transactions_pk_seq to anon;

grant select, update, usage on sequence tb_fidelity_transactions_pk_seq to authenticated;

grant select, update, usage on sequence tb_fidelity_transactions_pk_seq to service_role;

grant delete, insert, references, select, trigger, truncate, update on tb_fidelity_transactions to anon;

grant delete, insert, references, select, trigger, truncate, update on tb_fidelity_transactions to authenticated;

grant delete, insert, references, select, trigger, truncate, update on tb_fidelity_transactions to service_role;

create table tb_first_tech_augie
(
    transaction_id       text,
    posting_date         date,
    effective_date       date,
    transaction_type     text,
    amount               double precision,
    check_number         text,
    reference_number     bigint,
    description          text,
    transaction_category text,
    type                 text,
    balance              double precision,
    memo                 text,
    extended_description text,
    pk                   integer generated by default as identity
        primary key
        unique
);

comment on table tb_first_tech_augie is 'This is a duplicate of first_tech_melissa';

alter table tb_first_tech_augie
    owner to postgres;

grant select, update, usage on sequence tb_first_tech_augie_pk_seq to anon;

grant select, update, usage on sequence tb_first_tech_augie_pk_seq to authenticated;

grant select, update, usage on sequence tb_first_tech_augie_pk_seq to service_role;

grant delete, insert, references, select, trigger, truncate, update on tb_first_tech_augie to anon;

grant delete, insert, references, select, trigger, truncate, update on tb_first_tech_augie to authenticated;

grant delete, insert, references, select, trigger, truncate, update on tb_first_tech_augie to service_role;

create table tb_first_tech_melissa
(
    transaction_id       text,
    posting_date         date,
    effective_date       date,
    transaction_type     text,
    amount               double precision,
    check_number         text,
    reference_number     bigint,
    description          text,
    transaction_category text,
    type                 text,
    balance              double precision,
    memo                 text,
    extended_description text,
    pk                   integer generated by default as identity
        primary key
        unique
);

alter table tb_first_tech_melissa
    owner to postgres;

grant select, update, usage on sequence tb_first_tech_melissa_pk_seq to anon;

grant select, update, usage on sequence tb_first_tech_melissa_pk_seq to authenticated;

grant select, update, usage on sequence tb_first_tech_melissa_pk_seq to service_role;

grant delete, insert, references, select, trigger, truncate, update on tb_first_tech_melissa to anon;

grant delete, insert, references, select, trigger, truncate, update on tb_first_tech_melissa to authenticated;

grant delete, insert, references, select, trigger, truncate, update on tb_first_tech_melissa to service_role;

create table tb_first_tech_non_monthly
(
    transaction_id       text,
    posting_date         date,
    effective_date       date,
    transaction_type     text,
    amount               double precision,
    check_number         text,
    reference_number     bigint,
    description          text,
    transaction_category text,
    type                 text,
    balance              double precision,
    memo                 text,
    extended_description text,
    pk                   integer generated by default as identity
        constraint tb_first_tech_non_monthly_bills_pkey
            primary key
        constraint tb_first_tech_non_monthly_bills_pk_key
            unique
);

alter table tb_first_tech_non_monthly
    owner to postgres;

alter sequence tb_first_tech_non_monthly_bills_pk_seq owned by tb_first_tech_non_monthly.pk;

grant delete, insert, references, select, trigger, truncate, update on tb_first_tech_non_monthly to anon;

grant delete, insert, references, select, trigger, truncate, update on tb_first_tech_non_monthly to authenticated;

grant delete, insert, references, select, trigger, truncate, update on tb_first_tech_non_monthly to service_role;

create table tb_job_applications
(
    pk                   serial
        primary key,
    company_name         text not null,
    job_title            text not null,
    job_location         text,
    job_posting_link     text,
    job_source           text,
    date_saved           date,
    date_applied         date,
    application_status   text,
    follow_up_date       date,
    contact_person       text,
    contact_email        text,
    application_notes    text,
    interview_rounds     integer,
    interview_dates      date[],
    interview_feedback   text,
    offer_received       boolean,
    salary_offered       numeric(10, 2),
    additional_perks     text,
    job_accepted         boolean,
    reason_for_declining text,
    created_at           timestamp default now()
);

alter table tb_job_applications
    owner to postgres;

grant select, update, usage on sequence tb_job_applications_pk_seq to anon;

grant select, update, usage on sequence tb_job_applications_pk_seq to authenticated;

grant select, update, usage on sequence tb_job_applications_pk_seq to service_role;

grant delete, insert, references, select, trigger, truncate, update on tb_job_applications to anon;

grant delete, insert, references, select, trigger, truncate, update on tb_job_applications to authenticated;

grant delete, insert, references, select, trigger, truncate, update on tb_job_applications to service_role;

create table tb_july_transactions
(
    date   date,
    name   text,
    amount numeric,
    source text
);

alter table tb_july_transactions
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on tb_july_transactions to anon;

grant delete, insert, references, select, trigger, truncate, update on tb_july_transactions to authenticated;

grant delete, insert, references, select, trigger, truncate, update on tb_july_transactions to service_role;

create table tb_manual_transactions
(
    pk     bigint generated by default as identity
        primary key,
    date   date not null,
    name   text,
    amount numeric,
    source text
);

alter table tb_manual_transactions
    owner to postgres;

grant select, update, usage on sequence tb_manual_transactions_pk_seq to anon;

grant select, update, usage on sequence tb_manual_transactions_pk_seq to authenticated;

grant select, update, usage on sequence tb_manual_transactions_pk_seq to service_role;

grant delete, insert, references, select, trigger, truncate, update on tb_manual_transactions to anon;

grant delete, insert, references, select, trigger, truncate, update on tb_manual_transactions to authenticated;

grant delete, insert, references, select, trigger, truncate, update on tb_manual_transactions to service_role;

create table tb_month_recon
(
    account_name               text,
    sql                        text,
    transaction_desc           text,
    transaction_date           date,
    due_date                   text,
    transaction_amount         numeric,
    expected_amount            numeric,
    source                     text,
    isfixed                    boolean,
    accountpk                  integer,
    ownerpk                    integer,
    loginpk                    integer,
    billpk                     integer,
    priorityfk                 integer,
    frequencyfk                integer,
    typefk                     integer,
    paymenttypefk              integer,
    isincludedinmonthlypayment boolean,
    isactive                   boolean
);

alter table tb_month_recon
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on tb_month_recon to anon;

grant delete, insert, references, select, trigger, truncate, update on tb_month_recon to authenticated;

grant delete, insert, references, select, trigger, truncate, update on tb_month_recon to service_role;

create table tb_recon
(
    account_name               text,
    sql                        text,
    due_date                   text,
    expected_amount            numeric,
    isfixed                    boolean,
    accountpk                  integer,
    ownerpk                    integer,
    loginpk                    integer,
    billpk                     integer,
    priorityfk                 integer,
    frequencyfk                integer,
    typefk                     integer,
    paymenttypefk              integer,
    isincludedinmonthlypayment boolean,
    isactive                   boolean,
    pk                         bigint generated by default as identity
        primary key
        unique
);

alter table tb_recon
    owner to postgres;

grant select, update, usage on sequence tb_recon_pk_seq to anon;

grant select, update, usage on sequence tb_recon_pk_seq to authenticated;

grant select, update, usage on sequence tb_recon_pk_seq to service_role;

grant delete, insert, references, select, trigger, truncate, update on tb_recon to anon;

grant delete, insert, references, select, trigger, truncate, update on tb_recon to authenticated;

grant delete, insert, references, select, trigger, truncate, update on tb_recon to service_role;

create table tb_type_bill_priority
(
    pk          integer   default nextval('type_bill_priority_id_seq'::regclass) not null
        constraint type_bill_priority_pkey
            primary key,
    name        varchar(50)                                                      not null,
    description text                                                             not null,
    updatedby   varchar(50),
    updatedon   timestamp default CURRENT_TIMESTAMP,
    createdby   varchar(50),
    createdon   timestamp default CURRENT_TIMESTAMP
);

alter table tb_type_bill_priority
    owner to postgres;

alter sequence type_bill_priority_id_seq owned by tb_type_bill_priority.pk;

grant delete, insert, references, select, trigger, truncate, update on tb_type_bill_priority to anon;

grant delete, insert, references, select, trigger, truncate, update on tb_type_bill_priority to authenticated;

grant delete, insert, references, select, trigger, truncate, update on tb_type_bill_priority to service_role;

create table tb_us_bank_transactions
(
    date        date,
    transaction text,
    name        text,
    memo        text,
    amount      numeric,
    pk          integer generated by default as identity
        constraint us_bank_transactions_pkey
            primary key
        constraint us_bank_transactions_pk_key
            unique
);

alter table tb_us_bank_transactions
    owner to postgres;

alter sequence us_bank_transactions_pk_seq owned by tb_us_bank_transactions.pk;

grant delete, insert, references, select, trigger, truncate, update on tb_us_bank_transactions to anon;

grant delete, insert, references, select, trigger, truncate, update on tb_us_bank_transactions to authenticated;

grant delete, insert, references, select, trigger, truncate, update on tb_us_bank_transactions to service_role;

create table tb_x_payment_bill
(
    pk                   integer default nextval('x_payment_bill_pk_seq'::regclass) not null
        constraint x_payment_bill_pkey
            primary key,
    paymenttypemethod_pk integer                                                    not null,
    bill_pk              integer                                                    not null,
    updatedby            text,
    updatedon            date,
    createdby            text,
    createdon            date
);

alter table tb_x_payment_bill
    owner to postgres;

alter sequence x_payment_bill_pk_seq owned by tb_x_payment_bill.pk;

grant delete, insert, references, select, trigger, truncate, update on tb_x_payment_bill to anon;

grant delete, insert, references, select, trigger, truncate, update on tb_x_payment_bill to authenticated;

grant delete, insert, references, select, trigger, truncate, update on tb_x_payment_bill to service_role;

create table temporary_table
(
    transaction text,
    tag         text
);

alter table temporary_table
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on temporary_table to anon;

grant delete, insert, references, select, trigger, truncate, update on temporary_table to authenticated;

grant delete, insert, references, select, trigger, truncate, update on temporary_table to service_role;

create table transaction_history
(
    id                      uuid                     default gen_random_uuid() not null
        primary key,
    original_transaction_id uuid
        references combined_transactions,
    account_id              uuid,
    date                    date,
    amount                  numeric,
    description             text,
    tags                    text[],
    change_type             text
        constraint transaction_history_change_type_check
            check (change_type = ANY (ARRAY ['insert'::text, 'update'::text])),
    change_time             timestamp with time zone default now()
);

alter table transaction_history
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on transaction_history to anon;

grant delete, insert, references, select, trigger, truncate, update on transaction_history to authenticated;

grant delete, insert, references, select, trigger, truncate, update on transaction_history to service_role;

create table transaction_tag_history
(
    id             uuid                     default gen_random_uuid() not null
        primary key,
    transaction_id uuid
        references combined_transactions
            on delete cascade,
    tag_id         uuid
        references tags,
    action         text
        constraint transaction_tag_history_action_check
            check (action = ANY (ARRAY ['added'::text, 'removed'::text])),
    changed_by     uuid,
    changed_at     timestamp with time zone default now()
);

alter table transaction_tag_history
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on transaction_tag_history to anon;

grant delete, insert, references, select, trigger, truncate, update on transaction_tag_history to authenticated;

grant delete, insert, references, select, trigger, truncate, update on transaction_tag_history to service_role;

create table hb_bill_categories
(
    id          uuid                     default gen_random_uuid()                                            not null
        primary key,
    name        varchar(50)                                                                                   not null,
    description text,
    created_at  timestamp with time zone default (CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles'::text) not null,
    updated_at  timestamp with time zone default (CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles'::text) not null,
    created_by  varchar(50)              default 'SYSTEM'::character varying                                  not null,
    updated_by  varchar(50)              default 'SYSTEM'::character varying                                  not null
);

alter table hb_bill_categories
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on hb_bill_categories to anon;

grant delete, insert, references, select, trigger, truncate, update on hb_bill_categories to authenticated;

grant delete, insert, references, select, trigger, truncate, update on hb_bill_categories to service_role;

create table hb_bill_status_types
(
    id          uuid                     default gen_random_uuid()                                            not null
        primary key,
    name        varchar(50)                                                                                   not null
        constraint uk_bill_status_type_name
            unique,
    description text,
    created_at  timestamp with time zone default (CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles'::text) not null,
    updated_at  timestamp with time zone default (CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles'::text) not null,
    created_by  varchar(50)              default 'SYSTEM'::character varying                                  not null,
    updated_by  varchar(50)              default 'SYSTEM'::character varying                                  not null
);

alter table hb_bill_status_types
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on hb_bill_status_types to anon;

grant delete, insert, references, select, trigger, truncate, update on hb_bill_status_types to authenticated;

grant delete, insert, references, select, trigger, truncate, update on hb_bill_status_types to service_role;

create table hb_bill_types
(
    id          uuid                     default gen_random_uuid()                                            not null
        primary key,
    name        varchar(100)                                                                                  not null,
    description text,
    category_id uuid                                                                                          not null
        references hb_bill_categories,
    created_at  timestamp with time zone default (CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles'::text) not null,
    updated_at  timestamp with time zone default (CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles'::text) not null,
    created_by  varchar(50)              default 'SYSTEM'::character varying                                  not null,
    updated_by  varchar(50)              default 'SYSTEM'::character varying                                  not null
);

alter table hb_bill_types
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on hb_bill_types to anon;

grant delete, insert, references, select, trigger, truncate, update on hb_bill_types to authenticated;

grant delete, insert, references, select, trigger, truncate, update on hb_bill_types to service_role;

create table hb_frequency_types
(
    id          uuid                     default gen_random_uuid()                                            not null
        primary key,
    name        text                                                                                          not null,
    description text,
    created_at  timestamp with time zone default (CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles'::text) not null,
    updated_at  timestamp with time zone default (CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles'::text) not null,
    created_by  varchar(50)              default 'SYSTEM'::character varying                                  not null,
    updated_by  varchar(50)              default 'SYSTEM'::character varying                                  not null
);

alter table hb_frequency_types
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on hb_frequency_types to anon;

grant delete, insert, references, select, trigger, truncate, update on hb_frequency_types to authenticated;

grant delete, insert, references, select, trigger, truncate, update on hb_frequency_types to service_role;

create table hb_logins
(
    id         uuid                     default gen_random_uuid()                                            not null
        primary key,
    username   text                                                                                          not null,
    password   text                                                                                          not null,
    created_at timestamp with time zone default (CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles'::text) not null,
    updated_at timestamp with time zone default (CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles'::text) not null,
    created_by varchar(50)              default 'SYSTEM'::character varying                                  not null,
    updated_by varchar(50)              default 'SYSTEM'::character varying                                  not null
);

alter table hb_logins
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on hb_logins to anon;

grant delete, insert, references, select, trigger, truncate, update on hb_logins to authenticated;

grant delete, insert, references, select, trigger, truncate, update on hb_logins to service_role;

create table hb_owner_types
(
    id          uuid                     default gen_random_uuid()                                            not null
        primary key,
    name        varchar(100)                                                                                  not null,
    description text,
    created_at  timestamp with time zone default (CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles'::text) not null,
    updated_at  timestamp with time zone default (CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles'::text) not null,
    created_by  varchar(50)              default 'SYSTEM'::character varying                                  not null,
    updated_by  varchar(50)              default 'SYSTEM'::character varying                                  not null
);

alter table hb_owner_types
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on hb_owner_types to anon;

grant delete, insert, references, select, trigger, truncate, update on hb_owner_types to authenticated;

grant delete, insert, references, select, trigger, truncate, update on hb_owner_types to service_role;

create table hb_payment_types
(
    id          uuid                     default gen_random_uuid()                                            not null
        primary key,
    name        varchar(100)                                                                                  not null,
    description text,
    is_active   boolean                  default true                                                         not null,
    created_at  timestamp with time zone default (CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles'::text) not null,
    updated_at  timestamp with time zone default (CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles'::text) not null,
    created_by  varchar(50)              default 'SYSTEM'::character varying                                  not null,
    updated_by  varchar(50)              default 'SYSTEM'::character varying                                  not null
);

alter table hb_payment_types
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on hb_payment_types to anon;

grant delete, insert, references, select, trigger, truncate, update on hb_payment_types to authenticated;

grant delete, insert, references, select, trigger, truncate, update on hb_payment_types to service_role;

create table hb_priority_types
(
    id          uuid                     default gen_random_uuid()                                            not null
        primary key,
    name        text                                                                                          not null,
    description text,
    created_at  timestamp with time zone default (CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles'::text) not null,
    updated_at  timestamp with time zone default (CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles'::text) not null,
    created_by  varchar(50)              default 'SYSTEM'::character varying                                  not null,
    updated_by  varchar(50)              default 'SYSTEM'::character varying                                  not null
);

alter table hb_priority_types
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on hb_priority_types to anon;

grant delete, insert, references, select, trigger, truncate, update on hb_priority_types to authenticated;

grant delete, insert, references, select, trigger, truncate, update on hb_priority_types to service_role;

create table hb_tags
(
    id         uuid                     default gen_random_uuid()                                            not null
        primary key,
    name       text                                                                                          not null,
    created_at timestamp with time zone default (CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles'::text) not null,
    updated_at timestamp with time zone default (CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles'::text) not null,
    created_by varchar(50)              default 'SYSTEM'::character varying                                  not null,
    updated_by varchar(50)              default 'SYSTEM'::character varying                                  not null
);

alter table hb_tags
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on hb_tags to anon;

grant delete, insert, references, select, trigger, truncate, update on hb_tags to authenticated;

grant delete, insert, references, select, trigger, truncate, update on hb_tags to service_role;

create table hb_bills
(
    id                             uuid                     default gen_random_uuid()                                            not null
        primary key,
    amount_due                     numeric(10, 2),
    due_date                       text,
    status                         text,
    description                    text,
    priority_id                    uuid,
    frequency_id                   uuid
        constraint fk_bills_frequency
            references hb_frequency_types,
    last_paid                      date,
    is_fixed_bill                  boolean                  default false,
    bill_type_id                   uuid,
    payment_type_id                uuid,
    tag_id                         uuid,
    is_included_in_monthly_payment boolean                  default true,
    created_at                     timestamp with time zone default (CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles'::text) not null,
    updated_at                     timestamp with time zone default (CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles'::text) not null,
    created_by                     varchar(50)              default 'SYSTEM'::character varying                                  not null,
    updated_by                     varchar(50)              default 'SYSTEM'::character varying                                  not null,
    bill_name                      text,
    account_id                     uuid
);

alter table hb_bills
    owner to postgres;

create index idx_bills_frequency_id
    on hb_bills (frequency_id);

grant delete, insert, references, select, trigger, truncate, update on hb_bills to anon;

grant delete, insert, references, select, trigger, truncate, update on hb_bills to authenticated;

grant delete, insert, references, select, trigger, truncate, update on hb_bills to service_role;

create table hb_accounts
(
    id            uuid                     default gen_random_uuid()                                            not null
        primary key,
    name          text                                                                                          not null,
    url           text,
    login_id      uuid
        constraint fk_login
            references hb_logins,
    owner_type_id uuid
        constraint fk_owner_type
            references hb_owner_types,
    created_at    timestamp with time zone default (CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles'::text) not null,
    updated_at    timestamp with time zone default (CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles'::text) not null,
    created_by    varchar(50)              default 'SYSTEM'::character varying                                  not null,
    updated_by    varchar(50)              default 'SYSTEM'::character varying                                  not null
);

alter table hb_accounts
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on hb_accounts to anon;

grant delete, insert, references, select, trigger, truncate, update on hb_accounts to authenticated;

grant delete, insert, references, select, trigger, truncate, update on hb_accounts to service_role;

create table hb_plaid_tokens
(
    id               uuid                     default gen_random_uuid() not null
        primary key,
    login_id         uuid                                               not null
        references hb_logins
            on delete cascade,
    access_token     text                                               not null,
    item_id          text                                               not null,
    institution_name text,
    created_at       timestamp with time zone default now(),
    created_by       uuid,
    updated_at       timestamp with time zone,
    updated_by       uuid
);

alter table hb_plaid_tokens
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on hb_plaid_tokens to anon;

grant delete, insert, references, select, trigger, truncate, update on hb_plaid_tokens to authenticated;

grant delete, insert, references, select, trigger, truncate, update on hb_plaid_tokens to service_role;

create table hb_card_types
(
    id          uuid                     default gen_random_uuid()                                            not null
        primary key,
    name        varchar(100)                                                                                  not null,
    description text,
    created_at  timestamp with time zone default (CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles'::text) not null,
    updated_at  timestamp with time zone default (CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles'::text) not null,
    created_by  varchar(50)              default 'SYSTEM'::character varying                                  not null,
    updated_by  varchar(50)              default 'SYSTEM'::character varying                                  not null
);

alter table hb_card_types
    owner to postgres;

create table hb_credit_cards
(
    id                    uuid                     default gen_random_uuid() not null
        primary key,
    account_id            uuid
        constraint fk_account
            references hb_accounts,
    cardholder_name       text,
    card_number_last_four integer,
    expiration_date       text,
    balance               numeric(10, 2)           default 0.00,
    credit_limit          numeric(10, 2),
    is_active             boolean                  default true,
    apr                   numeric(5, 2),
    purchase_rate         numeric(5, 2),
    cash_advance_rate     numeric(5, 2),
    balance_transfer_rate numeric(5, 2),
    annual_fee            numeric(10, 2),
    created_at            timestamp with time zone default (CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles'::text),
    updated_at            timestamp with time zone default (CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles'::text),
    created_by            varchar(50)              default 'SYSTEM'::character varying,
    updated_by            varchar(50)              default 'SYSTEM'::character varying,
    card_type_id          uuid
        constraint fk_card_type
            references hb_card_types
);

alter table hb_credit_cards
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on hb_credit_cards to anon;

grant delete, insert, references, select, trigger, truncate, update on hb_credit_cards to authenticated;

grant delete, insert, references, select, trigger, truncate, update on hb_credit_cards to service_role;

grant delete, insert, references, select, trigger, truncate, update on hb_card_types to anon;

grant delete, insert, references, select, trigger, truncate, update on hb_card_types to authenticated;

grant delete, insert, references, select, trigger, truncate, update on hb_card_types to service_role;

create table hb_warranty_types
(
    id          uuid                     default gen_random_uuid()                                            not null
        primary key,
    name        varchar(100)                                                                                  not null,
    description text,
    created_at  timestamp with time zone default (CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles'::text) not null,
    updated_at  timestamp with time zone default (CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles'::text) not null,
    created_by  varchar(50)              default 'SYSTEM'::character varying                                  not null,
    updated_by  varchar(50)              default 'SYSTEM'::character varying                                  not null
);

alter table hb_warranty_types
    owner to postgres;

create table hb_warranties
(
    id                   uuid                     default gen_random_uuid()                                            not null
        primary key,
    account_id           uuid                                                                                          not null
        constraint fk_account
            references hb_accounts,
    warranty_type_id     uuid                                                                                          not null
        constraint fk_warranty_type_id
            references hb_warranty_types,
    coverage_start       date                                                                                          not null,
    coverage_end         date                                                                                          not null,
    terms_and_conditions text,
    claim_procedure      text,
    created_at           timestamp with time zone default (CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles'::text) not null,
    updated_at           timestamp with time zone default (CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles'::text) not null,
    created_by           varchar(50)              default 'SYSTEM'::character varying                                  not null,
    updated_by           varchar(50)              default 'SYSTEM'::character varying                                  not null,
    provider             text
);

alter table hb_warranties
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on hb_warranties to anon;

grant delete, insert, references, select, trigger, truncate, update on hb_warranties to authenticated;

grant delete, insert, references, select, trigger, truncate, update on hb_warranties to service_role;

grant delete, insert, references, select, trigger, truncate, update on hb_warranty_types to anon;

grant delete, insert, references, select, trigger, truncate, update on hb_warranty_types to authenticated;

grant delete, insert, references, select, trigger, truncate, update on hb_warranty_types to service_role;

create table hb_plaid_items
(
    id               uuid                     default gen_random_uuid() not null
        primary key,
    user_id          uuid
        references ??? ()
        on delete cascade,
    item_id          text                                               not null,
    access_token     text                                               not null,
    institution_id   text                                               not null,
    institution_name text                                               not null,
    created_at       timestamp with time zone default now(),
    updated_at       timestamp with time zone default now(),
    unique (user_id, item_id)
);

alter table hb_plaid_items
    owner to postgres;

create index idx_plaid_items_user_id
    on hb_plaid_items (user_id);

create policy "Users can view their own plaid items" on hb_plaid_items
    as permissive
    for select
    using (auth.uid() = user_id);

create policy "Users can insert their own plaid items" on hb_plaid_items
    as permissive
    for insert
    with check (auth.uid() = user_id);

grant delete, insert, references, select, trigger, truncate, update on hb_plaid_items to anon;

grant delete, insert, references, select, trigger, truncate, update on hb_plaid_items to authenticated;

grant delete, insert, references, select, trigger, truncate, update on hb_plaid_items to service_role;

create table hb_plaid_accounts
(
    id                uuid                     default gen_random_uuid() not null
        primary key,
    user_id           uuid
        references ??? ()
        on delete cascade,
    item_id           text                                               not null,
    account_id        text                                               not null,
    name              text                                               not null,
    mask              text,
    type              text                                               not null,
    subtype           text,
    current_balance   numeric(15, 2),
    available_balance numeric(15, 2),
    iso_currency_code text,
    created_at        timestamp with time zone default now(),
    updated_at        timestamp with time zone default now(),
    unique (user_id, account_id)
);

alter table hb_plaid_accounts
    owner to postgres;

create index idx_plaid_accounts_user_id
    on hb_plaid_accounts (user_id);

create index idx_plaid_accounts_item_id
    on hb_plaid_accounts (item_id);

create policy "Users can view their own plaid accounts" on hb_plaid_accounts
    as permissive
    for select
    using (auth.uid() = user_id);

create policy "Users can insert their own plaid accounts" on hb_plaid_accounts
    as permissive
    for insert
    with check (auth.uid() = user_id);

grant delete, insert, references, select, trigger, truncate, update on hb_plaid_accounts to anon;

grant delete, insert, references, select, trigger, truncate, update on hb_plaid_accounts to authenticated;

grant delete, insert, references, select, trigger, truncate, update on hb_plaid_accounts to service_role;

create table hb_plaid_transactions
(
    id                        uuid                     default gen_random_uuid() not null
        primary key,
    user_id                   uuid
        references ??? ()
        on delete cascade,
    item_id                   text                                               not null,
    account_id                text                                               not null,
    transaction_id            text                                               not null,
    amount                    numeric(15, 2)                                     not null,
    date                      date                                               not null,
    name                      text                                               not null,
    merchant_name             text,
    category                  jsonb,
    category_id               text,
    pending                   boolean                  default false,
    payment_channel           text,
    personal_finance_category jsonb,
    location                  jsonb,
    iso_currency_code         text,
    unofficial_currency_code  text,
    created_at                timestamp with time zone default now(),
    unique (user_id, transaction_id)
);

alter table hb_plaid_transactions
    owner to postgres;

create index idx_plaid_transactions_user_id
    on hb_plaid_transactions (user_id);

create index idx_plaid_transactions_account_id
    on hb_plaid_transactions (account_id);

create index idx_plaid_transactions_date
    on hb_plaid_transactions (date);

create index idx_plaid_transactions_transaction_id
    on hb_plaid_transactions (transaction_id);

create policy "Users can view their own plaid transactions" on hb_plaid_transactions
    as permissive
    for select
    using (auth.uid() = user_id);

create policy "Users can insert their own plaid transactions" on hb_plaid_transactions
    as permissive
    for insert
    with check (auth.uid() = user_id);

grant delete, insert, references, select, trigger, truncate, update on hb_plaid_transactions to anon;

grant delete, insert, references, select, trigger, truncate, update on hb_plaid_transactions to authenticated;

grant delete, insert, references, select, trigger, truncate, update on hb_plaid_transactions to service_role;

create table hb_transaction_categories
(
    id                 uuid                     default gen_random_uuid()                                            not null
        primary key,
    name               varchar(100)                                                                                  not null
        unique,
    description        text,
    color              varchar(7)               default '#3B82F6'::character varying,
    icon               varchar(50),
    parent_category_id uuid
        references hb_transaction_categories,
    is_active          boolean                  default true,
    created_at         timestamp with time zone default (CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles'::text) not null,
    updated_at         timestamp with time zone default (CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles'::text) not null,
    created_by         varchar(50)              default 'SYSTEM'::character varying                                  not null,
    updated_by         varchar(50)              default 'SYSTEM'::character varying                                  not null
);

alter table hb_transaction_categories
    owner to postgres;

create policy "Users can view transaction categories" on hb_transaction_categories
    as permissive
    for select
    using true;

create policy "Users can insert transaction categories" on hb_transaction_categories
    as permissive
    for insert
    with check true;

create policy "Users can update transaction categories" on hb_transaction_categories
    as permissive
    for update
    using true;

grant delete, insert, references, select, trigger, truncate, update on hb_transaction_categories to anon;

grant delete, insert, references, select, trigger, truncate, update on hb_transaction_categories to authenticated;

grant delete, insert, references, select, trigger, truncate, update on hb_transaction_categories to service_role;

create table hb_transactions
(
    id                        uuid                     default gen_random_uuid()                                            not null
        primary key,
    user_id                   uuid
        references ??? ()
        on delete cascade,
    account_id                text                                                                                          not null,
    transaction_id            text,
    amount                    numeric(15, 2)                                                                                not null,
    date                      date                                                                                          not null,
    name                      text                                                                                          not null,
    merchant_name             text,
    description               text,
    category_id               uuid
        references hb_transaction_categories,
    category_confidence       numeric(3, 2)            default 0.0,
    embedding                 vector(1536),
    bank_source               varchar(100),
    import_method             varchar(50)              default 'plaid'::character varying,
    csv_filename              text,
    bill_id                   uuid
        references hb_bills,
    is_reconciled             boolean                  default false,
    pending                   boolean                  default false,
    payment_channel           text,
    location                  jsonb,
    iso_currency_code         text                     default 'USD'::text,
    created_at                timestamp with time zone default (CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles'::text) not null,
    updated_at                timestamp with time zone default (CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles'::text) not null,
    item_id                   text,
    personal_finance_category jsonb,
    unofficial_currency_code  text,
    plaid_category            jsonb,
    match_method              text                     default 'unmatched'::text
        constraint hb_transactions_match_method_check
            check (match_method = ANY (ARRAY ['unmatched'::text, 'manual'::text, 'auto'::text, 'ai'::text])),
    match_confidence          integer                  default 0
        constraint hb_transactions_match_confidence_check
            check ((match_confidence >= 0) AND (match_confidence <= 100)),
    match_timestamp           timestamp with time zone,
    unique (user_id, transaction_id, account_id)
);

alter table hb_transactions
    owner to postgres;

create index idx_transactions_user_id
    on hb_transactions (user_id);

create index idx_transactions_account_id
    on hb_transactions (account_id);

create index idx_transactions_date
    on hb_transactions (date);

create index idx_transactions_category_id
    on hb_transactions (category_id);

create index idx_transactions_bill_id
    on hb_transactions (bill_id);

create index idx_transactions_embedding
    on hb_transactions using ivfflat (embedding vector_cosine_ops);

create index idx_transactions_item_id
    on hb_transactions (item_id);

create index idx_transactions_import_method
    on hb_transactions (import_method);

create index idx_transactions_bank_source
    on hb_transactions (bank_source);

create index idx_transactions_plaid_category
    on hb_transactions using gin (plaid_category);

create unique index unique_csv_transaction
    on hb_transactions (user_id, date, amount, name, account_id, csv_filename)
    where ((import_method)::text = 'csv'::text);

comment on index unique_csv_transaction is 'Prevents duplicate CSV transactions based on user, account, date, amount, name, and filename';

create unique index unique_manual_transaction
    on hb_transactions (user_id, date, amount, name, account_id)
    where ((import_method)::text = 'manual'::text);

comment on index unique_manual_transaction is 'Prevents duplicate manual transactions based on user, account, date, amount, and name';

create index idx_transactions_duplicate_check
    on hb_transactions (user_id, account_id, date, amount, name, import_method, csv_filename);

create unique index hb_transactions_csv_unique
    on hb_transactions (user_id, account_id, date, amount, name);

create policy "Users can view their own transactions" on hb_transactions
    as permissive
    for select
    using (auth.uid() = user_id);

create policy "Users can insert their own transactions" on hb_transactions
    as permissive
    for insert
    with check (auth.uid() = user_id);

create policy "Users can update their own transactions" on hb_transactions
    as permissive
    for update
    using (auth.uid() = user_id);

grant delete, insert, references, select, trigger, truncate, update on hb_transactions to anon;

grant delete, insert, references, select, trigger, truncate, update on hb_transactions to authenticated;

grant delete, insert, references, select, trigger, truncate, update on hb_transactions to service_role;

create table hb_bank_accounts
(
    id                       uuid                     default gen_random_uuid()                                            not null
        primary key,
    user_id                  uuid
        references ??? ()
        on delete cascade,
    name                     varchar(100)                                                                                  not null,
    account_number_last_four varchar(4),
    bank_name                varchar(100)                                                                                  not null,
    account_type             varchar(50)                                                                                   not null,
    plaid_account_id         text,
    is_active                boolean                  default true,
    created_at               timestamp with time zone default (CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles'::text) not null,
    updated_at               timestamp with time zone default (CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles'::text) not null,
    created_by               varchar(50)              default 'SYSTEM'::character varying                                  not null,
    updated_by               varchar(50)              default 'SYSTEM'::character varying                                  not null
);

alter table hb_bank_accounts
    owner to postgres;

create index idx_bank_accounts_user_id
    on hb_bank_accounts (user_id);

create policy "Users can view their own bank accounts" on hb_bank_accounts
    as permissive
    for select
    using (auth.uid() = user_id);

create policy "Users can insert their own bank accounts" on hb_bank_accounts
    as permissive
    for insert
    with check (auth.uid() = user_id);

create policy "Users can update their own bank accounts" on hb_bank_accounts
    as permissive
    for update
    using (auth.uid() = user_id);

grant delete, insert, references, select, trigger, truncate, update on hb_bank_accounts to anon;

grant delete, insert, references, select, trigger, truncate, update on hb_bank_accounts to authenticated;

grant delete, insert, references, select, trigger, truncate, update on hb_bank_accounts to service_role;

create table hb_csv_imports
(
    id                 uuid                     default gen_random_uuid()                                            not null
        primary key,
    user_id            uuid
        references ??? ()
        on delete cascade,
    filename           varchar(255)                                                                                  not null,
    bank_detected      varchar(100),
    total_rows         integer,
    imported_rows      integer,
    failed_rows        integer,
    status             varchar(50)              default 'processing'::character varying,
    error_message      text,
    processing_time_ms integer,
    created_at         timestamp with time zone default (CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles'::text) not null
);

alter table hb_csv_imports
    owner to postgres;

create index idx_csv_imports_user_id
    on hb_csv_imports (user_id);

create policy "Users can view their own csv imports" on hb_csv_imports
    as permissive
    for select
    using (auth.uid() = user_id);

create policy "Users can insert their own csv imports" on hb_csv_imports
    as permissive
    for insert
    with check (auth.uid() = user_id);

grant delete, insert, references, select, trigger, truncate, update on hb_csv_imports to anon;

grant delete, insert, references, select, trigger, truncate, update on hb_csv_imports to authenticated;

grant delete, insert, references, select, trigger, truncate, update on hb_csv_imports to service_role;

create table hb_categorization_rules
(
    id              uuid                     default gen_random_uuid()                                            not null
        primary key,
    user_id         uuid
        references ??? ()
        on delete cascade,
    rule_name       varchar(100)                                                                                  not null,
    rule_type       varchar(50)                                                                                   not null,
    rule_conditions jsonb                                                                                         not null,
    category_id     uuid                                                                                          not null
        references hb_transaction_categories,
    priority        integer                  default 0,
    is_active       boolean                  default true,
    created_at      timestamp with time zone default (CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles'::text) not null,
    updated_at      timestamp with time zone default (CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles'::text) not null,
    created_by      varchar(50)              default 'SYSTEM'::character varying                                  not null,
    updated_by      varchar(50)              default 'SYSTEM'::character varying                                  not null
);

alter table hb_categorization_rules
    owner to postgres;

create index idx_categorization_rules_user_id
    on hb_categorization_rules (user_id);

create policy "Users can view their own categorization rules" on hb_categorization_rules
    as permissive
    for select
    using (auth.uid() = user_id);

create policy "Users can insert their own categorization rules" on hb_categorization_rules
    as permissive
    for insert
    with check (auth.uid() = user_id);

create policy "Users can update their own categorization rules" on hb_categorization_rules
    as permissive
    for update
    using (auth.uid() = user_id);

grant delete, insert, references, select, trigger, truncate, update on hb_categorization_rules to anon;

grant delete, insert, references, select, trigger, truncate, update on hb_categorization_rules to authenticated;

grant delete, insert, references, select, trigger, truncate, update on hb_categorization_rules to service_role;

create table hb_error_logs
(
    id               uuid                     default gen_random_uuid()                                            not null
        primary key,
    user_id          uuid
        references ??? ()
        on delete cascade,
    error_type       varchar(50)                                                                                   not null,
    error_category   varchar(50)                                                                                   not null,
    error_code       varchar(20),
    error_message    text                                                                                          not null,
    error_stack      text,
    operation        varchar(100),
    component        varchar(100),
    function_name    varchar(100),
    error_data       jsonb,
    file_name        varchar(255),
    row_number       integer,
    batch_id         varchar(100),
    request_data     jsonb,
    response_data    jsonb,
    user_agent       text,
    ip_address       inet,
    session_id       varchar(100),
    severity         varchar(20)              default 'error'::character varying,
    resolved         boolean                  default false,
    resolved_at      timestamp with time zone,
    resolved_by      uuid
        references ??? (),
    resolution_notes text,
    created_at       timestamp with time zone default (CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles'::text) not null,
    updated_at       timestamp with time zone default (CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles'::text) not null
);

alter table hb_error_logs
    owner to postgres;

create index idx_error_logs_user_id
    on hb_error_logs (user_id);

create index idx_error_logs_error_type
    on hb_error_logs (error_type);

create index idx_error_logs_error_category
    on hb_error_logs (error_category);

create index idx_error_logs_severity
    on hb_error_logs (severity);

create index idx_error_logs_created_at
    on hb_error_logs (created_at);

create index idx_error_logs_operation
    on hb_error_logs (operation);

create index idx_error_logs_file_name
    on hb_error_logs (file_name);

create index idx_error_logs_resolved
    on hb_error_logs (resolved);

create policy "Users can view their own error logs" on hb_error_logs
    as permissive
    for select
    using (auth.uid() = user_id);

create policy "Users can insert their own error logs" on hb_error_logs
    as permissive
    for insert
    with check (auth.uid() = user_id);

create policy "Users can update their own error logs" on hb_error_logs
    as permissive
    for update
    using (auth.uid() = user_id);

grant delete, insert, references, select, trigger, truncate, update on hb_error_logs to anon;

grant delete, insert, references, select, trigger, truncate, update on hb_error_logs to authenticated;

grant delete, insert, references, select, trigger, truncate, update on hb_error_logs to service_role;

create table hb_matching_patterns
(
    id                  uuid                     default gen_random_uuid() not null
        primary key,
    transaction_pattern text                                               not null,
    bill_pattern        text                                               not null,
    confidence_score    integer                                            not null
        constraint hb_matching_patterns_confidence_score_check
            check ((confidence_score >= 0) AND (confidence_score <= 100)),
    match_count         integer                  default 1,
    created_at          timestamp with time zone default now(),
    updated_at          timestamp with time zone default now(),
    unique (transaction_pattern, bill_pattern)
);

alter table hb_matching_patterns
    owner to postgres;

create index idx_matching_patterns_transaction
    on hb_matching_patterns (transaction_pattern);

create index idx_matching_patterns_bill
    on hb_matching_patterns (bill_pattern);

create policy "Users can manage their own matching patterns" on hb_matching_patterns
    as permissive
    for all
    using (auth.uid() IS NOT NULL);

grant delete, insert, references, select, trigger, truncate, update on hb_matching_patterns to anon;

grant delete, insert, references, select, trigger, truncate, update on hb_matching_patterns to authenticated;

grant delete, insert, references, select, trigger, truncate, update on hb_matching_patterns to service_role;

create table resume_contact
(
    id                   uuid      default gen_random_uuid() not null
        primary key,
    name                 text                                not null,
    email                text                                not null,
    phone                text,
    location             text,
    linkedin             text,
    github               text,
    created_at           timestamp default now(),
    updated_at           timestamp default now(),
    professional_summary text
);

comment on column resume_contact.professional_summary is 'Professional summary/objective statement that will be tailored for each job application';

alter table resume_contact
    owner to postgres;

create policy "Allow all operations on resume_contact for authenticated users" on resume_contact
    as permissive
    for all
    using (auth.role() = 'authenticated'::text);

grant delete, insert, references, select, trigger, truncate, update on resume_contact to anon;

grant delete, insert, references, select, trigger, truncate, update on resume_contact to authenticated;

grant delete, insert, references, select, trigger, truncate, update on resume_contact to service_role;

create table resume_skills
(
    id            uuid      default gen_random_uuid() not null
        primary key,
    name          text                                not null,
    created_at    timestamp default now(),
    updated_at    timestamp default now(),
    category      varchar(100),
    is_featured   boolean   default false,
    display_order integer   default 0
);

comment on column resume_skills.category is 'Skill category: Languages & Frameworks, Cloud & DevOps, Containerization & Microservices, Databases & ORM, Security & Compliance, Testing & Monitoring, Practices & Methodologies';

comment on column resume_skills.is_featured is 'Featured skills always appear in tailored resumes';

comment on column resume_skills.display_order is 'Order for displaying skills (lower numbers first)';

alter table resume_skills
    owner to postgres;

create index idx_resume_skills_featured
    on resume_skills (is_featured, display_order);

create policy "Allow all operations on resume_skills for authenticated users" on resume_skills
    as permissive
    for all
    using (auth.role() = 'authenticated'::text);

grant delete, insert, references, select, trigger, truncate, update on resume_skills to anon;

grant delete, insert, references, select, trigger, truncate, update on resume_skills to authenticated;

grant delete, insert, references, select, trigger, truncate, update on resume_skills to service_role;

create table resume_experience
(
    id                     uuid      default gen_random_uuid() not null
        primary key,
    role                   text                                not null,
    company                text                                not null,
    start_date             date,
    end_date               date,
    created_at             timestamp default now(),
    updated_at             timestamp default now(),
    image_url              text,
    is_excluded            boolean   default false,
    adjust_dates           boolean   default false,
    adjusted_start_date    date,
    adjusted_end_date      date,
    display_tags_in_resume boolean   default true
);

comment on column resume_experience.image_url is 'URL/path to uploaded image for this experience (company logo, team photo, etc.)';

comment on column resume_experience.is_excluded is 'If true, this job is excluded from resume generation but responsibilities can be reassigned';

comment on column resume_experience.adjust_dates is 'If true, use adjusted dates instead of original dates for resume generation';

comment on column resume_experience.adjusted_start_date is 'Modified start date for resume generation (to handle overlapping jobs)';

comment on column resume_experience.adjusted_end_date is 'Modified end date for resume generation (to handle overlapping jobs)';

comment on column resume_experience.display_tags_in_resume is 'Controls whether responsibility tags are displayed in generated resumes. Defaults to true for backwards compatibility.';

alter table resume_experience
    owner to postgres;

create policy "Allow all operations on resume_experience for authenticated use" on resume_experience
    as permissive
    for all
    using (auth.role() = 'authenticated'::text);

grant delete, insert, references, select, trigger, truncate, update on resume_experience to anon;

grant delete, insert, references, select, trigger, truncate, update on resume_experience to authenticated;

grant delete, insert, references, select, trigger, truncate, update on resume_experience to service_role;

create table resume_responsibilities
(
    id            uuid      default gen_random_uuid() not null
        primary key,
    experience_id uuid
        references resume_experience
            on delete cascade,
    description   text                                not null,
    created_at    timestamp default now(),
    updated_at    timestamp default now()
);

alter table resume_responsibilities
    owner to postgres;

create index idx_resume_responsibilities_experience_id
    on resume_responsibilities (experience_id);

create policy "Allow all operations on resume_responsibilities for authenticat" on resume_responsibilities
    as permissive
    for all
    using (auth.role() = 'authenticated'::text);

grant delete, insert, references, select, trigger, truncate, update on resume_responsibilities to anon;

grant delete, insert, references, select, trigger, truncate, update on resume_responsibilities to authenticated;

grant delete, insert, references, select, trigger, truncate, update on resume_responsibilities to service_role;

create table resume_education
(
    id         uuid      default gen_random_uuid() not null
        primary key,
    degree     text                                not null,
    school     text                                not null,
    start_date date,
    end_date   date,
    created_at timestamp default now(),
    updated_at timestamp default now(),
    minor      varchar(255),
    notes      text
);

comment on column resume_education.minor is 'Minor, concentration, or emphasis area';

comment on column resume_education.notes is 'Honors, GPA, or other relevant notes (e.g., Summa Cum Laude)';

alter table resume_education
    owner to postgres;

create policy "Allow all operations on resume_education for authenticated user" on resume_education
    as permissive
    for all
    using (auth.role() = 'authenticated'::text);

grant delete, insert, references, select, trigger, truncate, update on resume_education to anon;

grant delete, insert, references, select, trigger, truncate, update on resume_education to authenticated;

grant delete, insert, references, select, trigger, truncate, update on resume_education to service_role;

create table resume_certifications
(
    id          uuid      default gen_random_uuid() not null
        primary key,
    title       text                                not null,
    issued_date date,
    created_at  timestamp default now(),
    updated_at  timestamp default now()
);

alter table resume_certifications
    owner to postgres;

create policy "Allow all operations on resume_certifications for authenticated" on resume_certifications
    as permissive
    for all
    using (auth.role() = 'authenticated'::text);

grant delete, insert, references, select, trigger, truncate, update on resume_certifications to anon;

grant delete, insert, references, select, trigger, truncate, update on resume_certifications to authenticated;

grant delete, insert, references, select, trigger, truncate, update on resume_certifications to service_role;

create table resume_projects
(
    id          uuid      default gen_random_uuid() not null
        primary key,
    title       text                                not null,
    description text,
    created_at  timestamp default now(),
    updated_at  timestamp default now()
);

alter table resume_projects
    owner to postgres;

create policy "Allow all operations on resume_projects for authenticated users" on resume_projects
    as permissive
    for all
    using (auth.role() = 'authenticated'::text);

grant delete, insert, references, select, trigger, truncate, update on resume_projects to anon;

grant delete, insert, references, select, trigger, truncate, update on resume_projects to authenticated;

grant delete, insert, references, select, trigger, truncate, update on resume_projects to service_role;

create table resume_volunteer
(
    id          uuid      default gen_random_uuid() not null
        primary key,
    role        text                                not null,
    description text,
    created_at  timestamp default now(),
    updated_at  timestamp default now()
);

alter table resume_volunteer
    owner to postgres;

create policy "Allow all operations on resume_volunteer for authenticated user" on resume_volunteer
    as permissive
    for all
    using (auth.role() = 'authenticated'::text);

grant delete, insert, references, select, trigger, truncate, update on resume_volunteer to anon;

grant delete, insert, references, select, trigger, truncate, update on resume_volunteer to authenticated;

grant delete, insert, references, select, trigger, truncate, update on resume_volunteer to service_role;

create table resume_tags
(
    id          uuid                     default gen_random_uuid() not null
        primary key,
    name        varchar(100)                                       not null
        unique,
    description text,
    created_at  timestamp with time zone default now(),
    updated_at  timestamp with time zone default now()
);

alter table resume_tags
    owner to postgres;

create index idx_resume_tags_name
    on resume_tags (name);

create index idx_resume_tags_created_at
    on resume_tags (created_at);

create policy "Users can view all resume tags" on resume_tags
    as permissive
    for select
    using true;

create policy "Users can insert resume tags" on resume_tags
    as permissive
    for insert
    with check true;

create policy "Users can update resume tags" on resume_tags
    as permissive
    for update
    using true;

create policy "Users can delete resume tags" on resume_tags
    as permissive
    for delete
    using true;

grant delete, insert, references, select, trigger, truncate, update on resume_tags to anon;

grant delete, insert, references, select, trigger, truncate, update on resume_tags to authenticated;

grant delete, insert, references, select, trigger, truncate, update on resume_tags to service_role;

create table resume_skill_tags_junction
(
    id         uuid                     default gen_random_uuid() not null
        primary key,
    skill_id   uuid                                               not null
        references resume_skills
            on delete cascade,
    tag_id     uuid                                               not null
        references resume_tags
            on delete cascade,
    created_at timestamp with time zone default now(),
    unique (skill_id, tag_id)
);

alter table resume_skill_tags_junction
    owner to postgres;

create index idx_resume_skill_tags_junction_skill_id
    on resume_skill_tags_junction (skill_id);

create index idx_resume_skill_tags_junction_tag_id
    on resume_skill_tags_junction (tag_id);

create policy "Users can view skill tags junction" on resume_skill_tags_junction
    as permissive
    for select
    using true;

create policy "Users can insert skill tags junction" on resume_skill_tags_junction
    as permissive
    for insert
    with check true;

create policy "Users can update skill tags junction" on resume_skill_tags_junction
    as permissive
    for update
    using true;

create policy "Users can delete skill tags junction" on resume_skill_tags_junction
    as permissive
    for delete
    using true;

grant delete, insert, references, select, trigger, truncate, update on resume_skill_tags_junction to anon;

grant delete, insert, references, select, trigger, truncate, update on resume_skill_tags_junction to authenticated;

grant delete, insert, references, select, trigger, truncate, update on resume_skill_tags_junction to service_role;

create table resume_experience_tags_junction
(
    id            uuid                     default gen_random_uuid() not null
        primary key,
    experience_id uuid                                               not null
        references resume_experience
            on delete cascade,
    tag_id        uuid                                               not null
        references resume_tags
            on delete cascade,
    created_at    timestamp with time zone default now(),
    unique (experience_id, tag_id)
);

alter table resume_experience_tags_junction
    owner to postgres;

create index idx_resume_experience_tags_junction_experience_id
    on resume_experience_tags_junction (experience_id);

create index idx_resume_experience_tags_junction_tag_id
    on resume_experience_tags_junction (tag_id);

create policy "Users can view experience tags junction" on resume_experience_tags_junction
    as permissive
    for select
    using true;

create policy "Users can insert experience tags junction" on resume_experience_tags_junction
    as permissive
    for insert
    with check true;

create policy "Users can update experience tags junction" on resume_experience_tags_junction
    as permissive
    for update
    using true;

create policy "Users can delete experience tags junction" on resume_experience_tags_junction
    as permissive
    for delete
    using true;

grant delete, insert, references, select, trigger, truncate, update on resume_experience_tags_junction to anon;

grant delete, insert, references, select, trigger, truncate, update on resume_experience_tags_junction to authenticated;

grant delete, insert, references, select, trigger, truncate, update on resume_experience_tags_junction to service_role;

create table resume_project_tags_junction
(
    id         uuid                     default gen_random_uuid() not null
        primary key,
    project_id uuid                                               not null
        references resume_projects
            on delete cascade,
    tag_id     uuid                                               not null
        references resume_tags
            on delete cascade,
    created_at timestamp with time zone default now(),
    unique (project_id, tag_id)
);

alter table resume_project_tags_junction
    owner to postgres;

create index idx_resume_project_tags_junction_project_id
    on resume_project_tags_junction (project_id);

create index idx_resume_project_tags_junction_tag_id
    on resume_project_tags_junction (tag_id);

create policy "Users can view project tags junction" on resume_project_tags_junction
    as permissive
    for select
    using true;

create policy "Users can insert project tags junction" on resume_project_tags_junction
    as permissive
    for insert
    with check true;

create policy "Users can update project tags junction" on resume_project_tags_junction
    as permissive
    for update
    using true;

create policy "Users can delete project tags junction" on resume_project_tags_junction
    as permissive
    for delete
    using true;

grant delete, insert, references, select, trigger, truncate, update on resume_project_tags_junction to anon;

grant delete, insert, references, select, trigger, truncate, update on resume_project_tags_junction to authenticated;

grant delete, insert, references, select, trigger, truncate, update on resume_project_tags_junction to service_role;

create table resume_volunteer_tags_junction
(
    id           uuid                     default gen_random_uuid() not null
        primary key,
    volunteer_id uuid                                               not null
        references resume_volunteer
            on delete cascade,
    tag_id       uuid                                               not null
        references resume_tags
            on delete cascade,
    created_at   timestamp with time zone default now(),
    unique (volunteer_id, tag_id)
);

alter table resume_volunteer_tags_junction
    owner to postgres;

create index idx_resume_volunteer_tags_junction_volunteer_id
    on resume_volunteer_tags_junction (volunteer_id);

create index idx_resume_volunteer_tags_junction_tag_id
    on resume_volunteer_tags_junction (tag_id);

create policy "Users can view volunteer tags junction" on resume_volunteer_tags_junction
    as permissive
    for select
    using true;

create policy "Users can insert volunteer tags junction" on resume_volunteer_tags_junction
    as permissive
    for insert
    with check true;

create policy "Users can update volunteer tags junction" on resume_volunteer_tags_junction
    as permissive
    for update
    using true;

create policy "Users can delete volunteer tags junction" on resume_volunteer_tags_junction
    as permissive
    for delete
    using true;

grant delete, insert, references, select, trigger, truncate, update on resume_volunteer_tags_junction to anon;

grant delete, insert, references, select, trigger, truncate, update on resume_volunteer_tags_junction to authenticated;

grant delete, insert, references, select, trigger, truncate, update on resume_volunteer_tags_junction to service_role;

create table hb_account_owners
(
    id            uuid                     default gen_random_uuid() not null
        primary key,
    account_id    uuid                                               not null
        references hb_accounts
            on delete cascade,
    owner_type_id uuid                                               not null
        references hb_owner_types
            on delete cascade,
    created_at    timestamp with time zone default CURRENT_TIMESTAMP not null,
    updated_at    timestamp with time zone default CURRENT_TIMESTAMP not null
);

alter table hb_account_owners
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on hb_account_owners to anon;

grant delete, insert, references, select, trigger, truncate, update on hb_account_owners to authenticated;

grant delete, insert, references, select, trigger, truncate, update on hb_account_owners to service_role;

create table hb_bill_owners
(
    id            uuid                     default gen_random_uuid() not null
        primary key,
    bill_id       uuid                                               not null
        references hb_bills
            on delete cascade,
    owner_type_id uuid                                               not null
        references hb_owner_types
            on delete cascade,
    created_at    timestamp with time zone default CURRENT_TIMESTAMP not null,
    updated_at    timestamp with time zone default CURRENT_TIMESTAMP not null,
    constraint unique_bill_owner
        unique (bill_id, owner_type_id)
);

alter table hb_bill_owners
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on hb_bill_owners to anon;

grant delete, insert, references, select, trigger, truncate, update on hb_bill_owners to authenticated;

grant delete, insert, references, select, trigger, truncate, update on hb_bill_owners to service_role;

create table tmp_update_bills
(
    bill_name                      text,
    amount_due                     numeric(10, 2),
    due_date                       text,
    status                         text,
    description                    text,
    priority                       text,
    frequency                      text,
    last_paid                      date,
    is_fixed_bill                  boolean,
    bill_type                      text,
    payment_type                   text,
    is_included_in_monthly_payment boolean,
    account_name                   text,
    url                            text,
    username                       text,
    password                       text,
    owner                          text,
    bill_id                        uuid,
    account_id                     uuid
);

alter table tmp_update_bills
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on tmp_update_bills to anon;

grant delete, insert, references, select, trigger, truncate, update on tmp_update_bills to authenticated;

grant delete, insert, references, select, trigger, truncate, update on tmp_update_bills to service_role;

create table hb_bills_old
(
    id                             uuid,
    amount_due                     numeric(10, 2),
    due_date                       text,
    status                         text,
    description                    text,
    priority_id                    uuid,
    frequency_id                   uuid,
    last_paid                      date,
    is_fixed_bill                  boolean,
    bill_type_id                   uuid,
    payment_type_id                uuid,
    tag_id                         uuid,
    is_included_in_monthly_payment boolean,
    created_at                     timestamp with time zone,
    updated_at                     timestamp with time zone,
    created_by                     varchar(50),
    updated_by                     varchar(50),
    bill_name                      text,
    account_id                     uuid
);

alter table hb_bills_old
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on hb_bills_old to anon;

grant delete, insert, references, select, trigger, truncate, update on hb_bills_old to authenticated;

grant delete, insert, references, select, trigger, truncate, update on hb_bills_old to service_role;

create table hb_accounts_old
(
    id            uuid,
    name          text,
    url           text,
    login_id      uuid,
    owner_type_id uuid,
    created_at    timestamp with time zone,
    updated_at    timestamp with time zone,
    created_by    varchar(50),
    updated_by    varchar(50)
);

alter table hb_accounts_old
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on hb_accounts_old to anon;

grant delete, insert, references, select, trigger, truncate, update on hb_accounts_old to authenticated;

grant delete, insert, references, select, trigger, truncate, update on hb_accounts_old to service_role;

create table hb_monthly_financial_summaries
(
    id                 uuid                     default gen_random_uuid() not null
        primary key,
    user_id            uuid                                               not null
        references ??? ()
        on delete cascade,
    year               integer                                            not null,
    month              integer                                            not null,
    total_spent        numeric(12, 2)           default 0                 not null,
    total_income       numeric(12, 2)           default 0                 not null,
    net_amount         numeric(12, 2)           default 0                 not null,
    transaction_count  integer                  default 0                 not null,
    category_breakdown jsonb                    default '[]'::jsonb       not null,
    insights           jsonb                    default '[]'::jsonb       not null,
    created_at         timestamp with time zone default now(),
    updated_at         timestamp with time zone default now(),
    created_by         varchar(50)              default 'SYSTEM'::character varying,
    updated_by         varchar(50)              default 'SYSTEM'::character varying,
    unique (user_id, year, month)
);

comment on table hb_monthly_financial_summaries is 'Caches monthly financial summary data to avoid recalculating on every page load';

alter table hb_monthly_financial_summaries
    owner to postgres;

create index idx_monthly_summaries_user_date
    on hb_monthly_financial_summaries (user_id, year, month);

create policy "Users can view own summaries" on hb_monthly_financial_summaries
    as permissive
    for select
    using (auth.uid() = user_id);

create policy "Users can insert own summaries" on hb_monthly_financial_summaries
    as permissive
    for insert
    with check (auth.uid() = user_id);

create policy "Users can update own summaries" on hb_monthly_financial_summaries
    as permissive
    for update
    using (auth.uid() = user_id);

create policy "Users can delete own summaries" on hb_monthly_financial_summaries
    as permissive
    for delete
    using (auth.uid() = user_id);

grant delete, insert, references, select, trigger, truncate, update on hb_monthly_financial_summaries to anon;

grant delete, insert, references, select, trigger, truncate, update on hb_monthly_financial_summaries to authenticated;

grant delete, insert, references, select, trigger, truncate, update on hb_monthly_financial_summaries to service_role;

create table resume_responsibility_tags_junction
(
    id                uuid                     default gen_random_uuid() not null
        primary key,
    responsibility_id uuid                                               not null
        references resume_responsibilities
            on delete cascade,
    tag_id            uuid                                               not null
        references resume_tags
            on delete cascade,
    created_at        timestamp with time zone default now(),
    constraint resume_responsibility_tags_junctio_responsibility_id_tag_id_key
        unique (responsibility_id, tag_id)
);

alter table resume_responsibility_tags_junction
    owner to postgres;

create index idx_resume_responsibility_tags_junction_responsibility_id
    on resume_responsibility_tags_junction (responsibility_id);

create index idx_resume_responsibility_tags_junction_tag_id
    on resume_responsibility_tags_junction (tag_id);

create policy "Authenticated users can view responsibility tags" on resume_responsibility_tags_junction
    as permissive
    for select
    using (auth.uid() IS NOT NULL);

create policy "Authenticated users can insert responsibility tags" on resume_responsibility_tags_junction
    as permissive
    for insert
    with check (auth.uid() IS NOT NULL);

create policy "Authenticated users can update responsibility tags" on resume_responsibility_tags_junction
    as permissive
    for update
    using (auth.uid() IS NOT NULL);

create policy "Authenticated users can delete responsibility tags" on resume_responsibility_tags_junction
    as permissive
    for delete
    using (auth.uid() IS NOT NULL);

grant delete, insert, references, select, trigger, truncate, update on resume_responsibility_tags_junction to anon;

grant delete, insert, references, select, trigger, truncate, update on resume_responsibility_tags_junction to authenticated;

grant delete, insert, references, select, trigger, truncate, update on resume_responsibility_tags_junction to service_role;

create table resume_managers
(
    id            uuid                     default uuid_generate_v4() not null
        primary key,
    user_id       uuid                                                not null
        references ??? ()
        on delete cascade,
    experience_id uuid                                                not null
        references resume_experience
            on delete cascade,
    manager_name  varchar(200)                                        not null,
    start_date    date,
    end_date      date,
    created_at    timestamp with time zone default now(),
    updated_at    timestamp with time zone default now()
);

comment on table resume_managers is 'Tracks managers for each work experience, allowing multiple managers per job with date ranges';

alter table resume_managers
    owner to postgres;

create index idx_resume_managers_experience
    on resume_managers (experience_id);

create index idx_resume_managers_user
    on resume_managers (user_id);

create policy "Users can view their own managers" on resume_managers
    as permissive
    for select
    using (auth.uid() = user_id);

create policy "Users can insert their own managers" on resume_managers
    as permissive
    for insert
    with check (auth.uid() = user_id);

create policy "Users can update their own managers" on resume_managers
    as permissive
    for update
    using (auth.uid() = user_id)
    with check (auth.uid() = user_id);

create policy "Users can delete their own managers" on resume_managers
    as permissive
    for delete
    using (auth.uid() = user_id);

grant delete, insert, references, select, trigger, truncate, update on resume_managers to anon;

grant delete, insert, references, select, trigger, truncate, update on resume_managers to authenticated;

grant delete, insert, references, select, trigger, truncate, update on resume_managers to service_role;

create table resume_responsibility_mappings
(
    id                   uuid                     default uuid_generate_v4() not null
        primary key,
    user_id              uuid                                                not null
        references ??? ()
        on delete cascade,
    source_experience_id uuid                                                not null
        references resume_experience
            on delete cascade,
    target_experience_id uuid                                                not null
        references resume_experience
            on delete cascade,
    responsibility_id    uuid                                                not null
        references resume_responsibilities
            on delete cascade,
    created_at           timestamp with time zone default now(),
    updated_at           timestamp with time zone default now()
);

comment on table resume_responsibility_mappings is 'Maps responsibilities from excluded jobs to other jobs for resume generation';

alter table resume_responsibility_mappings
    owner to postgres;

create index idx_responsibility_mappings_source
    on resume_responsibility_mappings (source_experience_id);

create index idx_responsibility_mappings_target
    on resume_responsibility_mappings (target_experience_id);

create index idx_responsibility_mappings_user
    on resume_responsibility_mappings (user_id);

create policy "Users can manage their own mappings" on resume_responsibility_mappings
    as permissive
    for all
    using (auth.uid() = user_id);

grant delete, insert, references, select, trigger, truncate, update on resume_responsibility_mappings to anon;

grant delete, insert, references, select, trigger, truncate, update on resume_responsibility_mappings to authenticated;

grant delete, insert, references, select, trigger, truncate, update on resume_responsibility_mappings to service_role;

create table pp_contacts
(
    id            uuid                     default gen_random_uuid() not null
        primary key,
    user_id       uuid                                               not null
        references ??? ()
        on delete cascade,
    name          text                                               not null,
    party_level   integer                                            not null
        constraint pp_contacts_party_level_check
            check (party_level >= 1),
    email         text,
    phone_number  text,
    phone_carrier phone_carrier_enum,
    address       text,
    notes         text,
    created_at    timestamp with time zone default now()
);

alter table pp_contacts
    owner to postgres;

create index pp_contacts_user_id_idx
    on pp_contacts (user_id);

create policy "Users can manage their own contacts" on pp_contacts
    as permissive
    for all
    using (auth.uid() = user_id)
    with check (auth.uid() = user_id);

grant delete, insert, references, select, trigger, truncate, update on pp_contacts to anon;

grant delete, insert, references, select, trigger, truncate, update on pp_contacts to authenticated;

grant delete, insert, references, select, trigger, truncate, update on pp_contacts to service_role;

create table pp_parties
(
    id         uuid                     default gen_random_uuid() not null
        primary key,
    user_id    uuid                                               not null
        references ??? ()
        on delete cascade,
    name       text                                               not null,
    party_size integer                                            not null
        constraint pp_parties_party_size_check
            check (party_size >= 1),
    event_date date,
    created_at timestamp with time zone default now()
);

alter table pp_parties
    owner to postgres;

create index pp_parties_user_id_idx
    on pp_parties (user_id);

create policy "Users can manage their own parties" on pp_parties
    as permissive
    for all
    using (auth.uid() = user_id)
    with check (auth.uid() = user_id);

grant delete, insert, references, select, trigger, truncate, update on pp_parties to anon;

grant delete, insert, references, select, trigger, truncate, update on pp_parties to authenticated;

grant delete, insert, references, select, trigger, truncate, update on pp_parties to service_role;

create table pp_party_invites
(
    id          uuid                     default gen_random_uuid() not null
        primary key,
    party_id    uuid                                               not null
        references pp_parties
            on delete cascade,
    contact_id  uuid                                               not null
        references pp_contacts
            on delete cascade,
    invited     boolean                  default true,
    rsvp_status text
        constraint pp_party_invites_rsvp_status_check
            check (rsvp_status = ANY (ARRAY ['yes'::text, 'no'::text, 'maybe'::text])),
    created_at  timestamp with time zone default now(),
    unique (party_id, contact_id)
);

alter table pp_party_invites
    owner to postgres;

create index pp_party_invites_party_id_idx
    on pp_party_invites (party_id);

create index pp_party_invites_contact_id_idx
    on pp_party_invites (contact_id);

create index pp_party_invites_party_id_idx1
    on pp_party_invites (party_id);

create index pp_party_invites_party_id_idx2
    on pp_party_invites (party_id);

create index pp_party_invites_contact_id_idx1
    on pp_party_invites (contact_id);

create policy "Users can access invites for their parties" on pp_party_invites
    as permissive
    for select
    using (EXISTS (SELECT 1
                   FROM pp_parties p
                   WHERE ((p.id = pp_party_invites.party_id) AND (p.user_id = auth.uid()))));

create policy "Users can insert invites for their parties" on pp_party_invites
    as permissive
    for insert
    with check (EXISTS (SELECT 1
                        FROM pp_parties p
                        WHERE ((p.id = pp_party_invites.party_id) AND (p.user_id = auth.uid()))));

grant delete, insert, references, select, trigger, truncate, update on pp_party_invites to anon;

grant delete, insert, references, select, trigger, truncate, update on pp_party_invites to authenticated;

grant delete, insert, references, select, trigger, truncate, update on pp_party_invites to service_role;

create table shop_stores
(
    id         uuid                     default gen_random_uuid() not null
        primary key,
    name       varchar(255)                                       not null,
    address    text,
    city       varchar(100),
    state      varchar(2),
    zip_code   varchar(10),
    created_at timestamp with time zone default now()
);

alter table shop_stores
    owner to postgres;

create policy "Users can view stores" on shop_stores
    as permissive
    for select
    using true;

create policy "Users can insert stores" on shop_stores
    as permissive
    for insert
    with check true;

create policy "Users can update stores" on shop_stores
    as permissive
    for update
    using true
with check true;

grant delete, insert, references, select, trigger, truncate, update on shop_stores to anon;

grant delete, insert, references, select, trigger, truncate, update on shop_stores to authenticated;

grant delete, insert, references, select, trigger, truncate, update on shop_stores to service_role;

create table shop_receipts
(
    id             uuid                     default gen_random_uuid() not null
        primary key,
    store_id       uuid
        references shop_stores,
    receipt_date   date                                               not null,
    subtotal       numeric(10, 2)                                     not null,
    tax            numeric(10, 2)           default 0                 not null,
    total          numeric(10, 2)                                     not null,
    payment_method varchar(50),
    card_last_four varchar(4),
    notes          text,
    created_at     timestamp with time zone default now(),
    updated_at     timestamp with time zone default now()
);

alter table shop_receipts
    owner to postgres;

create index idx_shop_receipts_store_id
    on shop_receipts (store_id);

create index idx_shop_receipts_date
    on shop_receipts (receipt_date);

create index idx_shop_receipts_payment_method
    on shop_receipts (payment_method);

create policy "Users can view their own receipts" on shop_receipts
    as permissive
    for select
    using true;

create policy "Users can insert receipts" on shop_receipts
    as permissive
    for insert
    with check true;

create policy "Users can update their own receipts" on shop_receipts
    as permissive
    for update
    using true
with check true;

create policy "Users can delete their own receipts" on shop_receipts
    as permissive
    for delete
    using true;

grant delete, insert, references, select, trigger, truncate, update on shop_receipts to anon;

grant delete, insert, references, select, trigger, truncate, update on shop_receipts to authenticated;

grant delete, insert, references, select, trigger, truncate, update on shop_receipts to service_role;

create table shop_items
(
    id          uuid                     default gen_random_uuid() not null
        primary key,
    name        varchar(255)                                       not null
        unique,
    category    varchar(100),
    description text,
    created_at  timestamp with time zone default now()
);

alter table shop_items
    owner to postgres;

create index idx_shop_items_category
    on shop_items (category);

create policy "Users can view items" on shop_items
    as permissive
    for select
    using true;

create policy "Users can insert items" on shop_items
    as permissive
    for insert
    with check true;

create policy "Users can update items" on shop_items
    as permissive
    for update
    using true
with check true;

grant delete, insert, references, select, trigger, truncate, update on shop_items to anon;

grant delete, insert, references, select, trigger, truncate, update on shop_items to authenticated;

grant delete, insert, references, select, trigger, truncate, update on shop_items to service_role;

create table shop_receipt_items
(
    id              uuid                     default gen_random_uuid() not null
        primary key,
    receipt_id      uuid
        references shop_receipts
            on delete cascade,
    item_id         uuid
        references shop_items,
    quantity        numeric(10, 2)           default 1                 not null,
    unit_price      numeric(10, 2)                                     not null,
    total_price     numeric(10, 2)                                     not null,
    expiration_date date,
    notes           text,
    created_at      timestamp with time zone default now(),
    is_finished     boolean                  default false,
    would_rebuy     integer
        constraint check_would_rebuy
            check ((would_rebuy IS NULL) OR ((would_rebuy >= 1) AND (would_rebuy <= 5)))
);

alter table shop_receipt_items
    owner to postgres;

create index idx_shop_receipt_items_receipt_id
    on shop_receipt_items (receipt_id);

create index idx_shop_receipt_items_item_id
    on shop_receipt_items (item_id);

create index idx_shop_receipt_items_expiration_date
    on shop_receipt_items (expiration_date)
    where (expiration_date IS NOT NULL);

create index idx_shop_receipt_items_is_finished
    on shop_receipt_items (is_finished)
    where (is_finished = false);

create index idx_shop_receipt_items_would_rebuy
    on shop_receipt_items (would_rebuy)
    where (would_rebuy IS NOT NULL);

create policy "Users can view receipt items" on shop_receipt_items
    as permissive
    for select
    using (EXISTS (SELECT 1
                   FROM shop_receipts
                   WHERE (shop_receipts.id = shop_receipt_items.receipt_id)));

create policy "Users can insert receipt items" on shop_receipt_items
    as permissive
    for insert
    with check (EXISTS (SELECT 1
                        FROM shop_receipts
                        WHERE (shop_receipts.id = shop_receipt_items.receipt_id)));

create policy "Users can update receipt items" on shop_receipt_items
    as permissive
    for update
    using (EXISTS (SELECT 1
                   FROM shop_receipts
                   WHERE (shop_receipts.id = shop_receipt_items.receipt_id)))
    with check (EXISTS (SELECT 1
                        FROM shop_receipts
                        WHERE (shop_receipts.id = shop_receipt_items.receipt_id)));

create policy "Users can delete receipt items" on shop_receipt_items
    as permissive
    for delete
    using (EXISTS (SELECT 1
                   FROM shop_receipts
                   WHERE (shop_receipts.id = shop_receipt_items.receipt_id)));

grant delete, insert, references, select, trigger, truncate, update on shop_receipt_items to anon;

grant delete, insert, references, select, trigger, truncate, update on shop_receipt_items to authenticated;

grant delete, insert, references, select, trigger, truncate, update on shop_receipt_items to service_role;

create table shop_rebuy_ratings
(
    rating      integer     not null
        primary key,
    label       varchar(50) not null,
    description text,
    created_at  timestamp with time zone default now()
);

alter table shop_rebuy_ratings
    owner to postgres;

create policy "Users can view rebuy ratings" on shop_rebuy_ratings
    as permissive
    for select
    using true;

grant delete, insert, references, select, trigger, truncate, update on shop_rebuy_ratings to anon;

grant delete, insert, references, select, trigger, truncate, update on shop_rebuy_ratings to authenticated;

grant delete, insert, references, select, trigger, truncate, update on shop_rebuy_ratings to service_role;

create table cb_potlucks
(
    id               uuid                     default gen_random_uuid() not null
        constraint potlucks_pkey
            primary key,
    title            text                                               not null,
    estimated_people integer                  default 0                 not null,
    event_name       text,
    event_date       text,
    event_time       text,
    event_location   text,
    created_at       timestamp with time zone default now()             not null
);

alter table cb_potlucks
    owner to postgres;

create policy anon_select_potlucks on cb_potlucks
    as permissive
    for select
    using true;

create policy anon_insert_potlucks on cb_potlucks
    as permissive
    for insert
    with check true;

create policy anon_update_potlucks on cb_potlucks
    as permissive
    for update
    using true
with check true;

create policy anon_delete_potlucks on cb_potlucks
    as permissive
    for delete
    using true;

grant delete, insert, references, select, trigger, truncate, update on cb_potlucks to anon;

grant delete, insert, references, select, trigger, truncate, update on cb_potlucks to authenticated;

grant delete, insert, references, select, trigger, truncate, update on cb_potlucks to service_role;

create table cb_categories
(
    id         uuid    default gen_random_uuid() not null
        primary key,
    potluck_id uuid                              not null
        references cb_potlucks
            on delete cascade,
    name       text                              not null,
    icon       text                              not null,
    is_custom  boolean default false             not null,
    sort_order integer
);

alter table cb_categories
    owner to postgres;

create index cb_categories_potluck_sort_order_idx
    on cb_categories (potluck_id, sort_order);

grant delete, insert, references, select, trigger, truncate, update on cb_categories to anon;

grant delete, insert, references, select, trigger, truncate, update on cb_categories to authenticated;

grant delete, insert, references, select, trigger, truncate, update on cb_categories to service_role;

create table cb_potluck_items
(
    id          uuid default gen_random_uuid() not null
        primary key,
    potluck_id  uuid                           not null
        references cb_potlucks
            on delete cascade,
    category_id uuid                           not null
        references cb_categories
            on delete cascade,
    name        text                           not null,
    assignee    text default ''::text          not null,
    notes       text default ''::text          not null
);

alter table cb_potluck_items
    owner to postgres;

create index cb_potluck_items_potluck_idx
    on cb_potluck_items (potluck_id);

create index cb_potluck_items_category_idx
    on cb_potluck_items (category_id);

grant delete, insert, references, select, trigger, truncate, update on cb_potluck_items to anon;

grant delete, insert, references, select, trigger, truncate, update on cb_potluck_items to authenticated;

grant delete, insert, references, select, trigger, truncate, update on cb_potluck_items to service_role;

create table master_contacts
(
    user_id           uuid                     default gen_random_uuid() not null,
    first_name        varchar(100)                                       not null,
    last_name         varchar(100)                                       not null,
    phone_number      varchar(25),
    email             varchar(255),
    address           text,
    birthday          date,
    phone_carrier     varchar(50),
    notes             text,
    number_of_invites integer                  default 0                 not null,
    number_attended   integer                  default 0                 not null,
    created_at        timestamp with time zone default now()             not null,
    updated_at        timestamp with time zone default now()             not null,
    username          varchar(100),
    password_hash     text,
    party_size        smallint                 default 4                 not null,
    primary key (
) ,
	unique ()
);

alter table master_contacts
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on master_contacts to anon;

grant delete, insert, references, select, trigger, truncate, update on master_contacts to authenticated;

grant delete, insert, references, select, trigger, truncate, update on master_contacts to service_role;

create table game_user_questions
(
    id                     uuid default gen_random_uuid() not null
        primary key,
    game_master_contact_id uuid                           not null,
    question_text          text                           not null
);

alter table game_user_questions
    owner to postgres;

create index game_user_questions_master_idx
    on game_user_questions (game_master_contact_id);

grant delete, insert, references, select, trigger, truncate, update on game_user_questions to anon;

grant delete, insert, references, select, trigger, truncate, update on game_user_questions to authenticated;

grant delete, insert, references, select, trigger, truncate, update on game_user_questions to service_role;

create table cb_events
(
    id                   uuid                     default gen_random_uuid() not null
        primary key,
    owner_id             uuid
                                                                            references master_contacts (user_id)
                                                                                on delete set null,
    title                text                                               not null,
    party_size           smallint                 default 2                 not null,
    starts_at            timestamp with time zone,
    ends_at              timestamp with time zone,
    location             text,
    invitation_image_url text,
    potluck_enabled      boolean                  default false             not null,
    potluck_id           uuid
                                                                            references cb_potlucks
                                                                                on delete set null,
    status               text                     default 'draft'::text     not null
        constraint cb_events_status_check
            check (status = ANY
                   (ARRAY ['draft'::text, 'finalized'::text, 'open'::text, 'closed'::text, 'cancelled'::text])),
    created_at           timestamp with time zone default now()             not null,
    updated_at           timestamp with time zone default now()             not null
);

alter table cb_events
    owner to postgres;

create index idx_cb_events_owner
    on cb_events (owner_id);

create index idx_cb_events_status
    on cb_events (status);

grant delete, insert, references, select, trigger, truncate, update on cb_events to anon;

grant delete, insert, references, select, trigger, truncate, update on cb_events to authenticated;

grant delete, insert, references, select, trigger, truncate, update on cb_events to service_role;

create table cb_event_guests
(
    id                 uuid                     default gen_random_uuid()   not null
        primary key,
    event_id           uuid                                                 not null
        references cb_events
            on delete cascade,
    contact_id         uuid
                                                                            references master_contacts (user_id)
                                                                                on delete set null,
    snapshot_name      text,
    snapshot_phone     text,
    snapshot_email     text,
    snapshot           jsonb,
    invited            boolean                  default true                not null,
    finalized_at       timestamp with time zone,
    invite_status      text                     default 'pending'::text     not null
        constraint cb_event_guests_invite_status_check
            check (invite_status = ANY
                   (ARRAY ['pending'::text, 'queued'::text, 'sent'::text, 'delivered'::text, 'failed'::text])),
    invite_token       text
        unique,
    invite_sent_at     timestamp with time zone,
    created_at         timestamp with time zone default now()               not null,
    invited_at         timestamp with time zone,
    rsvp_status        text                     default 'no_response'::text not null
        constraint cb_event_guests_rsvp_status_check
            check (rsvp_status = ANY
                   (ARRAY ['no_response'::text, 'attending'::text, 'not_attending'::text, 'maybe'::text])),
    rsvp_guest_count   smallint
        constraint cb_event_guests_rsvp_guest_count_check
            check ((rsvp_guest_count IS NULL) OR (rsvp_guest_count >= 0)),
    rsvp_at            timestamp with time zone,
    attendance_status  text                     default 'unknown'::text     not null
        constraint cb_event_guests_attendance_status_check
            check (attendance_status = ANY
                   (ARRAY ['unknown'::text, 'attended'::text, 'no_show'::text, 'absent_excused'::text])),
    attended_at        timestamp with time zone,
    actual_guest_count smallint
        constraint cb_event_guests_actual_guest_count_check
            check ((actual_guest_count IS NULL) OR (actual_guest_count >= 0)),
    manually_added     boolean                  default false               not null,
    updated_at         timestamp with time zone default now()               not null
);

alter table cb_event_guests
    owner to postgres;

create index idx_cb_event_guests_event
    on cb_event_guests (event_id);

create index idx_cb_event_guests_contact
    on cb_event_guests (contact_id);

create index idx_cb_event_guests_token
    on cb_event_guests (invite_token);

create unique index uq_cb_event_guests_event_contact
    on cb_event_guests (event_id, contact_id)
    where (contact_id IS NOT NULL);

create index idx_cb_event_guests_invite_status
    on cb_event_guests (invite_status);

create index idx_cb_event_guests_rsvp_status
    on cb_event_guests (rsvp_status);

create index idx_cb_event_guests_attendance_status
    on cb_event_guests (attendance_status);

create index idx_cb_event_guests_invited_at
    on cb_event_guests (invited_at);

grant delete, insert, references, select, trigger, truncate, update on cb_event_guests to anon;

grant delete, insert, references, select, trigger, truncate, update on cb_event_guests to authenticated;

grant delete, insert, references, select, trigger, truncate, update on cb_event_guests to service_role;

create table cb_rsvps
(
    id             uuid                     default gen_random_uuid() not null
        primary key,
    event_id       uuid                                               not null
        references cb_events
            on delete cascade,
    event_guest_id uuid
                                                                      references cb_event_guests
                                                                          on delete set null,
    contact_id     uuid
                                                                      references master_contacts (user_id)
                                                                          on delete set null,
    status         text                     default 'attending'::text not null
        constraint cb_rsvps_status_check
            check (status = ANY (ARRAY ['attending'::text, 'not_attending'::text, 'maybe'::text])),
    guests_count   smallint                 default 1                 not null,
    notes          text,
    responded_at   timestamp with time zone default now()             not null,
    created_at     timestamp with time zone default now()             not null
);

alter table cb_rsvps
    owner to postgres;

create index idx_cb_rsvps_event
    on cb_rsvps (event_id);

create index idx_cb_rsvps_guest
    on cb_rsvps (event_guest_id);

grant delete, insert, references, select, trigger, truncate, update on cb_rsvps to anon;

grant delete, insert, references, select, trigger, truncate, update on cb_rsvps to authenticated;

grant delete, insert, references, select, trigger, truncate, update on cb_rsvps to service_role;

create table cb_event_media
(
    id          uuid                     default gen_random_uuid()  not null
        primary key,
    event_id    uuid                                                not null
        references cb_events
            on delete cascade,
    type        text                     default 'invitation'::text not null,
    url         text                                                not null,
    uploaded_by uuid
                                                                    references master_contacts (user_id)
                                                                        on delete set null,
    created_at  timestamp with time zone default now()              not null
);

alter table cb_event_media
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on cb_event_media to anon;

grant delete, insert, references, select, trigger, truncate, update on cb_event_media to authenticated;

grant delete, insert, references, select, trigger, truncate, update on cb_event_media to service_role;

create table cb_messaging_queue
(
    id               uuid                     default gen_random_uuid()    not null
        primary key,
    event_guest_id   uuid                                                  not null
        references cb_event_guests
            on delete cascade,
    provider         text                     default 'email_to_sms'::text not null,
    provider_payload jsonb                    default '{}'::jsonb          not null,
    status           text                     default 'pending'::text      not null
        constraint cb_messaging_queue_status_check
            check (status = ANY (ARRAY ['pending'::text, 'sending'::text, 'sent'::text, 'failed'::text])),
    attempts         integer                  default 0                    not null,
    last_error       text,
    scheduled_at     timestamp with time zone default now()                not null,
    created_at       timestamp with time zone default now()                not null
);

alter table cb_messaging_queue
    owner to postgres;

create index idx_cb_messaging_queue_status
    on cb_messaging_queue (status);

grant delete, insert, references, select, trigger, truncate, update on cb_messaging_queue to anon;

grant delete, insert, references, select, trigger, truncate, update on cb_messaging_queue to authenticated;

grant delete, insert, references, select, trigger, truncate, update on cb_messaging_queue to service_role;

create table master_applications
(
    application_id   bigserial
        primary key,
    application_name varchar(100)                           not null
        unique,
    application_code varchar(100)                           not null
        unique,
    is_active        boolean                  default true  not null,
    created_at       timestamp with time zone default now() not null
);

alter table master_applications
    owner to postgres;

grant select, update, usage on sequence master_applications_application_id_seq to anon;

grant select, update, usage on sequence master_applications_application_id_seq to authenticated;

grant select, update, usage on sequence master_applications_application_id_seq to service_role;

grant delete, insert, references, select, trigger, truncate, update on master_applications to anon;

grant delete, insert, references, select, trigger, truncate, update on master_applications to authenticated;

grant delete, insert, references, select, trigger, truncate, update on master_applications to service_role;

create table master_modules
(
    module_id      bigserial
        primary key,
    application_id bigint                                 not null
        references master_applications
            on delete cascade,
    module_name    varchar(100)                           not null,
    module_code    varchar(100)                           not null,
    description    text,
    is_active      boolean                  default true  not null,
    created_at     timestamp with time zone default now() not null,
    constraint uq_master_modules_app_code
        unique (application_id, module_code),
    constraint uq_master_modules_app_name
        unique (application_id, module_name)
);

alter table master_modules
    owner to postgres;

grant select, update, usage on sequence master_modules_module_id_seq to anon;

grant select, update, usage on sequence master_modules_module_id_seq to authenticated;

grant select, update, usage on sequence master_modules_module_id_seq to service_role;

grant delete, insert, references, select, trigger, truncate, update on master_modules to anon;

grant delete, insert, references, select, trigger, truncate, update on master_modules to authenticated;

grant delete, insert, references, select, trigger, truncate, update on master_modules to service_role;

create table master_permissions
(
    permission_id   bigserial
        primary key,
    permission_name varchar(100)                           not null
        unique,
    permission_code varchar(100)                           not null
        unique,
    description     text,
    created_at      timestamp with time zone default now() not null
);

alter table master_permissions
    owner to postgres;

grant select, update, usage on sequence master_permissions_permission_id_seq to anon;

grant select, update, usage on sequence master_permissions_permission_id_seq to authenticated;

grant select, update, usage on sequence master_permissions_permission_id_seq to service_role;

grant delete, insert, references, select, trigger, truncate, update on master_permissions to anon;

grant delete, insert, references, select, trigger, truncate, update on master_permissions to authenticated;

grant delete, insert, references, select, trigger, truncate, update on master_permissions to service_role;

create table master_roles
(
    role_id     bigserial
        primary key,
    role_name   varchar(100)                           not null
        unique,
    role_code   varchar(100)                           not null
        unique,
    description text,
    is_active   boolean                  default true  not null,
    created_at  timestamp with time zone default now() not null
);

alter table master_roles
    owner to postgres;

grant select, update, usage on sequence master_roles_role_id_seq to anon;

grant select, update, usage on sequence master_roles_role_id_seq to authenticated;

grant select, update, usage on sequence master_roles_role_id_seq to service_role;

grant delete, insert, references, select, trigger, truncate, update on master_roles to anon;

grant delete, insert, references, select, trigger, truncate, update on master_roles to authenticated;

grant delete, insert, references, select, trigger, truncate, update on master_roles to service_role;

create table master_users
(
    user_id            bigint                   default nextval('master_users_user_id_seq1'::regclass) not null
        primary key,
    first_name         varchar(100)                                                                    not null,
    last_name          varchar(100)                                                                    not null,
    phone_number       varchar(25),
    email              varchar(255),
    address            text,
    birthday           date,
    phone_carrier      varchar(50),
    notes              text,
    number_of_invites  integer                  default 0                                              not null,
    number_attended    integer                  default 0                                              not null,
    created_at         timestamp with time zone default now()                                          not null,
    updated_at         timestamp with time zone default now()                                          not null,
    username           varchar(100)
        unique,
    password_hash      text,
    party_size         smallint                 default 4                                              not null,
    profile_image_path text
);

alter table master_users
    owner to postgres;

alter sequence master_users_user_id_seq1 owned by master_users.user_id;

grant delete, insert, references, select, trigger, truncate, update on master_users to anon;

grant delete, insert, references, select, trigger, truncate, update on master_users to authenticated;

grant delete, insert, references, select, trigger, truncate, update on master_users to service_role;

create table master_user_roles
(
    user_role_id bigserial
        primary key,
    user_id      bigint                                 not null
        references master_users
            on delete cascade,
    role_id      bigint                                 not null
        references master_roles
            on delete cascade,
    assigned_at  timestamp with time zone default now() not null,
    assigned_by  bigint
        references master_users,
    is_active    boolean                  default true  not null,
    constraint uq_master_user_roles
        unique (user_id, role_id)
);

alter table master_user_roles
    owner to postgres;

grant select, update, usage on sequence master_user_roles_user_role_id_seq to anon;

grant select, update, usage on sequence master_user_roles_user_role_id_seq to authenticated;

grant select, update, usage on sequence master_user_roles_user_role_id_seq to service_role;

grant delete, insert, references, select, trigger, truncate, update on master_user_roles to anon;

grant delete, insert, references, select, trigger, truncate, update on master_user_roles to authenticated;

grant delete, insert, references, select, trigger, truncate, update on master_user_roles to service_role;

create table master_role_module_permissions
(
    role_module_permission_id bigserial
        primary key,
    role_id                   bigint                                 not null
        references master_roles
            on delete cascade,
    module_id                 bigint                                 not null
        references master_modules
            on delete cascade,
    permission_id             bigint                                 not null
        references master_permissions
            on delete cascade,
    created_at                timestamp with time zone default now() not null,
    constraint uq_master_role_module_permission
        unique (role_id, module_id, permission_id)
);

alter table master_role_module_permissions
    owner to postgres;

grant select, update, usage on sequence master_role_module_permissions_role_module_permission_id_seq to anon;

grant select, update, usage on sequence master_role_module_permissions_role_module_permission_id_seq to authenticated;

grant select, update, usage on sequence master_role_module_permissions_role_module_permission_id_seq to service_role;

grant delete, insert, references, select, trigger, truncate, update on master_role_module_permissions to anon;

grant delete, insert, references, select, trigger, truncate, update on master_role_module_permissions to authenticated;

grant delete, insert, references, select, trigger, truncate, update on master_role_module_permissions to service_role;

create table master_user_module_access
(
    user_module_access_id bigserial
        primary key,
    user_id               bigint                                 not null
        references master_users
            on delete cascade,
    module_id             bigint                                 not null
        references master_modules
            on delete cascade,
    granted_at            timestamp with time zone default now() not null,
    granted_by            bigint
        references master_users,
    is_active             boolean                  default true  not null,
    constraint uq_master_user_module_access
        unique (user_id, module_id)
);

alter table master_user_module_access
    owner to postgres;

grant select, update, usage on sequence master_user_module_access_user_module_access_id_seq to anon;

grant select, update, usage on sequence master_user_module_access_user_module_access_id_seq to authenticated;

grant select, update, usage on sequence master_user_module_access_user_module_access_id_seq to service_role;

grant delete, insert, references, select, trigger, truncate, update on master_user_module_access to anon;

grant delete, insert, references, select, trigger, truncate, update on master_user_module_access to authenticated;

grant delete, insert, references, select, trigger, truncate, update on master_user_module_access to service_role;

create table master_user_module_permissions
(
    user_module_permission_id bigserial
        primary key,
    user_module_access_id     bigint                                 not null
        references master_user_module_access
            on delete cascade,
    permission_id             bigint                                 not null
        references master_permissions
            on delete cascade,
    granted_at                timestamp with time zone default now() not null,
    granted_by                bigint
        references master_users,
    constraint uq_master_user_module_permission
        unique (user_module_access_id, permission_id)
);

alter table master_user_module_permissions
    owner to postgres;

grant select, update, usage on sequence master_user_module_permissions_user_module_permission_id_seq to anon;

grant select, update, usage on sequence master_user_module_permissions_user_module_permission_id_seq to authenticated;

grant select, update, usage on sequence master_user_module_permissions_user_module_permission_id_seq to service_role;

grant delete, insert, references, select, trigger, truncate, update on master_user_module_permissions to anon;

grant delete, insert, references, select, trigger, truncate, update on master_user_module_permissions to authenticated;

grant delete, insert, references, select, trigger, truncate, update on master_user_module_permissions to service_role;

create table productivity_day_sessions
(
    id                      uuid                     default gen_random_uuid()             not null
        primary key,
    user_id                 bigint,
    session_date            date                     default CURRENT_DATE                  not null,
    status                  session_status           default 'not_started'::session_status not null,
    started_at              timestamp with time zone,
    ended_at                timestamp with time zone,
    active_task_id          uuid,
    total_planned_minutes   integer                  default 0                             not null,
    total_actual_minutes    integer                  default 0                             not null,
    total_extension_minutes integer                  default 0                             not null,
    created_at              timestamp with time zone default now()                         not null,
    updated_at              timestamp with time zone default now()                         not null
);

alter table productivity_day_sessions
    owner to postgres;

create index idx_productivity_sessions_user_date
    on productivity_day_sessions (user_id, session_date);

create index idx_productivity_sessions_status
    on productivity_day_sessions (status);

grant delete, insert, references, select, trigger, truncate, update on productivity_day_sessions to anon;

grant delete, insert, references, select, trigger, truncate, update on productivity_day_sessions to authenticated;

grant delete, insert, references, select, trigger, truncate, update on productivity_day_sessions to service_role;

create table productivity_tasks
(
    id                        uuid                     default gen_random_uuid()          not null
        primary key,
    session_id                uuid                                                        not null
        references productivity_day_sessions
            on delete cascade,
    parent_task_id            uuid
        references productivity_tasks
            on delete cascade,
    task_type                 task_type                default 'child'::task_type         not null,
    title                     text                                                        not null,
    display_order             integer                  default 0                          not null,
    estimated_minutes         integer,
    extension_minutes         integer                  default 0                          not null,
    actual_minutes            integer                  default 0                          not null,
    started_at                timestamp with time zone,
    expected_end_at           timestamp with time zone,
    completed_at              timestamp with time zone,
    status                    task_status              default 'not_started'::task_status not null,
    is_completed              boolean                  default false                      not null,
    auto_started              boolean                  default false                      not null,
    auto_completed_on_timeout boolean                  default false                      not null,
    created_at                timestamp with time zone default now()                      not null,
    updated_at                timestamp with time zone default now()                      not null
);

alter table productivity_tasks
    owner to postgres;

create index idx_productivity_tasks_session_order
    on productivity_tasks (session_id, display_order);

create index idx_productivity_tasks_parent
    on productivity_tasks (parent_task_id);

create index idx_productivity_tasks_status
    on productivity_tasks (status);

grant delete, insert, references, select, trigger, truncate, update on productivity_tasks to anon;

grant delete, insert, references, select, trigger, truncate, update on productivity_tasks to authenticated;

grant delete, insert, references, select, trigger, truncate, update on productivity_tasks to service_role;

create table productivity_task_events
(
    id            uuid                     default gen_random_uuid() not null
        primary key,
    task_id       uuid                                               not null
        references productivity_tasks
            on delete cascade,
    session_id    uuid                                               not null
        references productivity_day_sessions
            on delete cascade,
    event_type    task_event_type                                    not null,
    event_minutes integer,
    metadata      jsonb,
    created_at    timestamp with time zone default now()             not null
);

alter table productivity_task_events
    owner to postgres;

create index idx_task_events_task
    on productivity_task_events (task_id);

create index idx_task_events_session
    on productivity_task_events (session_id);

create index idx_task_events_type
    on productivity_task_events (event_type);

grant delete, insert, references, select, trigger, truncate, update on productivity_task_events to anon;

grant delete, insert, references, select, trigger, truncate, update on productivity_task_events to authenticated;

grant delete, insert, references, select, trigger, truncate, update on productivity_task_events to service_role;

create materialized view vw_all_transaction as
SELECT tg.date,
       tg.name,
       tg.amount,
       tg.source
FROM (SELECT tb_us_bank_transactions.date,
             tb_us_bank_transactions.name,
             tb_us_bank_transactions.amount,
             'US Bank'::text AS source
      FROM tb_us_bank_transactions
      UNION ALL
      SELECT tb_fidelity_transactions.run_date        AS date,
             tb_fidelity_transactions.action          AS name,
             tb_fidelity_transactions.amount::numeric AS amount,
             'Fidelity'::text                         AS source
      FROM tb_fidelity_transactions
      UNION ALL
      SELECT tb_first_tech_augie.posting_date    AS date,
             tb_first_tech_augie.description     AS name,
             tb_first_tech_augie.amount::numeric AS amount,
             'Augie - First Tech'::text          AS source
      FROM tb_first_tech_augie
      UNION ALL
      SELECT tb_first_tech_melissa.posting_date    AS date,
             tb_first_tech_melissa.description     AS name,
             tb_first_tech_melissa.amount::numeric AS amount,
             'Melissa - First Tech'::text          AS source
      FROM tb_first_tech_melissa
      UNION ALL
      SELECT tb_first_tech_non_monthly.posting_date    AS date,
             tb_first_tech_non_monthly.description     AS name,
             tb_first_tech_non_monthly.amount::numeric AS amount,
             'Non Monthly Bills - First Tech'::text    AS source
      FROM tb_first_tech_non_monthly
      UNION ALL
      SELECT tb_manual_transactions.date,
             tb_manual_transactions.name,
             tb_manual_transactions.amount,
             tb_manual_transactions.source
      FROM tb_manual_transactions) tg
ORDER BY tg.date DESC;

alter materialized view vw_all_transaction owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on vw_all_transaction to anon;

grant delete, insert, references, select, trigger, truncate, update on vw_all_transaction to authenticated;

grant delete, insert, references, select, trigger, truncate, update on vw_all_transaction to service_role;

create view v_all_transactions_with_tags
            (transaction_id, account_name, bank_name, date, amount, description, tag_names) as
SELECT ct.id             AS transaction_id,
       a.name            AS account_name,
       a.bank_name,
       ct.date,
       ct.amount,
       ct.description,
       array_agg(t.name) AS tag_names
FROM combined_transactions ct
         JOIN bank_account_names a ON ct.account_id = a.id
         LEFT JOIN transaction_tags tt ON ct.id = tt.transaction_id
         LEFT JOIN tags t ON t.id = tt.tag_id
GROUP BY ct.id, a.name, a.bank_name, ct.date, ct.amount, ct.description;

alter table v_all_transactions_with_tags
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on v_all_transactions_with_tags to anon;

grant delete, insert, references, select, trigger, truncate, update on v_all_transactions_with_tags to authenticated;

grant delete, insert, references, select, trigger, truncate, update on v_all_transactions_with_tags to service_role;

create view resume_summary (id, user_id, summary_text, created_at, created_by, updated_at, updated_by) as
SELECT summary.id,
       summary.user_id,
       summary.summary_text,
       summary.created_at,
       summary.created_by,
       summary.updated_at,
       summary.updated_by
FROM resume.summary;

alter table resume_summary
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on resume_summary to anon;

grant delete, insert, references, select, trigger, truncate, update on resume_summary to authenticated;

grant delete, insert, references, select, trigger, truncate, update on resume_summary to service_role;

create view resume_users
            (id, first_name, last_name, username, password, email, date_of_birth, address_street1, address_street2,
             address_city, address_state, address_zip, is_active, created_at, created_by, updated_at, updated_by)
as
SELECT users.id,
       users.first_name,
       users.last_name,
       users.username,
       users.password,
       users.email,
       users.date_of_birth,
       users.address_street1,
       users.address_street2,
       users.address_city,
       users.address_state,
       users.address_zip,
       users.is_active,
       users.created_at,
       users.created_by,
       users.updated_at,
       users.updated_by
FROM resume.users;

alter table resume_users
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on resume_users to anon;

grant delete, insert, references, select, trigger, truncate, update on resume_users to authenticated;

grant delete, insert, references, select, trigger, truncate, update on resume_users to service_role;

create view vw_accounts
            (account_pk, account_name, url, owner_pk, owner_name, login_pk, username, password, is_bill,
             has_active_bill) as
SELECT DISTINCT a.pk      AS account_pk,
                a.name    AS account_name,
                a.url,
                a.ownerpk AS owner_pk,
                o.name    AS owner_name,
                a.loginpk AS login_pk,
                l.username,
                l.password,
                CASE
                    WHEN b.pk IS NULL THEN false
                    ELSE true
                    END   AS is_bill,
                CASE
                    WHEN b.isactive IS NULL OR b.isactive = false THEN false
                    ELSE true
                    END   AS has_active_bill
FROM tb_accounts a
         LEFT JOIN tb_owner o ON a.ownerpk = o.pk
         LEFT JOIN tb_logins l ON a.loginpk = l.pk
         LEFT JOIN tb_bills b ON a.pk = b.accountfk
ORDER BY a.pk;

alter table vw_accounts
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on vw_accounts to anon;

grant delete, insert, references, select, trigger, truncate, update on vw_accounts to authenticated;

grant delete, insert, references, select, trigger, truncate, update on vw_accounts to service_role;

create view vw_bills
            (accountpk, billspk, owner, accountname, transactiondescription, balance, chargetype, payment, duedate,
             billtype, paymenttype, isincludedinmonthlypayment)
as
SELECT a.pk    AS accountpk,
       b.pk    AS billspk,
       o.name  AS owner,
       a.name  AS accountname,
       b.transactiondescription,
       b.balance,
       f.name  AS chargetype,
       b.payment,
       b.duedate,
       bt.name AS billtype,
       pt.name AS paymenttype,
       b.isincludedinmonthlypayment
FROM tb_bills b
         JOIN tb_accounts a ON b.accountfk = a.pk
         LEFT JOIN tb_type_bill bt ON b.typefk = bt.pk
         LEFT JOIN tb_type_payment pt ON b.paymenttypefk = pt.pk
         LEFT JOIN tb_owner o ON o.pk = a.ownerpk
         LEFT JOIN tb_type_bill_frequency f ON f.pk = b.frequencyfk;

alter table vw_bills
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on vw_bills to anon;

grant delete, insert, references, select, trigger, truncate, update on vw_bills to authenticated;

grant delete, insert, references, select, trigger, truncate, update on vw_bills to service_role;

create view vw_recon
            (account_name, sql, transaction_desc, transaction_date, due_date, transaction_amount, expected_amount,
             source, isfixed, accountpk, ownerpk, loginpk, billpk, priorityfk, frequencyfk, typefk, paymenttypefk,
             isincludedinmonthlypayment, isactive)
as
SELECT a.name::text                       AS account_name,
       b.sql,
       t.name                             AS transaction_desc,
       t.date                             AS transaction_date,
       b.duedate                          AS due_date,
       t.amount                           AS transaction_amount,
       b.payment * '-1'::integer::numeric AS expected_amount,
       t.source,
       b.isfixed,
       a.pk                               AS accountpk,
       a.ownerpk,
       a.loginpk,
       b.pk                               AS billpk,
       b.priorityfk,
       b.frequencyfk,
       b.typefk,
       b.paymenttypefk,
       b.isincludedinmonthlypayment,
       b.isactive
FROM tb_accounts a
         JOIN tb_bills b ON a.pk = b.accountfk
         JOIN vw_all_transaction t ON lower(t.name) ~~ (('%'::text || lower(b.sql)) || '%'::text)
WHERE (b.sql = ANY (ARRAY ['AMEX EPAYMENT'::text, 'CAPITAL ONE'::text])) AND t.amount IS NOT NULL AND
      t.amount >= (b.payment * '-1'::integer::numeric - 50::numeric) AND
      t.amount <= (b.payment * '-1'::integer::numeric + 50::numeric)
   OR (b.sql <> ALL (ARRAY ['AMEX EPAYMENT'::text, 'CAPITAL ONE'::text])) AND t.amount IS NOT NULL
ORDER BY a.pk, t.date;

alter table vw_recon
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on vw_recon to anon;

grant delete, insert, references, select, trigger, truncate, update on vw_recon to authenticated;

grant delete, insert, references, select, trigger, truncate, update on vw_recon to service_role;

create view vw_ui_bills
            (pk, owner, name, url, username, password, priority_name, isactive, transactiondescription, frequency_name,
             duedate, creditlimit, balance, payment, lastpaid, isfixed, bill_type, payment_type, sql,
             isincludedinmonthlypayment, notes)
as
SELECT b.pk,
       o.name AS owner,
       a.name,
       a.url,
       l.username,
       l.password,
       p.name AS priority_name,
       b.isactive,
       b.transactiondescription,
       f.name AS frequency_name,
       b.duedate,
       b.creditlimit,
       b.balance,
       b.payment,
       b.lastpaid,
       b.isfixed,
       t.name AS bill_type,
       y.name AS payment_type,
       b.sql,
       b.isincludedinmonthlypayment,
       b.notes
FROM tb_bills b
         LEFT JOIN tb_accounts a ON b.accountfk = a.pk
         LEFT JOIN tb_logins l ON l.pk = a.loginpk
         LEFT JOIN tb_owner o ON o.pk = a.ownerpk
         LEFT JOIN tb_type_bill_priority p ON b.priorityfk = p.pk
         LEFT JOIN tb_type_bill_frequency f ON f.pk = b.frequencyfk
         LEFT JOIN tb_type_bill t ON t.pk = b.typefk
         LEFT JOIN tb_type_payment y ON y.pk = b.paymenttypefk;

alter table vw_ui_bills
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on vw_ui_bills to anon;

grant delete, insert, references, select, trigger, truncate, update on vw_ui_bills to authenticated;

grant delete, insert, references, select, trigger, truncate, update on vw_ui_bills to service_role;

create view hb_plaid_transactions_view
            (id, user_id, item_id, account_id, transaction_id, amount, date, name, merchant_name, category, category_id,
             pending, payment_channel, personal_finance_category, location, iso_currency_code, unofficial_currency_code,
             created_at)
as
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

alter table hb_plaid_transactions_view
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on hb_plaid_transactions_view to anon;

grant delete, insert, references, select, trigger, truncate, update on hb_plaid_transactions_view to authenticated;

grant delete, insert, references, select, trigger, truncate, update on hb_plaid_transactions_view to service_role;

create view v_bill_payment_history(bill_id, bill_name, amount_due, status, cleared_dates, bank_source) as
SELECT b.id                                               AS bill_id,
       b.bill_name,
       b.amount_due,
       b.status,
       array_agg(t.date ORDER BY t.date)                  AS cleared_dates,
       (array_agg(t.bank_source ORDER BY t.date DESC))[1] AS bank_source
FROM hb_transactions t
         JOIN hb_bills b ON b.id = t.bill_id
WHERE t.bill_id IS NOT NULL
  AND b.bill_name <> 'EXCLUDED - Not a Bill'::text
GROUP BY b.id, b.bill_name, b.amount_due, b.status;

alter table v_bill_payment_history
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on v_bill_payment_history to anon;

grant delete, insert, references, select, trigger, truncate, update on v_bill_payment_history to authenticated;

grant delete, insert, references, select, trigger, truncate, update on v_bill_payment_history to service_role;

create view cb_dashboard_event_metrics
            (event_id, title, starts_at, event_status, party_size, potluck_enabled, invited_count, responded_count,
             rsvp_yes_count, rsvp_no_count, rsvp_maybe_count, attended_count, no_show_count, rsvp_yes_guest_total,
             actual_guest_total, response_rate, attendance_rate, no_show_rate)
as
SELECT e.id                                                                                                      AS event_id,
       e.title,
       e.starts_at,
       e.status                                                                                                  AS event_status,
       e.party_size,
       e.potluck_enabled,
       count(eg.id) FILTER (WHERE eg.invited = true)                                                             AS invited_count,
       count(eg.id) FILTER (WHERE eg.rsvp_status <> 'no_response'::text)                                         AS responded_count,
       count(eg.id) FILTER (WHERE eg.rsvp_status = 'attending'::text)                                            AS rsvp_yes_count,
       count(eg.id) FILTER (WHERE eg.rsvp_status = 'not_attending'::text)                                        AS rsvp_no_count,
       count(eg.id) FILTER (WHERE eg.rsvp_status = 'maybe'::text)                                                AS rsvp_maybe_count,
       count(eg.id) FILTER (WHERE eg.attendance_status = 'attended'::text)                                       AS attended_count,
       count(eg.id) FILTER (WHERE eg.rsvp_status = 'attending'::text AND eg.attendance_status =
                                                                         'no_show'::text)                        AS no_show_count,
       COALESCE(sum(eg.rsvp_guest_count) FILTER (WHERE eg.rsvp_status = 'attending'::text),
                0::bigint)                                                                                       AS rsvp_yes_guest_total,
       COALESCE(sum(eg.actual_guest_count) FILTER (WHERE eg.attendance_status = 'attended'::text),
                0::bigint)                                                                                       AS actual_guest_total,
       CASE
           WHEN count(eg.id) FILTER (WHERE eg.invited = true) = 0 THEN 0::numeric
           ELSE round(count(eg.id) FILTER (WHERE eg.rsvp_status <> 'no_response'::text)::numeric /
                      count(eg.id) FILTER (WHERE eg.invited = true)::numeric, 4)
           END                                                                                                   AS response_rate,
       CASE
           WHEN count(eg.id) FILTER (WHERE eg.invited = true) = 0 THEN 0::numeric
           ELSE round(count(eg.id) FILTER (WHERE eg.attendance_status = 'attended'::text)::numeric /
                      count(eg.id) FILTER (WHERE eg.invited = true)::numeric, 4)
           END                                                                                                   AS attendance_rate,
       CASE
           WHEN count(eg.id) FILTER (WHERE eg.rsvp_status = 'attending'::text) = 0 THEN 0::numeric
           ELSE round(count(eg.id) FILTER (WHERE eg.rsvp_status = 'attending'::text AND
                                                 eg.attendance_status = 'no_show'::text)::numeric /
                      count(eg.id) FILTER (WHERE eg.rsvp_status = 'attending'::text)::numeric, 4)
           END                                                                                                   AS no_show_rate
FROM cb_events e
         LEFT JOIN cb_event_guests eg ON eg.event_id = e.id
GROUP BY e.id, e.title, e.starts_at, e.status, e.party_size, e.potluck_enabled;

alter table cb_dashboard_event_metrics
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on cb_dashboard_event_metrics to anon;

grant delete, insert, references, select, trigger, truncate, update on cb_dashboard_event_metrics to authenticated;

grant delete, insert, references, select, trigger, truncate, update on cb_dashboard_event_metrics to service_role;

create view cb_dashboard_contact_metrics
            (contact_id, display_name, first_name, last_name, username, phone_number, email, invited_count,
             responded_count, rsvp_yes_count, attended_count, no_show_count, attendance_rate)
as
SELECT mc.id                                                                                                     AS contact_id,
       COALESCE(NULLIF(TRIM(BOTH FROM concat_ws(' '::text, mc.first_name, mc.last_name)), ''::text),
                mc.username::text)                                                                               AS display_name,
       mc.first_name,
       mc.last_name,
       mc.username,
       mc.phone_number,
       mc.email,
       count(eg.id) FILTER (WHERE eg.invited = true)                                                             AS invited_count,
       count(eg.id) FILTER (WHERE eg.rsvp_status <> 'no_response'::text)                                         AS responded_count,
       count(eg.id) FILTER (WHERE eg.rsvp_status = 'attending'::text)                                            AS rsvp_yes_count,
       count(eg.id) FILTER (WHERE eg.attendance_status = 'attended'::text)                                       AS attended_count,
       count(eg.id) FILTER (WHERE eg.rsvp_status = 'attending'::text AND eg.attendance_status =
                                                                         'no_show'::text)                        AS no_show_count,
       CASE
           WHEN count(eg.id) FILTER (WHERE eg.invited = true) = 0 THEN 0::numeric
           ELSE round(count(eg.id) FILTER (WHERE eg.attendance_status = 'attended'::text)::numeric /
                      count(eg.id) FILTER (WHERE eg.invited = true)::numeric, 4)
           END                                                                                                   AS attendance_rate
FROM master_users mc
         LEFT JOIN cb_event_guests eg ON eg.contact_id = mc.id
GROUP BY mc.id, mc.first_name, mc.last_name, mc.username, mc.phone_number, mc.email;

alter table cb_dashboard_contact_metrics
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on cb_dashboard_contact_metrics to anon;

grant delete, insert, references, select, trigger, truncate, update on cb_dashboard_contact_metrics to authenticated;

grant delete, insert, references, select, trigger, truncate, update on cb_dashboard_contact_metrics to service_role;

create view cb_dashboard_no_shows
            (event_guest_id, event_id, event_title, starts_at, contact_id, display_name, snapshot_phone, snapshot_email,
             rsvp_status, attendance_status, rsvp_guest_count, actual_guest_count)
as
SELECT eg.id            AS event_guest_id,
       eg.event_id,
       e.title          AS event_title,
       e.starts_at,
       eg.contact_id,
       eg.snapshot_name AS display_name,
       eg.snapshot_phone,
       eg.snapshot_email,
       eg.rsvp_status,
       eg.attendance_status,
       eg.rsvp_guest_count,
       eg.actual_guest_count
FROM cb_event_guests eg
         JOIN cb_events e ON e.id = eg.event_id
WHERE eg.rsvp_status = 'attending'::text
  AND eg.attendance_status = 'no_show'::text;

alter table cb_dashboard_no_shows
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on cb_dashboard_no_shows to anon;

grant delete, insert, references, select, trigger, truncate, update on cb_dashboard_no_shows to authenticated;

grant delete, insert, references, select, trigger, truncate, update on cb_dashboard_no_shows to service_role;

create view cb_dashboard_overview
            (total_invited, total_responded, total_rsvp_yes, total_attended, total_no_shows, invited_no_response,
             response_rate, attendance_rate, no_show_rate)
as
SELECT count(eg.id) FILTER (WHERE eg.invited = true)                                                             AS total_invited,
       count(eg.id) FILTER (WHERE eg.rsvp_status <> 'no_response'::text)                                         AS total_responded,
       count(eg.id) FILTER (WHERE eg.rsvp_status = 'attending'::text)                                            AS total_rsvp_yes,
       count(eg.id) FILTER (WHERE eg.attendance_status = 'attended'::text)                                       AS total_attended,
       count(eg.id) FILTER (WHERE eg.rsvp_status = 'attending'::text AND eg.attendance_status =
                                                                         'no_show'::text)                        AS total_no_shows,
       count(eg.id)
       FILTER (WHERE eg.invited = true AND eg.rsvp_status = 'no_response'::text)                                 AS invited_no_response,
       CASE
           WHEN count(eg.id) FILTER (WHERE eg.invited = true) = 0 THEN 0::numeric
           ELSE round(count(eg.id) FILTER (WHERE eg.rsvp_status <> 'no_response'::text)::numeric /
                      count(eg.id) FILTER (WHERE eg.invited = true)::numeric, 4)
           END                                                                                                   AS response_rate,
       CASE
           WHEN count(eg.id) FILTER (WHERE eg.invited = true) = 0 THEN 0::numeric
           ELSE round(count(eg.id) FILTER (WHERE eg.attendance_status = 'attended'::text)::numeric /
                      count(eg.id) FILTER (WHERE eg.invited = true)::numeric, 4)
           END                                                                                                   AS attendance_rate,
       CASE
           WHEN count(eg.id) FILTER (WHERE eg.rsvp_status = 'attending'::text) = 0 THEN 0::numeric
           ELSE round(count(eg.id) FILTER (WHERE eg.rsvp_status = 'attending'::text AND
                                                 eg.attendance_status = 'no_show'::text)::numeric /
                      count(eg.id) FILTER (WHERE eg.rsvp_status = 'attending'::text)::numeric, 4)
           END                                                                                                   AS no_show_rate
FROM cb_event_guests eg;

alter table cb_dashboard_overview
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on cb_dashboard_overview to anon;

grant delete, insert, references, select, trigger, truncate, update on cb_dashboard_overview to authenticated;

grant delete, insert, references, select, trigger, truncate, update on cb_dashboard_overview to service_role;

create view cb_dashboard_attendance_trend
            (month_bucket, invited_count, rsvp_yes_count, attended_count, no_show_count) as
SELECT date_trunc('month'::text, e.starts_at)::date                                                              AS month_bucket,
       count(eg.id) FILTER (WHERE eg.invited = true)                                                             AS invited_count,
       count(eg.id) FILTER (WHERE eg.rsvp_status = 'attending'::text)                                            AS rsvp_yes_count,
       count(eg.id) FILTER (WHERE eg.attendance_status = 'attended'::text)                                       AS attended_count,
       count(eg.id) FILTER (WHERE eg.rsvp_status = 'attending'::text AND eg.attendance_status =
                                                                         'no_show'::text)                        AS no_show_count
FROM cb_events e
         LEFT JOIN cb_event_guests eg ON eg.event_id = e.id
WHERE e.starts_at IS NOT NULL
GROUP BY (date_trunc('month'::text, e.starts_at)::date)
ORDER BY (date_trunc('month'::text, e.starts_at)::date);

alter table cb_dashboard_attendance_trend
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on cb_dashboard_attendance_trend to anon;

grant delete, insert, references, select, trigger, truncate, update on cb_dashboard_attendance_trend to authenticated;

grant delete, insert, references, select, trigger, truncate, update on cb_dashboard_attendance_trend to service_role;

create view cb_dashboard_rsvp_vs_attendance
            (event_id, title, starts_at, invited_count, rsvp_yes_count, attended_count, no_show_count) as
SELECT e.id                                                                                                      AS event_id,
       e.title,
       e.starts_at,
       count(eg.id) FILTER (WHERE eg.invited = true)                                                             AS invited_count,
       count(eg.id) FILTER (WHERE eg.rsvp_status = 'attending'::text)                                            AS rsvp_yes_count,
       count(eg.id) FILTER (WHERE eg.attendance_status = 'attended'::text)                                       AS attended_count,
       count(eg.id) FILTER (WHERE eg.rsvp_status = 'attending'::text AND eg.attendance_status =
                                                                         'no_show'::text)                        AS no_show_count
FROM cb_events e
         LEFT JOIN cb_event_guests eg ON eg.event_id = e.id
GROUP BY e.id, e.title, e.starts_at
ORDER BY e.starts_at DESC NULLS LAST, e.created_at DESC;

alter table cb_dashboard_rsvp_vs_attendance
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on cb_dashboard_rsvp_vs_attendance to anon;

grant delete, insert, references, select, trigger, truncate, update on cb_dashboard_rsvp_vs_attendance to authenticated;

grant delete, insert, references, select, trigger, truncate, update on cb_dashboard_rsvp_vs_attendance to service_role;

create view vw_user_permissions(user_id, modules_perms) as
WITH role_module_perms AS (SELECT ur.user_id,
                                  m.module_code,
                                  p.permission_code
                           FROM master_user_roles ur
                                    JOIN master_roles r ON ur.role_id = r.role_id
                                    JOIN master_role_module_permissions rmp ON r.role_id = rmp.role_id
                                    JOIN master_modules m ON rmp.module_id = m.module_id
                                    JOIN master_permissions p ON rmp.permission_id = p.permission_id
                           WHERE ur.is_active = true
                             AND r.is_active = true
                             AND m.is_active = true),
     per_module AS (SELECT role_module_perms.user_id,
                           role_module_perms.module_code,
                           jsonb_agg(DISTINCT role_module_perms.permission_code) AS permissions
                    FROM role_module_perms
                    GROUP BY role_module_perms.user_id, role_module_perms.module_code)
SELECT per_module.user_id,
       jsonb_object_agg(per_module.module_code, per_module.permissions) AS modules_perms
FROM per_module
GROUP BY per_module.user_id;

alter table vw_user_permissions
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on vw_user_permissions to anon;

grant delete, insert, references, select, trigger, truncate, update on vw_user_permissions to authenticated;

grant delete, insert, references, select, trigger, truncate, update on vw_user_permissions to service_role;

create function set_limit(real) returns real
    strict
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function set_limit(real) owner to supabase_admin;

grant execute on function set_limit(real) to postgres;

grant execute on function set_limit(real) to anon;

grant execute on function set_limit(real) to authenticated;

grant execute on function set_limit(real) to service_role;

create function show_limit() returns real
    stable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function show_limit() owner to supabase_admin;

grant execute on function show_limit() to postgres;

grant execute on function show_limit() to anon;

grant execute on function show_limit() to authenticated;

grant execute on function show_limit() to service_role;

create function show_trgm(text) returns text[]
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function show_trgm(text) owner to supabase_admin;

grant execute on function show_trgm(text) to postgres;

grant execute on function show_trgm(text) to anon;

grant execute on function show_trgm(text) to authenticated;

grant execute on function show_trgm(text) to service_role;

create function similarity(text, text) returns real
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function similarity(text, text) owner to supabase_admin;

grant execute on function similarity(text, text) to postgres;

grant execute on function similarity(text, text) to anon;

grant execute on function similarity(text, text) to authenticated;

grant execute on function similarity(text, text) to service_role;

create function similarity_op(text, text) returns boolean
    stable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function similarity_op(text, text) owner to supabase_admin;

grant execute on function similarity_op(text, text) to postgres;

grant execute on function similarity_op(text, text) to anon;

grant execute on function similarity_op(text, text) to authenticated;

grant execute on function similarity_op(text, text) to service_role;

create function word_similarity(text, text) returns real
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function word_similarity(text, text) owner to supabase_admin;

grant execute on function word_similarity(text, text) to postgres;

grant execute on function word_similarity(text, text) to anon;

grant execute on function word_similarity(text, text) to authenticated;

grant execute on function word_similarity(text, text) to service_role;

create function word_similarity_op(text, text) returns boolean
    stable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function word_similarity_op(text, text) owner to supabase_admin;

grant execute on function word_similarity_op(text, text) to postgres;

grant execute on function word_similarity_op(text, text) to anon;

grant execute on function word_similarity_op(text, text) to authenticated;

grant execute on function word_similarity_op(text, text) to service_role;

create function word_similarity_commutator_op(text, text) returns boolean
    stable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function word_similarity_commutator_op(text, text) owner to supabase_admin;

grant execute on function word_similarity_commutator_op(text, text) to postgres;

grant execute on function word_similarity_commutator_op(text, text) to anon;

grant execute on function word_similarity_commutator_op(text, text) to authenticated;

grant execute on function word_similarity_commutator_op(text, text) to service_role;

create function similarity_dist(text, text) returns real
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function similarity_dist(text, text) owner to supabase_admin;

grant execute on function similarity_dist(text, text) to postgres;

grant execute on function similarity_dist(text, text) to anon;

grant execute on function similarity_dist(text, text) to authenticated;

grant execute on function similarity_dist(text, text) to service_role;

create function word_similarity_dist_op(text, text) returns real
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function word_similarity_dist_op(text, text) owner to supabase_admin;

grant execute on function word_similarity_dist_op(text, text) to postgres;

grant execute on function word_similarity_dist_op(text, text) to anon;

grant execute on function word_similarity_dist_op(text, text) to authenticated;

grant execute on function word_similarity_dist_op(text, text) to service_role;

create function word_similarity_dist_commutator_op(text, text) returns real
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function word_similarity_dist_commutator_op(text, text) owner to supabase_admin;

grant execute on function word_similarity_dist_commutator_op(text, text) to postgres;

grant execute on function word_similarity_dist_commutator_op(text, text) to anon;

grant execute on function word_similarity_dist_commutator_op(text, text) to authenticated;

grant execute on function word_similarity_dist_commutator_op(text, text) to service_role;

create function gtrgm_in(cstring) returns gtrgm
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function gtrgm_in(cstring) owner to supabase_admin;

grant execute on function gtrgm_in(cstring) to postgres;

grant execute on function gtrgm_in(cstring) to anon;

grant execute on function gtrgm_in(cstring) to authenticated;

grant execute on function gtrgm_in(cstring) to service_role;

create function gtrgm_out(gtrgm) returns cstring
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function gtrgm_out(gtrgm) owner to supabase_admin;

grant execute on function gtrgm_out(gtrgm) to postgres;

grant execute on function gtrgm_out(gtrgm) to anon;

grant execute on function gtrgm_out(gtrgm) to authenticated;

grant execute on function gtrgm_out(gtrgm) to service_role;

create function gtrgm_consistent(internal, text, smallint, oid, internal) returns boolean
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function gtrgm_consistent(internal, text, smallint, oid, internal) owner to supabase_admin;

grant execute on function gtrgm_consistent(internal, text, smallint, oid, internal) to postgres;

grant execute on function gtrgm_consistent(internal, text, smallint, oid, internal) to anon;

grant execute on function gtrgm_consistent(internal, text, smallint, oid, internal) to authenticated;

grant execute on function gtrgm_consistent(internal, text, smallint, oid, internal) to service_role;

create function gtrgm_distance(internal, text, smallint, oid, internal) returns double precision
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function gtrgm_distance(internal, text, smallint, oid, internal) owner to supabase_admin;

grant execute on function gtrgm_distance(internal, text, smallint, oid, internal) to postgres;

grant execute on function gtrgm_distance(internal, text, smallint, oid, internal) to anon;

grant execute on function gtrgm_distance(internal, text, smallint, oid, internal) to authenticated;

grant execute on function gtrgm_distance(internal, text, smallint, oid, internal) to service_role;

create function gtrgm_compress(internal) returns internal
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function gtrgm_compress(internal) owner to supabase_admin;

grant execute on function gtrgm_compress(internal) to postgres;

grant execute on function gtrgm_compress(internal) to anon;

grant execute on function gtrgm_compress(internal) to authenticated;

grant execute on function gtrgm_compress(internal) to service_role;

create function gtrgm_decompress(internal) returns internal
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function gtrgm_decompress(internal) owner to supabase_admin;

grant execute on function gtrgm_decompress(internal) to postgres;

grant execute on function gtrgm_decompress(internal) to anon;

grant execute on function gtrgm_decompress(internal) to authenticated;

grant execute on function gtrgm_decompress(internal) to service_role;

create function gtrgm_penalty(internal, internal, internal) returns internal
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function gtrgm_penalty(internal, internal, internal) owner to supabase_admin;

grant execute on function gtrgm_penalty(internal, internal, internal) to postgres;

grant execute on function gtrgm_penalty(internal, internal, internal) to anon;

grant execute on function gtrgm_penalty(internal, internal, internal) to authenticated;

grant execute on function gtrgm_penalty(internal, internal, internal) to service_role;

create function gtrgm_picksplit(internal, internal) returns internal
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function gtrgm_picksplit(internal, internal) owner to supabase_admin;

grant execute on function gtrgm_picksplit(internal, internal) to postgres;

grant execute on function gtrgm_picksplit(internal, internal) to anon;

grant execute on function gtrgm_picksplit(internal, internal) to authenticated;

grant execute on function gtrgm_picksplit(internal, internal) to service_role;

create function gtrgm_union(internal, internal) returns gtrgm
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function gtrgm_union(internal, internal) owner to supabase_admin;

grant execute on function gtrgm_union(internal, internal) to postgres;

grant execute on function gtrgm_union(internal, internal) to anon;

grant execute on function gtrgm_union(internal, internal) to authenticated;

grant execute on function gtrgm_union(internal, internal) to service_role;

create function gtrgm_same(gtrgm, gtrgm, internal) returns internal
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function gtrgm_same(gtrgm, gtrgm, internal) owner to supabase_admin;

grant execute on function gtrgm_same(gtrgm, gtrgm, internal) to postgres;

grant execute on function gtrgm_same(gtrgm, gtrgm, internal) to anon;

grant execute on function gtrgm_same(gtrgm, gtrgm, internal) to authenticated;

grant execute on function gtrgm_same(gtrgm, gtrgm, internal) to service_role;

create function gin_extract_value_trgm(text, internal) returns internal
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function gin_extract_value_trgm(text, internal) owner to supabase_admin;

grant execute on function gin_extract_value_trgm(text, internal) to postgres;

grant execute on function gin_extract_value_trgm(text, internal) to anon;

grant execute on function gin_extract_value_trgm(text, internal) to authenticated;

grant execute on function gin_extract_value_trgm(text, internal) to service_role;

create function gin_extract_query_trgm(text, internal, smallint, internal, internal, internal, internal) returns internal
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function gin_extract_query_trgm(text, internal, smallint, internal, internal, internal, internal) owner to supabase_admin;

grant execute on function gin_extract_query_trgm(text, internal, smallint, internal, internal, internal, internal) to postgres;

grant execute on function gin_extract_query_trgm(text, internal, smallint, internal, internal, internal, internal) to anon;

grant execute on function gin_extract_query_trgm(text, internal, smallint, internal, internal, internal, internal) to authenticated;

grant execute on function gin_extract_query_trgm(text, internal, smallint, internal, internal, internal, internal) to service_role;

create function gin_trgm_consistent(internal, smallint, text, integer, internal, internal, internal, internal) returns boolean
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function gin_trgm_consistent(internal, smallint, text, integer, internal, internal, internal, internal) owner to supabase_admin;

grant execute on function gin_trgm_consistent(internal, smallint, text, integer, internal, internal, internal, internal) to postgres;

grant execute on function gin_trgm_consistent(internal, smallint, text, integer, internal, internal, internal, internal) to anon;

grant execute on function gin_trgm_consistent(internal, smallint, text, integer, internal, internal, internal, internal) to authenticated;

grant execute on function gin_trgm_consistent(internal, smallint, text, integer, internal, internal, internal, internal) to service_role;

create function gin_trgm_triconsistent(internal, smallint, text, integer, internal, internal, internal) returns "char"
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function gin_trgm_triconsistent(internal, smallint, text, integer, internal, internal, internal) owner to supabase_admin;

grant execute on function gin_trgm_triconsistent(internal, smallint, text, integer, internal, internal, internal) to postgres;

grant execute on function gin_trgm_triconsistent(internal, smallint, text, integer, internal, internal, internal) to anon;

grant execute on function gin_trgm_triconsistent(internal, smallint, text, integer, internal, internal, internal) to authenticated;

grant execute on function gin_trgm_triconsistent(internal, smallint, text, integer, internal, internal, internal) to service_role;

create function strict_word_similarity(text, text) returns real
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function strict_word_similarity(text, text) owner to supabase_admin;

grant execute on function strict_word_similarity(text, text) to postgres;

grant execute on function strict_word_similarity(text, text) to anon;

grant execute on function strict_word_similarity(text, text) to authenticated;

grant execute on function strict_word_similarity(text, text) to service_role;

create function strict_word_similarity_op(text, text) returns boolean
    stable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function strict_word_similarity_op(text, text) owner to supabase_admin;

grant execute on function strict_word_similarity_op(text, text) to postgres;

grant execute on function strict_word_similarity_op(text, text) to anon;

grant execute on function strict_word_similarity_op(text, text) to authenticated;

grant execute on function strict_word_similarity_op(text, text) to service_role;

create function strict_word_similarity_commutator_op(text, text) returns boolean
    stable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function strict_word_similarity_commutator_op(text, text) owner to supabase_admin;

grant execute on function strict_word_similarity_commutator_op(text, text) to postgres;

grant execute on function strict_word_similarity_commutator_op(text, text) to anon;

grant execute on function strict_word_similarity_commutator_op(text, text) to authenticated;

grant execute on function strict_word_similarity_commutator_op(text, text) to service_role;

create function strict_word_similarity_dist_op(text, text) returns real
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function strict_word_similarity_dist_op(text, text) owner to supabase_admin;

grant execute on function strict_word_similarity_dist_op(text, text) to postgres;

grant execute on function strict_word_similarity_dist_op(text, text) to anon;

grant execute on function strict_word_similarity_dist_op(text, text) to authenticated;

grant execute on function strict_word_similarity_dist_op(text, text) to service_role;

create function strict_word_similarity_dist_commutator_op(text, text) returns real
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function strict_word_similarity_dist_commutator_op(text, text) owner to supabase_admin;

grant execute on function strict_word_similarity_dist_commutator_op(text, text) to postgres;

grant execute on function strict_word_similarity_dist_commutator_op(text, text) to anon;

grant execute on function strict_word_similarity_dist_commutator_op(text, text) to authenticated;

grant execute on function strict_word_similarity_dist_commutator_op(text, text) to service_role;

create function gtrgm_options(internal) returns void
    immutable
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function gtrgm_options(internal) owner to supabase_admin;

grant execute on function gtrgm_options(internal) to postgres;

grant execute on function gtrgm_options(internal) to anon;

grant execute on function gtrgm_options(internal) to authenticated;

grant execute on function gtrgm_options(internal) to service_role;

create function get_all_transactions()
    returns TABLE(date date, name text, amount numeric, source text)
    language plpgsql
as
$$
BEGIN
  RETURN QUERY
  SELECT * FROM (
    SELECT date, name as name, amount::numeric, 'US Bank' AS source FROM tb_us_bank_transactions 
    UNION ALL
    SELECT run_date AS date, action as name, amount::numeric, 'Fidelity' AS source FROM tb_fidelity_transactions
    UNION ALL 
    SELECT "Posting Date"::date as date, "Description" as name, "Amount"::numeric as amount, 'Bills - First Tech' as source FROM tb_first_tech_augie
    UNION ALL
    SELECT "Posting Date"::date as date, "Description" as name, "Amount"::numeric as amount, 'Intake - First Tech' as source FROM tb_first_tech_non_monthly_bills
    UNION ALL
    SELECT date, name, amount, source FROM tb_manual_transactions
  ) AS tg
  ORDER BY 1 DESC;
END;
$$;

alter function get_all_transactions() owner to postgres;

grant execute on function get_all_transactions() to anon;

grant execute on function get_all_transactions() to authenticated;

grant execute on function get_all_transactions() to service_role;

create function get_all_transactions_from_view() returns SETOF v_all_transactions_with_tags
    language sql
as
$$select * from v_all_transactions_with_tags
order by date desc;$$;

alter function get_all_transactions_from_view() owner to postgres;

grant execute on function get_all_transactions_from_view() to anon;

grant execute on function get_all_transactions_from_view() to authenticated;

grant execute on function get_all_transactions_from_view() to service_role;

create function handle_new_user() returns trigger
    security definer
    language plpgsql
as
$$
begin
  insert into public.profiles (id, full_name, avatar_url)
  values (new.id, new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'avatar_url');
  return new;
end;
$$;

alter function handle_new_user() owner to postgres;

grant execute on function handle_new_user() to anon;

grant execute on function handle_new_user() to authenticated;

grant execute on function handle_new_user() to service_role;

create function log_transaction_insert() returns trigger
    language plpgsql
as
$$
BEGIN
  INSERT INTO transaction_history (
    original_transaction_id,
    account_id,
    date,
    amount,
    description,
    tags,
    change_type
  )
  VALUES (
    NEW.id,
    NEW.account_id,
    NEW.date,
    NEW.amount,
    NEW.description,
    NEW.tags,
    'insert'
  );
  RETURN NEW;
END;
$$;

alter function log_transaction_insert() owner to postgres;

create trigger trigger_log_insert
    after insert
    on combined_transactions
    for each row
execute procedure log_transaction_insert();

grant execute on function log_transaction_insert() to anon;

grant execute on function log_transaction_insert() to authenticated;

grant execute on function log_transaction_insert() to service_role;

create function log_transaction_update() returns trigger
    language plpgsql
as
$$
BEGIN
  INSERT INTO transaction_history (
    original_transaction_id,
    account_id,
    date,
    amount,
    description,
    tags,
    change_type
  )
  VALUES (
    NEW.id,
    NEW.account_id,
    NEW.date,
    NEW.amount,
    NEW.description,
    NEW.tags,
    'update'
  );
  RETURN NEW;
END;
$$;

alter function log_transaction_update() owner to postgres;

create trigger trigger_log_update
    after update
    on combined_transactions
    for each row
execute procedure log_transaction_update();

grant execute on function log_transaction_update() to anon;

grant execute on function log_transaction_update() to authenticated;

grant execute on function log_transaction_update() to service_role;

create function recon_query_function()
    returns TABLE(account_name text, sql text, transaction_desc text, transaction_date date, due_date text, transaction_amount numeric, expected_amount numeric, source text, isfixed boolean, accountpk integer, ownerpk integer, loginpk integer, billpk integer, priorityfk integer, frequencyfk integer, typefk integer, paymenttypefk integer, isincludedinmonthlypayment boolean, isactive boolean)
    language plpgsql
as
$$BEGIN
  RETURN QUERY
  SELECT a.name::text as account_name,
         b.sql::text,
         t.name::text as transaction_desc,
         t.date as transaction_date,
         b.duedate::text as due_date, -- Cast to text
         t.amount as transaction_amount,
         b.payment as expected_amount,
         t.source::text,
         b.isfixed, 
         a.pk as accountpk,
         a.ownerpk,
         a.loginpk,
         b.pk as billpk,
         b.priorityfk,
         b.frequencyfk,
         b.typefk,
         b.paymenttypefk,
         b.isincludedinmonthlypayment,
         b.isactive
  FROM tb_accounts a
  JOIN tb_bills b ON a.pk = b.accountfk
  LEFT JOIN v_all_transactions_with_tags t ON lower(t.name) LIKE '%' || lower(b.sql) || '%'
  WHERE (t.amount is null OR t.amount < -.99)
  ORDER BY t.date, a.name;
END;$$;

alter function recon_query_function() owner to postgres;

grant execute on function recon_query_function() to anon;

grant execute on function recon_query_function() to authenticated;

grant execute on function recon_query_function() to service_role;

create function refresh_vw_all_transaction_materialized_view() returns void
    language plpgsql
as
$$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY vw_all_transaction;
END;
$$;

alter function refresh_vw_all_transaction_materialized_view() owner to postgres;

grant execute on function refresh_vw_all_transaction_materialized_view() to anon;

grant execute on function refresh_vw_all_transaction_materialized_view() to authenticated;

grant execute on function refresh_vw_all_transaction_materialized_view() to service_role;

create function update_updated_at_column() returns trigger
    language plpgsql
as
$$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;

alter function update_updated_at_column() owner to postgres;

create trigger update_plaid_items_updated_at
    before update
    on hb_plaid_items
    for each row
execute procedure update_updated_at_column();

create trigger update_plaid_accounts_updated_at
    before update
    on hb_plaid_accounts
    for each row
execute procedure update_updated_at_column();

create trigger update_transaction_categories_updated_at
    before update
    on hb_transaction_categories
    for each row
execute procedure update_updated_at_column();

create trigger update_transactions_updated_at
    before update
    on hb_transactions
    for each row
execute procedure update_updated_at_column();

create trigger update_bank_accounts_updated_at
    before update
    on hb_bank_accounts
    for each row
execute procedure update_updated_at_column();

create trigger update_categorization_rules_updated_at
    before update
    on hb_categorization_rules
    for each row
execute procedure update_updated_at_column();

create trigger update_error_logs_updated_at
    before update
    on hb_error_logs
    for each row
execute procedure update_updated_at_column();

create trigger update_hb_matching_patterns_updated_at
    before update
    on hb_matching_patterns
    for each row
execute procedure update_updated_at_column();

create trigger update_shop_receipts_updated_at
    before update
    on shop_receipts
    for each row
execute procedure update_updated_at_column();

create trigger trg_update_sessions_updated_at
    before update
    on productivity_day_sessions
    for each row
execute procedure update_updated_at_column();

create trigger trg_update_tasks_updated_at
    before update
    on productivity_tasks
    for each row
execute procedure update_updated_at_column();

grant execute on function update_updated_at_column() to anon;

grant execute on function update_updated_at_column() to authenticated;

grant execute on function update_updated_at_column() to service_role;

create function vector_in(cstring, oid, integer) returns vector
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function vector_in(cstring, oid, integer) owner to supabase_admin;

grant execute on function vector_in(cstring, oid, integer) to postgres;

grant execute on function vector_in(cstring, oid, integer) to anon;

grant execute on function vector_in(cstring, oid, integer) to authenticated;

grant execute on function vector_in(cstring, oid, integer) to service_role;

create function vector_out(vector) returns cstring
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function vector_out(vector) owner to supabase_admin;

grant execute on function vector_out(vector) to postgres;

grant execute on function vector_out(vector) to anon;

grant execute on function vector_out(vector) to authenticated;

grant execute on function vector_out(vector) to service_role;

create function vector_typmod_in(cstring[]) returns integer
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function vector_typmod_in(cstring[]) owner to supabase_admin;

grant execute on function vector_typmod_in(cstring[]) to postgres;

grant execute on function vector_typmod_in(cstring[]) to anon;

grant execute on function vector_typmod_in(cstring[]) to authenticated;

grant execute on function vector_typmod_in(cstring[]) to service_role;

create function vector_recv(internal, oid, integer) returns vector
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function vector_recv(internal, oid, integer) owner to supabase_admin;

grant execute on function vector_recv(internal, oid, integer) to postgres;

grant execute on function vector_recv(internal, oid, integer) to anon;

grant execute on function vector_recv(internal, oid, integer) to authenticated;

grant execute on function vector_recv(internal, oid, integer) to service_role;

create function vector_send(vector) returns bytea
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function vector_send(vector) owner to supabase_admin;

grant execute on function vector_send(vector) to postgres;

grant execute on function vector_send(vector) to anon;

grant execute on function vector_send(vector) to authenticated;

grant execute on function vector_send(vector) to service_role;

create function l2_distance(vector, vector) returns double precision
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function l2_distance(vector, vector) owner to supabase_admin;

grant execute on function l2_distance(vector, vector) to postgres;

grant execute on function l2_distance(vector, vector) to anon;

grant execute on function l2_distance(vector, vector) to authenticated;

grant execute on function l2_distance(vector, vector) to service_role;

create function inner_product(vector, vector) returns double precision
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function inner_product(vector, vector) owner to supabase_admin;

grant execute on function inner_product(vector, vector) to postgres;

grant execute on function inner_product(vector, vector) to anon;

grant execute on function inner_product(vector, vector) to authenticated;

grant execute on function inner_product(vector, vector) to service_role;

create function cosine_distance(vector, vector) returns double precision
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function cosine_distance(vector, vector) owner to supabase_admin;

grant execute on function cosine_distance(vector, vector) to postgres;

grant execute on function cosine_distance(vector, vector) to anon;

grant execute on function cosine_distance(vector, vector) to authenticated;

grant execute on function cosine_distance(vector, vector) to service_role;

create function l1_distance(vector, vector) returns double precision
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function l1_distance(vector, vector) owner to supabase_admin;

grant execute on function l1_distance(vector, vector) to postgres;

grant execute on function l1_distance(vector, vector) to anon;

grant execute on function l1_distance(vector, vector) to authenticated;

grant execute on function l1_distance(vector, vector) to service_role;

create function vector_dims(vector) returns integer
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function vector_dims(vector) owner to supabase_admin;

grant execute on function vector_dims(vector) to postgres;

grant execute on function vector_dims(vector) to anon;

grant execute on function vector_dims(vector) to authenticated;

grant execute on function vector_dims(vector) to service_role;

create function vector_norm(vector) returns double precision
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function vector_norm(vector) owner to supabase_admin;

grant execute on function vector_norm(vector) to postgres;

grant execute on function vector_norm(vector) to anon;

grant execute on function vector_norm(vector) to authenticated;

grant execute on function vector_norm(vector) to service_role;

create function l2_normalize(vector) returns vector
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function l2_normalize(vector) owner to supabase_admin;

grant execute on function l2_normalize(vector) to postgres;

grant execute on function l2_normalize(vector) to anon;

grant execute on function l2_normalize(vector) to authenticated;

grant execute on function l2_normalize(vector) to service_role;

create function binary_quantize(vector) returns bit
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function binary_quantize(vector) owner to supabase_admin;

grant execute on function binary_quantize(vector) to postgres;

grant execute on function binary_quantize(vector) to anon;

grant execute on function binary_quantize(vector) to authenticated;

grant execute on function binary_quantize(vector) to service_role;

create function subvector(vector, integer, integer) returns vector
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function subvector(vector, integer, integer) owner to supabase_admin;

grant execute on function subvector(vector, integer, integer) to postgres;

grant execute on function subvector(vector, integer, integer) to anon;

grant execute on function subvector(vector, integer, integer) to authenticated;

grant execute on function subvector(vector, integer, integer) to service_role;

create function vector_add(vector, vector) returns vector
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function vector_add(vector, vector) owner to supabase_admin;

grant execute on function vector_add(vector, vector) to postgres;

grant execute on function vector_add(vector, vector) to anon;

grant execute on function vector_add(vector, vector) to authenticated;

grant execute on function vector_add(vector, vector) to service_role;

create function vector_sub(vector, vector) returns vector
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function vector_sub(vector, vector) owner to supabase_admin;

grant execute on function vector_sub(vector, vector) to postgres;

grant execute on function vector_sub(vector, vector) to anon;

grant execute on function vector_sub(vector, vector) to authenticated;

grant execute on function vector_sub(vector, vector) to service_role;

create function vector_mul(vector, vector) returns vector
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function vector_mul(vector, vector) owner to supabase_admin;

grant execute on function vector_mul(vector, vector) to postgres;

grant execute on function vector_mul(vector, vector) to anon;

grant execute on function vector_mul(vector, vector) to authenticated;

grant execute on function vector_mul(vector, vector) to service_role;

create function vector_concat(vector, vector) returns vector
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function vector_concat(vector, vector) owner to supabase_admin;

grant execute on function vector_concat(vector, vector) to postgres;

grant execute on function vector_concat(vector, vector) to anon;

grant execute on function vector_concat(vector, vector) to authenticated;

grant execute on function vector_concat(vector, vector) to service_role;

create function vector_lt(vector, vector) returns boolean
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function vector_lt(vector, vector) owner to supabase_admin;

grant execute on function vector_lt(vector, vector) to postgres;

grant execute on function vector_lt(vector, vector) to anon;

grant execute on function vector_lt(vector, vector) to authenticated;

grant execute on function vector_lt(vector, vector) to service_role;

create function vector_le(vector, vector) returns boolean
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function vector_le(vector, vector) owner to supabase_admin;

grant execute on function vector_le(vector, vector) to postgres;

grant execute on function vector_le(vector, vector) to anon;

grant execute on function vector_le(vector, vector) to authenticated;

grant execute on function vector_le(vector, vector) to service_role;

create function vector_eq(vector, vector) returns boolean
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function vector_eq(vector, vector) owner to supabase_admin;

grant execute on function vector_eq(vector, vector) to postgres;

grant execute on function vector_eq(vector, vector) to anon;

grant execute on function vector_eq(vector, vector) to authenticated;

grant execute on function vector_eq(vector, vector) to service_role;

create function vector_ne(vector, vector) returns boolean
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function vector_ne(vector, vector) owner to supabase_admin;

grant execute on function vector_ne(vector, vector) to postgres;

grant execute on function vector_ne(vector, vector) to anon;

grant execute on function vector_ne(vector, vector) to authenticated;

grant execute on function vector_ne(vector, vector) to service_role;

create function vector_ge(vector, vector) returns boolean
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function vector_ge(vector, vector) owner to supabase_admin;

grant execute on function vector_ge(vector, vector) to postgres;

grant execute on function vector_ge(vector, vector) to anon;

grant execute on function vector_ge(vector, vector) to authenticated;

grant execute on function vector_ge(vector, vector) to service_role;

create function vector_gt(vector, vector) returns boolean
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function vector_gt(vector, vector) owner to supabase_admin;

grant execute on function vector_gt(vector, vector) to postgres;

grant execute on function vector_gt(vector, vector) to anon;

grant execute on function vector_gt(vector, vector) to authenticated;

grant execute on function vector_gt(vector, vector) to service_role;

create function vector_cmp(vector, vector) returns integer
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function vector_cmp(vector, vector) owner to supabase_admin;

grant execute on function vector_cmp(vector, vector) to postgres;

grant execute on function vector_cmp(vector, vector) to anon;

grant execute on function vector_cmp(vector, vector) to authenticated;

grant execute on function vector_cmp(vector, vector) to service_role;

create function vector_l2_squared_distance(vector, vector) returns double precision
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function vector_l2_squared_distance(vector, vector) owner to supabase_admin;

grant execute on function vector_l2_squared_distance(vector, vector) to postgres;

grant execute on function vector_l2_squared_distance(vector, vector) to anon;

grant execute on function vector_l2_squared_distance(vector, vector) to authenticated;

grant execute on function vector_l2_squared_distance(vector, vector) to service_role;

create function vector_negative_inner_product(vector, vector) returns double precision
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function vector_negative_inner_product(vector, vector) owner to supabase_admin;

grant execute on function vector_negative_inner_product(vector, vector) to postgres;

grant execute on function vector_negative_inner_product(vector, vector) to anon;

grant execute on function vector_negative_inner_product(vector, vector) to authenticated;

grant execute on function vector_negative_inner_product(vector, vector) to service_role;

create function vector_spherical_distance(vector, vector) returns double precision
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function vector_spherical_distance(vector, vector) owner to supabase_admin;

grant execute on function vector_spherical_distance(vector, vector) to postgres;

grant execute on function vector_spherical_distance(vector, vector) to anon;

grant execute on function vector_spherical_distance(vector, vector) to authenticated;

grant execute on function vector_spherical_distance(vector, vector) to service_role;

create function vector_accum(double precision[], vector) returns double precision[]
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function vector_accum(double precision[], vector) owner to supabase_admin;

grant execute on function vector_accum(double precision[], vector) to postgres;

grant execute on function vector_accum(double precision[], vector) to anon;

grant execute on function vector_accum(double precision[], vector) to authenticated;

grant execute on function vector_accum(double precision[], vector) to service_role;

create function vector_avg(double precision[]) returns vector
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function vector_avg(double precision[]) owner to supabase_admin;

grant execute on function vector_avg(double precision[]) to postgres;

grant execute on function vector_avg(double precision[]) to anon;

grant execute on function vector_avg(double precision[]) to authenticated;

grant execute on function vector_avg(double precision[]) to service_role;

create function vector_combine(double precision[], double precision[]) returns double precision[]
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function vector_combine(double precision[], double precision[]) owner to supabase_admin;

grant execute on function vector_combine(double precision[], double precision[]) to postgres;

grant execute on function vector_combine(double precision[], double precision[]) to anon;

grant execute on function vector_combine(double precision[], double precision[]) to authenticated;

grant execute on function vector_combine(double precision[], double precision[]) to service_role;

create function vector(vector, integer, boolean) returns vector
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function vector(vector, integer, boolean) owner to supabase_admin;

grant execute on function vector(vector, integer, boolean) to postgres;

grant execute on function vector(vector, integer, boolean) to anon;

grant execute on function vector(vector, integer, boolean) to authenticated;

grant execute on function vector(vector, integer, boolean) to service_role;

create function array_to_vector(integer[], integer, boolean) returns vector
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function array_to_vector(integer[], integer, boolean) owner to supabase_admin;

grant execute on function array_to_vector(integer[], integer, boolean) to postgres;

grant execute on function array_to_vector(integer[], integer, boolean) to anon;

grant execute on function array_to_vector(integer[], integer, boolean) to authenticated;

grant execute on function array_to_vector(integer[], integer, boolean) to service_role;

create function array_to_vector(real[], integer, boolean) returns vector
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function array_to_vector(real[], integer, boolean) owner to supabase_admin;

grant execute on function array_to_vector(real[], integer, boolean) to postgres;

grant execute on function array_to_vector(real[], integer, boolean) to anon;

grant execute on function array_to_vector(real[], integer, boolean) to authenticated;

grant execute on function array_to_vector(real[], integer, boolean) to service_role;

create function array_to_vector(double precision[], integer, boolean) returns vector
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function array_to_vector(double precision[], integer, boolean) owner to supabase_admin;

grant execute on function array_to_vector(double precision[], integer, boolean) to postgres;

grant execute on function array_to_vector(double precision[], integer, boolean) to anon;

grant execute on function array_to_vector(double precision[], integer, boolean) to authenticated;

grant execute on function array_to_vector(double precision[], integer, boolean) to service_role;

create function array_to_vector(numeric[], integer, boolean) returns vector
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function array_to_vector(numeric[], integer, boolean) owner to supabase_admin;

grant execute on function array_to_vector(numeric[], integer, boolean) to postgres;

grant execute on function array_to_vector(numeric[], integer, boolean) to anon;

grant execute on function array_to_vector(numeric[], integer, boolean) to authenticated;

grant execute on function array_to_vector(numeric[], integer, boolean) to service_role;

create function vector_to_float4(vector, integer, boolean) returns real[]
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function vector_to_float4(vector, integer, boolean) owner to supabase_admin;

grant execute on function vector_to_float4(vector, integer, boolean) to postgres;

grant execute on function vector_to_float4(vector, integer, boolean) to anon;

grant execute on function vector_to_float4(vector, integer, boolean) to authenticated;

grant execute on function vector_to_float4(vector, integer, boolean) to service_role;

create function ivfflathandler(internal) returns index_am_handler
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function ivfflathandler(internal) owner to supabase_admin;

grant execute on function ivfflathandler(internal) to postgres;

grant execute on function ivfflathandler(internal) to anon;

grant execute on function ivfflathandler(internal) to authenticated;

grant execute on function ivfflathandler(internal) to service_role;

create function hnswhandler(internal) returns index_am_handler
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function hnswhandler(internal) owner to supabase_admin;

grant execute on function hnswhandler(internal) to postgres;

grant execute on function hnswhandler(internal) to anon;

grant execute on function hnswhandler(internal) to authenticated;

grant execute on function hnswhandler(internal) to service_role;

create function ivfflat_halfvec_support(internal) returns internal
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function ivfflat_halfvec_support(internal) owner to supabase_admin;

grant execute on function ivfflat_halfvec_support(internal) to postgres;

grant execute on function ivfflat_halfvec_support(internal) to anon;

grant execute on function ivfflat_halfvec_support(internal) to authenticated;

grant execute on function ivfflat_halfvec_support(internal) to service_role;

create function ivfflat_bit_support(internal) returns internal
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function ivfflat_bit_support(internal) owner to supabase_admin;

grant execute on function ivfflat_bit_support(internal) to postgres;

grant execute on function ivfflat_bit_support(internal) to anon;

grant execute on function ivfflat_bit_support(internal) to authenticated;

grant execute on function ivfflat_bit_support(internal) to service_role;

create function hnsw_halfvec_support(internal) returns internal
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function hnsw_halfvec_support(internal) owner to supabase_admin;

grant execute on function hnsw_halfvec_support(internal) to postgres;

grant execute on function hnsw_halfvec_support(internal) to anon;

grant execute on function hnsw_halfvec_support(internal) to authenticated;

grant execute on function hnsw_halfvec_support(internal) to service_role;

create function hnsw_bit_support(internal) returns internal
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function hnsw_bit_support(internal) owner to supabase_admin;

grant execute on function hnsw_bit_support(internal) to postgres;

grant execute on function hnsw_bit_support(internal) to anon;

grant execute on function hnsw_bit_support(internal) to authenticated;

grant execute on function hnsw_bit_support(internal) to service_role;

create function hnsw_sparsevec_support(internal) returns internal
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function hnsw_sparsevec_support(internal) owner to supabase_admin;

grant execute on function hnsw_sparsevec_support(internal) to postgres;

grant execute on function hnsw_sparsevec_support(internal) to anon;

grant execute on function hnsw_sparsevec_support(internal) to authenticated;

grant execute on function hnsw_sparsevec_support(internal) to service_role;

create function halfvec_in(cstring, oid, integer) returns halfvec
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function halfvec_in(cstring, oid, integer) owner to supabase_admin;

grant execute on function halfvec_in(cstring, oid, integer) to postgres;

grant execute on function halfvec_in(cstring, oid, integer) to anon;

grant execute on function halfvec_in(cstring, oid, integer) to authenticated;

grant execute on function halfvec_in(cstring, oid, integer) to service_role;

create function halfvec_out(halfvec) returns cstring
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function halfvec_out(halfvec) owner to supabase_admin;

grant execute on function halfvec_out(halfvec) to postgres;

grant execute on function halfvec_out(halfvec) to anon;

grant execute on function halfvec_out(halfvec) to authenticated;

grant execute on function halfvec_out(halfvec) to service_role;

create function halfvec_typmod_in(cstring[]) returns integer
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function halfvec_typmod_in(cstring[]) owner to supabase_admin;

grant execute on function halfvec_typmod_in(cstring[]) to postgres;

grant execute on function halfvec_typmod_in(cstring[]) to anon;

grant execute on function halfvec_typmod_in(cstring[]) to authenticated;

grant execute on function halfvec_typmod_in(cstring[]) to service_role;

create function halfvec_recv(internal, oid, integer) returns halfvec
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function halfvec_recv(internal, oid, integer) owner to supabase_admin;

grant execute on function halfvec_recv(internal, oid, integer) to postgres;

grant execute on function halfvec_recv(internal, oid, integer) to anon;

grant execute on function halfvec_recv(internal, oid, integer) to authenticated;

grant execute on function halfvec_recv(internal, oid, integer) to service_role;

create function halfvec_send(halfvec) returns bytea
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function halfvec_send(halfvec) owner to supabase_admin;

grant execute on function halfvec_send(halfvec) to postgres;

grant execute on function halfvec_send(halfvec) to anon;

grant execute on function halfvec_send(halfvec) to authenticated;

grant execute on function halfvec_send(halfvec) to service_role;

create function l2_distance(halfvec, halfvec) returns double precision
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function l2_distance(halfvec, halfvec) owner to supabase_admin;

grant execute on function l2_distance(halfvec, halfvec) to postgres;

grant execute on function l2_distance(halfvec, halfvec) to anon;

grant execute on function l2_distance(halfvec, halfvec) to authenticated;

grant execute on function l2_distance(halfvec, halfvec) to service_role;

create function inner_product(halfvec, halfvec) returns double precision
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function inner_product(halfvec, halfvec) owner to supabase_admin;

grant execute on function inner_product(halfvec, halfvec) to postgres;

grant execute on function inner_product(halfvec, halfvec) to anon;

grant execute on function inner_product(halfvec, halfvec) to authenticated;

grant execute on function inner_product(halfvec, halfvec) to service_role;

create function cosine_distance(halfvec, halfvec) returns double precision
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function cosine_distance(halfvec, halfvec) owner to supabase_admin;

grant execute on function cosine_distance(halfvec, halfvec) to postgres;

grant execute on function cosine_distance(halfvec, halfvec) to anon;

grant execute on function cosine_distance(halfvec, halfvec) to authenticated;

grant execute on function cosine_distance(halfvec, halfvec) to service_role;

create function l1_distance(halfvec, halfvec) returns double precision
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function l1_distance(halfvec, halfvec) owner to supabase_admin;

grant execute on function l1_distance(halfvec, halfvec) to postgres;

grant execute on function l1_distance(halfvec, halfvec) to anon;

grant execute on function l1_distance(halfvec, halfvec) to authenticated;

grant execute on function l1_distance(halfvec, halfvec) to service_role;

create function vector_dims(halfvec) returns integer
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function vector_dims(halfvec) owner to supabase_admin;

grant execute on function vector_dims(halfvec) to postgres;

grant execute on function vector_dims(halfvec) to anon;

grant execute on function vector_dims(halfvec) to authenticated;

grant execute on function vector_dims(halfvec) to service_role;

create function l2_norm(halfvec) returns double precision
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function l2_norm(halfvec) owner to supabase_admin;

grant execute on function l2_norm(halfvec) to postgres;

grant execute on function l2_norm(halfvec) to anon;

grant execute on function l2_norm(halfvec) to authenticated;

grant execute on function l2_norm(halfvec) to service_role;

create function l2_normalize(halfvec) returns halfvec
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function l2_normalize(halfvec) owner to supabase_admin;

grant execute on function l2_normalize(halfvec) to postgres;

grant execute on function l2_normalize(halfvec) to anon;

grant execute on function l2_normalize(halfvec) to authenticated;

grant execute on function l2_normalize(halfvec) to service_role;

create function binary_quantize(halfvec) returns bit
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function binary_quantize(halfvec) owner to supabase_admin;

grant execute on function binary_quantize(halfvec) to postgres;

grant execute on function binary_quantize(halfvec) to anon;

grant execute on function binary_quantize(halfvec) to authenticated;

grant execute on function binary_quantize(halfvec) to service_role;

create function subvector(halfvec, integer, integer) returns halfvec
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function subvector(halfvec, integer, integer) owner to supabase_admin;

grant execute on function subvector(halfvec, integer, integer) to postgres;

grant execute on function subvector(halfvec, integer, integer) to anon;

grant execute on function subvector(halfvec, integer, integer) to authenticated;

grant execute on function subvector(halfvec, integer, integer) to service_role;

create function halfvec_add(halfvec, halfvec) returns halfvec
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function halfvec_add(halfvec, halfvec) owner to supabase_admin;

grant execute on function halfvec_add(halfvec, halfvec) to postgres;

grant execute on function halfvec_add(halfvec, halfvec) to anon;

grant execute on function halfvec_add(halfvec, halfvec) to authenticated;

grant execute on function halfvec_add(halfvec, halfvec) to service_role;

create function halfvec_sub(halfvec, halfvec) returns halfvec
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function halfvec_sub(halfvec, halfvec) owner to supabase_admin;

grant execute on function halfvec_sub(halfvec, halfvec) to postgres;

grant execute on function halfvec_sub(halfvec, halfvec) to anon;

grant execute on function halfvec_sub(halfvec, halfvec) to authenticated;

grant execute on function halfvec_sub(halfvec, halfvec) to service_role;

create function halfvec_mul(halfvec, halfvec) returns halfvec
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function halfvec_mul(halfvec, halfvec) owner to supabase_admin;

grant execute on function halfvec_mul(halfvec, halfvec) to postgres;

grant execute on function halfvec_mul(halfvec, halfvec) to anon;

grant execute on function halfvec_mul(halfvec, halfvec) to authenticated;

grant execute on function halfvec_mul(halfvec, halfvec) to service_role;

create function halfvec_concat(halfvec, halfvec) returns halfvec
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function halfvec_concat(halfvec, halfvec) owner to supabase_admin;

grant execute on function halfvec_concat(halfvec, halfvec) to postgres;

grant execute on function halfvec_concat(halfvec, halfvec) to anon;

grant execute on function halfvec_concat(halfvec, halfvec) to authenticated;

grant execute on function halfvec_concat(halfvec, halfvec) to service_role;

create function halfvec_lt(halfvec, halfvec) returns boolean
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function halfvec_lt(halfvec, halfvec) owner to supabase_admin;

grant execute on function halfvec_lt(halfvec, halfvec) to postgres;

grant execute on function halfvec_lt(halfvec, halfvec) to anon;

grant execute on function halfvec_lt(halfvec, halfvec) to authenticated;

grant execute on function halfvec_lt(halfvec, halfvec) to service_role;

create function halfvec_le(halfvec, halfvec) returns boolean
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function halfvec_le(halfvec, halfvec) owner to supabase_admin;

grant execute on function halfvec_le(halfvec, halfvec) to postgres;

grant execute on function halfvec_le(halfvec, halfvec) to anon;

grant execute on function halfvec_le(halfvec, halfvec) to authenticated;

grant execute on function halfvec_le(halfvec, halfvec) to service_role;

create function halfvec_eq(halfvec, halfvec) returns boolean
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function halfvec_eq(halfvec, halfvec) owner to supabase_admin;

grant execute on function halfvec_eq(halfvec, halfvec) to postgres;

grant execute on function halfvec_eq(halfvec, halfvec) to anon;

grant execute on function halfvec_eq(halfvec, halfvec) to authenticated;

grant execute on function halfvec_eq(halfvec, halfvec) to service_role;

create function halfvec_ne(halfvec, halfvec) returns boolean
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function halfvec_ne(halfvec, halfvec) owner to supabase_admin;

grant execute on function halfvec_ne(halfvec, halfvec) to postgres;

grant execute on function halfvec_ne(halfvec, halfvec) to anon;

grant execute on function halfvec_ne(halfvec, halfvec) to authenticated;

grant execute on function halfvec_ne(halfvec, halfvec) to service_role;

create function halfvec_ge(halfvec, halfvec) returns boolean
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function halfvec_ge(halfvec, halfvec) owner to supabase_admin;

grant execute on function halfvec_ge(halfvec, halfvec) to postgres;

grant execute on function halfvec_ge(halfvec, halfvec) to anon;

grant execute on function halfvec_ge(halfvec, halfvec) to authenticated;

grant execute on function halfvec_ge(halfvec, halfvec) to service_role;

create function halfvec_gt(halfvec, halfvec) returns boolean
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function halfvec_gt(halfvec, halfvec) owner to supabase_admin;

grant execute on function halfvec_gt(halfvec, halfvec) to postgres;

grant execute on function halfvec_gt(halfvec, halfvec) to anon;

grant execute on function halfvec_gt(halfvec, halfvec) to authenticated;

grant execute on function halfvec_gt(halfvec, halfvec) to service_role;

create function halfvec_cmp(halfvec, halfvec) returns integer
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function halfvec_cmp(halfvec, halfvec) owner to supabase_admin;

grant execute on function halfvec_cmp(halfvec, halfvec) to postgres;

grant execute on function halfvec_cmp(halfvec, halfvec) to anon;

grant execute on function halfvec_cmp(halfvec, halfvec) to authenticated;

grant execute on function halfvec_cmp(halfvec, halfvec) to service_role;

create function halfvec_l2_squared_distance(halfvec, halfvec) returns double precision
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function halfvec_l2_squared_distance(halfvec, halfvec) owner to supabase_admin;

grant execute on function halfvec_l2_squared_distance(halfvec, halfvec) to postgres;

grant execute on function halfvec_l2_squared_distance(halfvec, halfvec) to anon;

grant execute on function halfvec_l2_squared_distance(halfvec, halfvec) to authenticated;

grant execute on function halfvec_l2_squared_distance(halfvec, halfvec) to service_role;

create function halfvec_negative_inner_product(halfvec, halfvec) returns double precision
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function halfvec_negative_inner_product(halfvec, halfvec) owner to supabase_admin;

grant execute on function halfvec_negative_inner_product(halfvec, halfvec) to postgres;

grant execute on function halfvec_negative_inner_product(halfvec, halfvec) to anon;

grant execute on function halfvec_negative_inner_product(halfvec, halfvec) to authenticated;

grant execute on function halfvec_negative_inner_product(halfvec, halfvec) to service_role;

create function halfvec_spherical_distance(halfvec, halfvec) returns double precision
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function halfvec_spherical_distance(halfvec, halfvec) owner to supabase_admin;

grant execute on function halfvec_spherical_distance(halfvec, halfvec) to postgres;

grant execute on function halfvec_spherical_distance(halfvec, halfvec) to anon;

grant execute on function halfvec_spherical_distance(halfvec, halfvec) to authenticated;

grant execute on function halfvec_spherical_distance(halfvec, halfvec) to service_role;

create function halfvec_accum(double precision[], halfvec) returns double precision[]
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function halfvec_accum(double precision[], halfvec) owner to supabase_admin;

grant execute on function halfvec_accum(double precision[], halfvec) to postgres;

grant execute on function halfvec_accum(double precision[], halfvec) to anon;

grant execute on function halfvec_accum(double precision[], halfvec) to authenticated;

grant execute on function halfvec_accum(double precision[], halfvec) to service_role;

create function halfvec_avg(double precision[]) returns halfvec
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function halfvec_avg(double precision[]) owner to supabase_admin;

grant execute on function halfvec_avg(double precision[]) to postgres;

grant execute on function halfvec_avg(double precision[]) to anon;

grant execute on function halfvec_avg(double precision[]) to authenticated;

grant execute on function halfvec_avg(double precision[]) to service_role;

create function halfvec_combine(double precision[], double precision[]) returns double precision[]
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function halfvec_combine(double precision[], double precision[]) owner to supabase_admin;

grant execute on function halfvec_combine(double precision[], double precision[]) to postgres;

grant execute on function halfvec_combine(double precision[], double precision[]) to anon;

grant execute on function halfvec_combine(double precision[], double precision[]) to authenticated;

grant execute on function halfvec_combine(double precision[], double precision[]) to service_role;

create function halfvec(halfvec, integer, boolean) returns halfvec
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function halfvec(halfvec, integer, boolean) owner to supabase_admin;

grant execute on function halfvec(halfvec, integer, boolean) to postgres;

grant execute on function halfvec(halfvec, integer, boolean) to anon;

grant execute on function halfvec(halfvec, integer, boolean) to authenticated;

grant execute on function halfvec(halfvec, integer, boolean) to service_role;

create function halfvec_to_vector(halfvec, integer, boolean) returns vector
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function halfvec_to_vector(halfvec, integer, boolean) owner to supabase_admin;

grant execute on function halfvec_to_vector(halfvec, integer, boolean) to postgres;

grant execute on function halfvec_to_vector(halfvec, integer, boolean) to anon;

grant execute on function halfvec_to_vector(halfvec, integer, boolean) to authenticated;

grant execute on function halfvec_to_vector(halfvec, integer, boolean) to service_role;

create function vector_to_halfvec(vector, integer, boolean) returns halfvec
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function vector_to_halfvec(vector, integer, boolean) owner to supabase_admin;

grant execute on function vector_to_halfvec(vector, integer, boolean) to postgres;

grant execute on function vector_to_halfvec(vector, integer, boolean) to anon;

grant execute on function vector_to_halfvec(vector, integer, boolean) to authenticated;

grant execute on function vector_to_halfvec(vector, integer, boolean) to service_role;

create function array_to_halfvec(integer[], integer, boolean) returns halfvec
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function array_to_halfvec(integer[], integer, boolean) owner to supabase_admin;

grant execute on function array_to_halfvec(integer[], integer, boolean) to postgres;

grant execute on function array_to_halfvec(integer[], integer, boolean) to anon;

grant execute on function array_to_halfvec(integer[], integer, boolean) to authenticated;

grant execute on function array_to_halfvec(integer[], integer, boolean) to service_role;

create function array_to_halfvec(real[], integer, boolean) returns halfvec
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function array_to_halfvec(real[], integer, boolean) owner to supabase_admin;

grant execute on function array_to_halfvec(real[], integer, boolean) to postgres;

grant execute on function array_to_halfvec(real[], integer, boolean) to anon;

grant execute on function array_to_halfvec(real[], integer, boolean) to authenticated;

grant execute on function array_to_halfvec(real[], integer, boolean) to service_role;

create function array_to_halfvec(double precision[], integer, boolean) returns halfvec
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function array_to_halfvec(double precision[], integer, boolean) owner to supabase_admin;

grant execute on function array_to_halfvec(double precision[], integer, boolean) to postgres;

grant execute on function array_to_halfvec(double precision[], integer, boolean) to anon;

grant execute on function array_to_halfvec(double precision[], integer, boolean) to authenticated;

grant execute on function array_to_halfvec(double precision[], integer, boolean) to service_role;

create function array_to_halfvec(numeric[], integer, boolean) returns halfvec
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function array_to_halfvec(numeric[], integer, boolean) owner to supabase_admin;

grant execute on function array_to_halfvec(numeric[], integer, boolean) to postgres;

grant execute on function array_to_halfvec(numeric[], integer, boolean) to anon;

grant execute on function array_to_halfvec(numeric[], integer, boolean) to authenticated;

grant execute on function array_to_halfvec(numeric[], integer, boolean) to service_role;

create function halfvec_to_float4(halfvec, integer, boolean) returns real[]
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function halfvec_to_float4(halfvec, integer, boolean) owner to supabase_admin;

grant execute on function halfvec_to_float4(halfvec, integer, boolean) to postgres;

grant execute on function halfvec_to_float4(halfvec, integer, boolean) to anon;

grant execute on function halfvec_to_float4(halfvec, integer, boolean) to authenticated;

grant execute on function halfvec_to_float4(halfvec, integer, boolean) to service_role;

create function hamming_distance(bit, bit) returns double precision
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function hamming_distance(bit, bit) owner to supabase_admin;

grant execute on function hamming_distance(bit, bit) to postgres;

grant execute on function hamming_distance(bit, bit) to anon;

grant execute on function hamming_distance(bit, bit) to authenticated;

grant execute on function hamming_distance(bit, bit) to service_role;

create function jaccard_distance(bit, bit) returns double precision
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function jaccard_distance(bit, bit) owner to supabase_admin;

grant execute on function jaccard_distance(bit, bit) to postgres;

grant execute on function jaccard_distance(bit, bit) to anon;

grant execute on function jaccard_distance(bit, bit) to authenticated;

grant execute on function jaccard_distance(bit, bit) to service_role;

create function sparsevec_in(cstring, oid, integer) returns sparsevec
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function sparsevec_in(cstring, oid, integer) owner to supabase_admin;

grant execute on function sparsevec_in(cstring, oid, integer) to postgres;

grant execute on function sparsevec_in(cstring, oid, integer) to anon;

grant execute on function sparsevec_in(cstring, oid, integer) to authenticated;

grant execute on function sparsevec_in(cstring, oid, integer) to service_role;

create function sparsevec_out(sparsevec) returns cstring
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function sparsevec_out(sparsevec) owner to supabase_admin;

grant execute on function sparsevec_out(sparsevec) to postgres;

grant execute on function sparsevec_out(sparsevec) to anon;

grant execute on function sparsevec_out(sparsevec) to authenticated;

grant execute on function sparsevec_out(sparsevec) to service_role;

create function sparsevec_typmod_in(cstring[]) returns integer
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function sparsevec_typmod_in(cstring[]) owner to supabase_admin;

grant execute on function sparsevec_typmod_in(cstring[]) to postgres;

grant execute on function sparsevec_typmod_in(cstring[]) to anon;

grant execute on function sparsevec_typmod_in(cstring[]) to authenticated;

grant execute on function sparsevec_typmod_in(cstring[]) to service_role;

create function sparsevec_recv(internal, oid, integer) returns sparsevec
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function sparsevec_recv(internal, oid, integer) owner to supabase_admin;

grant execute on function sparsevec_recv(internal, oid, integer) to postgres;

grant execute on function sparsevec_recv(internal, oid, integer) to anon;

grant execute on function sparsevec_recv(internal, oid, integer) to authenticated;

grant execute on function sparsevec_recv(internal, oid, integer) to service_role;

create function sparsevec_send(sparsevec) returns bytea
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function sparsevec_send(sparsevec) owner to supabase_admin;

grant execute on function sparsevec_send(sparsevec) to postgres;

grant execute on function sparsevec_send(sparsevec) to anon;

grant execute on function sparsevec_send(sparsevec) to authenticated;

grant execute on function sparsevec_send(sparsevec) to service_role;

create function l2_distance(sparsevec, sparsevec) returns double precision
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function l2_distance(sparsevec, sparsevec) owner to supabase_admin;

grant execute on function l2_distance(sparsevec, sparsevec) to postgres;

grant execute on function l2_distance(sparsevec, sparsevec) to anon;

grant execute on function l2_distance(sparsevec, sparsevec) to authenticated;

grant execute on function l2_distance(sparsevec, sparsevec) to service_role;

create function inner_product(sparsevec, sparsevec) returns double precision
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function inner_product(sparsevec, sparsevec) owner to supabase_admin;

grant execute on function inner_product(sparsevec, sparsevec) to postgres;

grant execute on function inner_product(sparsevec, sparsevec) to anon;

grant execute on function inner_product(sparsevec, sparsevec) to authenticated;

grant execute on function inner_product(sparsevec, sparsevec) to service_role;

create function cosine_distance(sparsevec, sparsevec) returns double precision
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function cosine_distance(sparsevec, sparsevec) owner to supabase_admin;

grant execute on function cosine_distance(sparsevec, sparsevec) to postgres;

grant execute on function cosine_distance(sparsevec, sparsevec) to anon;

grant execute on function cosine_distance(sparsevec, sparsevec) to authenticated;

grant execute on function cosine_distance(sparsevec, sparsevec) to service_role;

create function l1_distance(sparsevec, sparsevec) returns double precision
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function l1_distance(sparsevec, sparsevec) owner to supabase_admin;

grant execute on function l1_distance(sparsevec, sparsevec) to postgres;

grant execute on function l1_distance(sparsevec, sparsevec) to anon;

grant execute on function l1_distance(sparsevec, sparsevec) to authenticated;

grant execute on function l1_distance(sparsevec, sparsevec) to service_role;

create function l2_norm(sparsevec) returns double precision
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function l2_norm(sparsevec) owner to supabase_admin;

grant execute on function l2_norm(sparsevec) to postgres;

grant execute on function l2_norm(sparsevec) to anon;

grant execute on function l2_norm(sparsevec) to authenticated;

grant execute on function l2_norm(sparsevec) to service_role;

create function l2_normalize(sparsevec) returns sparsevec
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function l2_normalize(sparsevec) owner to supabase_admin;

grant execute on function l2_normalize(sparsevec) to postgres;

grant execute on function l2_normalize(sparsevec) to anon;

grant execute on function l2_normalize(sparsevec) to authenticated;

grant execute on function l2_normalize(sparsevec) to service_role;

create function sparsevec_lt(sparsevec, sparsevec) returns boolean
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function sparsevec_lt(sparsevec, sparsevec) owner to supabase_admin;

grant execute on function sparsevec_lt(sparsevec, sparsevec) to postgres;

grant execute on function sparsevec_lt(sparsevec, sparsevec) to anon;

grant execute on function sparsevec_lt(sparsevec, sparsevec) to authenticated;

grant execute on function sparsevec_lt(sparsevec, sparsevec) to service_role;

create function sparsevec_le(sparsevec, sparsevec) returns boolean
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function sparsevec_le(sparsevec, sparsevec) owner to supabase_admin;

grant execute on function sparsevec_le(sparsevec, sparsevec) to postgres;

grant execute on function sparsevec_le(sparsevec, sparsevec) to anon;

grant execute on function sparsevec_le(sparsevec, sparsevec) to authenticated;

grant execute on function sparsevec_le(sparsevec, sparsevec) to service_role;

create function sparsevec_eq(sparsevec, sparsevec) returns boolean
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function sparsevec_eq(sparsevec, sparsevec) owner to supabase_admin;

grant execute on function sparsevec_eq(sparsevec, sparsevec) to postgres;

grant execute on function sparsevec_eq(sparsevec, sparsevec) to anon;

grant execute on function sparsevec_eq(sparsevec, sparsevec) to authenticated;

grant execute on function sparsevec_eq(sparsevec, sparsevec) to service_role;

create function sparsevec_ne(sparsevec, sparsevec) returns boolean
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function sparsevec_ne(sparsevec, sparsevec) owner to supabase_admin;

grant execute on function sparsevec_ne(sparsevec, sparsevec) to postgres;

grant execute on function sparsevec_ne(sparsevec, sparsevec) to anon;

grant execute on function sparsevec_ne(sparsevec, sparsevec) to authenticated;

grant execute on function sparsevec_ne(sparsevec, sparsevec) to service_role;

create function sparsevec_ge(sparsevec, sparsevec) returns boolean
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function sparsevec_ge(sparsevec, sparsevec) owner to supabase_admin;

grant execute on function sparsevec_ge(sparsevec, sparsevec) to postgres;

grant execute on function sparsevec_ge(sparsevec, sparsevec) to anon;

grant execute on function sparsevec_ge(sparsevec, sparsevec) to authenticated;

grant execute on function sparsevec_ge(sparsevec, sparsevec) to service_role;

create function sparsevec_gt(sparsevec, sparsevec) returns boolean
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function sparsevec_gt(sparsevec, sparsevec) owner to supabase_admin;

grant execute on function sparsevec_gt(sparsevec, sparsevec) to postgres;

grant execute on function sparsevec_gt(sparsevec, sparsevec) to anon;

grant execute on function sparsevec_gt(sparsevec, sparsevec) to authenticated;

grant execute on function sparsevec_gt(sparsevec, sparsevec) to service_role;

create function sparsevec_cmp(sparsevec, sparsevec) returns integer
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function sparsevec_cmp(sparsevec, sparsevec) owner to supabase_admin;

grant execute on function sparsevec_cmp(sparsevec, sparsevec) to postgres;

grant execute on function sparsevec_cmp(sparsevec, sparsevec) to anon;

grant execute on function sparsevec_cmp(sparsevec, sparsevec) to authenticated;

grant execute on function sparsevec_cmp(sparsevec, sparsevec) to service_role;

create function sparsevec_l2_squared_distance(sparsevec, sparsevec) returns double precision
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function sparsevec_l2_squared_distance(sparsevec, sparsevec) owner to supabase_admin;

grant execute on function sparsevec_l2_squared_distance(sparsevec, sparsevec) to postgres;

grant execute on function sparsevec_l2_squared_distance(sparsevec, sparsevec) to anon;

grant execute on function sparsevec_l2_squared_distance(sparsevec, sparsevec) to authenticated;

grant execute on function sparsevec_l2_squared_distance(sparsevec, sparsevec) to service_role;

create function sparsevec_negative_inner_product(sparsevec, sparsevec) returns double precision
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function sparsevec_negative_inner_product(sparsevec, sparsevec) owner to supabase_admin;

grant execute on function sparsevec_negative_inner_product(sparsevec, sparsevec) to postgres;

grant execute on function sparsevec_negative_inner_product(sparsevec, sparsevec) to anon;

grant execute on function sparsevec_negative_inner_product(sparsevec, sparsevec) to authenticated;

grant execute on function sparsevec_negative_inner_product(sparsevec, sparsevec) to service_role;

create function sparsevec(sparsevec, integer, boolean) returns sparsevec
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function sparsevec(sparsevec, integer, boolean) owner to supabase_admin;

grant execute on function sparsevec(sparsevec, integer, boolean) to postgres;

grant execute on function sparsevec(sparsevec, integer, boolean) to anon;

grant execute on function sparsevec(sparsevec, integer, boolean) to authenticated;

grant execute on function sparsevec(sparsevec, integer, boolean) to service_role;

create function vector_to_sparsevec(vector, integer, boolean) returns sparsevec
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function vector_to_sparsevec(vector, integer, boolean) owner to supabase_admin;

grant execute on function vector_to_sparsevec(vector, integer, boolean) to postgres;

grant execute on function vector_to_sparsevec(vector, integer, boolean) to anon;

grant execute on function vector_to_sparsevec(vector, integer, boolean) to authenticated;

grant execute on function vector_to_sparsevec(vector, integer, boolean) to service_role;

create function sparsevec_to_vector(sparsevec, integer, boolean) returns vector
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function sparsevec_to_vector(sparsevec, integer, boolean) owner to supabase_admin;

grant execute on function sparsevec_to_vector(sparsevec, integer, boolean) to postgres;

grant execute on function sparsevec_to_vector(sparsevec, integer, boolean) to anon;

grant execute on function sparsevec_to_vector(sparsevec, integer, boolean) to authenticated;

grant execute on function sparsevec_to_vector(sparsevec, integer, boolean) to service_role;

create function halfvec_to_sparsevec(halfvec, integer, boolean) returns sparsevec
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function halfvec_to_sparsevec(halfvec, integer, boolean) owner to supabase_admin;

grant execute on function halfvec_to_sparsevec(halfvec, integer, boolean) to postgres;

grant execute on function halfvec_to_sparsevec(halfvec, integer, boolean) to anon;

grant execute on function halfvec_to_sparsevec(halfvec, integer, boolean) to authenticated;

grant execute on function halfvec_to_sparsevec(halfvec, integer, boolean) to service_role;

create function sparsevec_to_halfvec(sparsevec, integer, boolean) returns halfvec
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function sparsevec_to_halfvec(sparsevec, integer, boolean) owner to supabase_admin;

grant execute on function sparsevec_to_halfvec(sparsevec, integer, boolean) to postgres;

grant execute on function sparsevec_to_halfvec(sparsevec, integer, boolean) to anon;

grant execute on function sparsevec_to_halfvec(sparsevec, integer, boolean) to authenticated;

grant execute on function sparsevec_to_halfvec(sparsevec, integer, boolean) to service_role;

create function array_to_sparsevec(integer[], integer, boolean) returns sparsevec
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function array_to_sparsevec(integer[], integer, boolean) owner to supabase_admin;

grant execute on function array_to_sparsevec(integer[], integer, boolean) to postgres;

grant execute on function array_to_sparsevec(integer[], integer, boolean) to anon;

grant execute on function array_to_sparsevec(integer[], integer, boolean) to authenticated;

grant execute on function array_to_sparsevec(integer[], integer, boolean) to service_role;

create function array_to_sparsevec(real[], integer, boolean) returns sparsevec
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function array_to_sparsevec(real[], integer, boolean) owner to supabase_admin;

grant execute on function array_to_sparsevec(real[], integer, boolean) to postgres;

grant execute on function array_to_sparsevec(real[], integer, boolean) to anon;

grant execute on function array_to_sparsevec(real[], integer, boolean) to authenticated;

grant execute on function array_to_sparsevec(real[], integer, boolean) to service_role;

create function array_to_sparsevec(double precision[], integer, boolean) returns sparsevec
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function array_to_sparsevec(double precision[], integer, boolean) owner to supabase_admin;

grant execute on function array_to_sparsevec(double precision[], integer, boolean) to postgres;

grant execute on function array_to_sparsevec(double precision[], integer, boolean) to anon;

grant execute on function array_to_sparsevec(double precision[], integer, boolean) to authenticated;

grant execute on function array_to_sparsevec(double precision[], integer, boolean) to service_role;

create function array_to_sparsevec(numeric[], integer, boolean) returns sparsevec
    immutable
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function array_to_sparsevec(numeric[], integer, boolean) owner to supabase_admin;

grant execute on function array_to_sparsevec(numeric[], integer, boolean) to postgres;

grant execute on function array_to_sparsevec(numeric[], integer, boolean) to anon;

grant execute on function array_to_sparsevec(numeric[], integer, boolean) to authenticated;

grant execute on function array_to_sparsevec(numeric[], integer, boolean) to service_role;

create function match_transactions(query_embedding vector, match_threshold double precision DEFAULT 0.8, match_count integer DEFAULT 5)
    returns TABLE(id uuid, name text, merchant_name text, category_id uuid, similarity double precision)
    language plpgsql
as
$$
BEGIN
    RETURN QUERY
        SELECT
            t.id,
            t.name,
            t.merchant_name,
            t.category_id,
            1 - (t.embedding <=> query_embedding) as similarity
        FROM hb_transactions t
        WHERE t.embedding IS NOT NULL
          AND t.category_id IS NOT NULL
          AND 1 - (t.embedding <=> query_embedding) > match_threshold
        ORDER BY t.embedding <=> query_embedding
        LIMIT match_count;
END;
$$;

alter function match_transactions(vector, double precision, integer) owner to postgres;

grant execute on function match_transactions(vector, double precision, integer) to anon;

grant execute on function match_transactions(vector, double precision, integer) to authenticated;

grant execute on function match_transactions(vector, double precision, integer) to service_role;

create function get_user_transactions(p_user_id uuid, p_start_date date DEFAULT NULL::date, p_end_date date DEFAULT NULL::date, p_import_method text DEFAULT NULL::text)
    returns TABLE(id uuid, user_id uuid, account_id text, transaction_id text, amount numeric, date date, name text, merchant_name text, description text, category_id uuid, category_confidence numeric, bank_source character varying, import_method character varying, pending boolean, is_reconciled boolean, created_at timestamp with time zone)
    security definer
    language plpgsql
as
$$
BEGIN
    RETURN QUERY
        SELECT
            t.id,
            t.user_id,
            t.account_id,
            t.transaction_id,
            t.amount,
            t.date,
            t.name,
            t.merchant_name,
            t.description,
            t.category_id,
            t.category_confidence,
            t.bank_source,
            t.import_method,
            t.pending,
            t.is_reconciled,
            t.created_at
        FROM hb_transactions t
        WHERE t.user_id = p_user_id
          AND (p_start_date IS NULL OR t.date >= p_start_date)
          AND (p_end_date IS NULL OR t.date <= p_end_date)
          AND (p_import_method IS NULL OR t.import_method = p_import_method)
        ORDER BY t.date DESC, t.created_at DESC;
END;
$$;

alter function get_user_transactions(uuid, date, date, text) owner to postgres;

grant execute on function get_user_transactions(uuid, date, date, text) to anon;

grant execute on function get_user_transactions(uuid, date, date, text) to authenticated;

grant execute on function get_user_transactions(uuid, date, date, text) to service_role;

create function update_resume_tags_updated_at() returns trigger
    language plpgsql
as
$$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;

alter function update_resume_tags_updated_at() owner to postgres;

create trigger trigger_update_resume_tags_updated_at
    before update
    on resume_tags
    for each row
execute procedure update_resume_tags_updated_at();

grant execute on function update_resume_tags_updated_at() to anon;

grant execute on function update_resume_tags_updated_at() to authenticated;

grant execute on function update_resume_tags_updated_at() to service_role;

create function check_duplicate_transaction(p_user_id uuid, p_account_id text, p_date date, p_amount numeric, p_name text, p_import_method text, p_csv_filename text DEFAULT NULL::text) returns boolean
    language plpgsql
as
$$
BEGIN
    -- Check for exact duplicates based on import method
    IF p_import_method = 'csv' THEN
        RETURN EXISTS (
            SELECT 1 FROM hb_transactions
            WHERE user_id = p_user_id
              AND account_id = p_account_id
              AND date = p_date
              AND amount = p_amount
              AND name = p_name
              AND import_method = 'csv'
              AND (csv_filename = p_csv_filename OR (csv_filename IS NULL AND p_csv_filename IS NULL))
        );
    ELSIF p_import_method = 'manual' THEN
        RETURN EXISTS (
            SELECT 1 FROM hb_transactions
            WHERE user_id = p_user_id
              AND account_id = p_account_id
              AND date = p_date
              AND amount = p_amount
              AND name = p_name
              AND import_method = 'manual'
        );
    ELSE
        -- For plaid transactions, check using transaction_id (existing logic)
        RETURN FALSE; -- Plaid duplicates are handled by the existing unique constraint
    END IF;
END;
$$;

comment on function check_duplicate_transaction(uuid, text, date, numeric, text, text, text) is 'Checks if a transaction would be a duplicate based on import method and key fields';

alter function check_duplicate_transaction(uuid, text, date, numeric, text, text, text) owner to postgres;

grant execute on function check_duplicate_transaction(uuid, text, date, numeric, text, text, text) to anon;

grant execute on function check_duplicate_transaction(uuid, text, date, numeric, text, text, text) to authenticated;

grant execute on function check_duplicate_transaction(uuid, text, date, numeric, text, text, text) to service_role;

create function safe_insert_transaction(p_user_id uuid, p_account_id text, p_amount numeric, p_date date, p_name text, p_transaction_id text DEFAULT NULL::text, p_merchant_name text DEFAULT NULL::text, p_description text DEFAULT NULL::text, p_category_id uuid DEFAULT NULL::uuid, p_bank_source text DEFAULT NULL::text, p_import_method text DEFAULT 'manual'::text, p_csv_filename text DEFAULT NULL::text, p_pending boolean DEFAULT false, p_iso_currency_code text DEFAULT 'USD'::text)
    returns TABLE(inserted boolean, transaction_id uuid, error_message text)
    language plpgsql
as
$$
DECLARE
    v_transaction_id UUID;
    v_is_duplicate BOOLEAN;
BEGIN
    -- Check for duplicates
    v_is_duplicate := check_duplicate_transaction(
            p_user_id,
            p_account_id,
            p_date,
            p_amount,
            p_name,
            p_import_method,
            p_csv_filename
                      );

    IF v_is_duplicate THEN
        RETURN QUERY SELECT FALSE, NULL::UUID, 'Duplicate transaction detected'::TEXT;
        RETURN;
    END IF;

    -- Insert the transaction
    INSERT INTO hb_transactions (
        user_id, account_id, transaction_id, amount, date, name,
        merchant_name, description, category_id, bank_source, import_method,
        csv_filename, pending, iso_currency_code
    ) VALUES (
                 p_user_id, p_account_id, p_transaction_id, p_amount, p_date, p_name,
                 p_merchant_name, p_description, p_category_id, p_bank_source, p_import_method,
                 p_csv_filename, p_pending, p_iso_currency_code
             ) RETURNING id INTO v_transaction_id;

    RETURN QUERY SELECT TRUE, v_transaction_id, NULL::TEXT;
END;
$$;

comment on function safe_insert_transaction(uuid, text, numeric, date, text, text, text, text, uuid, text, text, text, boolean, text) is 'Safely inserts a transaction with automatic duplicate checking and returns success status';

alter function safe_insert_transaction(uuid, text, numeric, date, text, text, text, text, uuid, text, text, text, boolean, text) owner to postgres;

grant execute on function safe_insert_transaction(uuid, text, numeric, date, text, text, text, text, uuid, text, text, text, boolean, text) to anon;

grant execute on function safe_insert_transaction(uuid, text, numeric, date, text, text, text, text, uuid, text, text, text, boolean, text) to authenticated;

grant execute on function safe_insert_transaction(uuid, text, numeric, date, text, text, text, text, uuid, text, text, text, boolean, text) to service_role;

create function get_items_expiring_soon(days_ahead integer DEFAULT 3)
    returns TABLE(receipt_item_id uuid, item_name character varying, expiration_date date, receipt_date date, store_name character varying, quantity numeric)
    security definer
    language plpgsql
as
$$
BEGIN
    RETURN QUERY
        SELECT
            ri.id as receipt_item_id,
            i.name as item_name,
            ri.expiration_date,
            r.receipt_date,
            s.name as store_name,
            ri.quantity
        FROM shop_receipt_items ri
                 JOIN shop_items i ON ri.item_id = i.id
                 JOIN shop_receipts r ON ri.receipt_id = r.id
                 JOIN shop_stores s ON r.store_id = s.id
        WHERE ri.is_finished = false
          AND ri.expiration_date IS NOT NULL
          AND ri.expiration_date BETWEEN CURRENT_DATE AND CURRENT_DATE + (days_ahead || ' days')::INTERVAL
        ORDER BY ri.expiration_date ASC;
END;
$$;

alter function get_items_expiring_soon(integer) owner to postgres;

grant execute on function get_items_expiring_soon(integer) to anon;

grant execute on function get_items_expiring_soon(integer) to authenticated;

grant execute on function get_items_expiring_soon(integer) to service_role;

create function set_updated_at() returns trigger
    language plpgsql
as
$$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;

alter function set_updated_at() owner to postgres;

grant execute on function set_updated_at() to anon;

grant execute on function set_updated_at() to authenticated;

grant execute on function set_updated_at() to service_role;

create function cb_set_updated_at() returns trigger
    language plpgsql
as
$$
begin
    new.updated_at = now();
    return new;
end;
$$;

alter function cb_set_updated_at() owner to postgres;

create trigger trg_cb_events_updated_at
    before update
    on cb_events
    for each row
execute procedure cb_set_updated_at();

create trigger trg_cb_event_guests_updated_at
    before update
    on cb_event_guests
    for each row
execute procedure cb_set_updated_at();

grant execute on function cb_set_updated_at() to anon;

grant execute on function cb_set_updated_at() to authenticated;

grant execute on function cb_set_updated_at() to service_role;

create operator % (procedure = similarity_op, leftarg = text, rightarg = text, commutator = %, join = matchingjoinsel, restrict = matchingsel);

alter operator %(text, text) owner to supabase_admin;

create operator <-> (procedure = similarity_dist, leftarg = text, rightarg = text, commutator = <->);

alter operator <->(text, text) owner to supabase_admin;

create operator <-> (procedure = l2_distance, leftarg = vector, rightarg = vector, commutator = <->);

alter operator <->(vector, vector) owner to supabase_admin;

create operator <#> (procedure = vector_negative_inner_product, leftarg = vector, rightarg = vector, commutator = <#>);

alter operator <#>(vector, vector) owner to supabase_admin;

create operator <=> (procedure = cosine_distance, leftarg = vector, rightarg = vector, commutator = <=>);

alter operator <=>(vector, vector) owner to supabase_admin;

create operator <+> (procedure = l1_distance, leftarg = vector, rightarg = vector, commutator = <+>);

alter operator <+>(vector, vector) owner to supabase_admin;

create operator + (procedure = vector_add, leftarg = vector, rightarg = vector, commutator = +);

alter operator +(vector, vector) owner to supabase_admin;

create operator - (procedure = vector_sub, leftarg = vector, rightarg = vector);

alter operator -(vector, vector) owner to supabase_admin;

create operator * (procedure = vector_mul, leftarg = vector, rightarg = vector, commutator = *);

alter operator *(vector, vector) owner to supabase_admin;

create operator || (procedure = vector_concat, leftarg = vector, rightarg = vector);

alter operator ||(vector, vector) owner to supabase_admin;

create operator <-> (procedure = l2_distance, leftarg = halfvec, rightarg = halfvec, commutator = <->);

alter operator <->(halfvec, halfvec) owner to supabase_admin;

create operator <#> (procedure = halfvec_negative_inner_product, leftarg = halfvec, rightarg = halfvec, commutator = <#>);

alter operator <#>(halfvec, halfvec) owner to supabase_admin;

create operator <=> (procedure = cosine_distance, leftarg = halfvec, rightarg = halfvec, commutator = <=>);

alter operator <=>(halfvec, halfvec) owner to supabase_admin;

create operator <+> (procedure = l1_distance, leftarg = halfvec, rightarg = halfvec, commutator = <+>);

alter operator <+>(halfvec, halfvec) owner to supabase_admin;

create operator + (procedure = halfvec_add, leftarg = halfvec, rightarg = halfvec, commutator = +);

alter operator +(halfvec, halfvec) owner to supabase_admin;

create operator - (procedure = halfvec_sub, leftarg = halfvec, rightarg = halfvec);

alter operator -(halfvec, halfvec) owner to supabase_admin;

create operator * (procedure = halfvec_mul, leftarg = halfvec, rightarg = halfvec, commutator = *);

alter operator *(halfvec, halfvec) owner to supabase_admin;

create operator || (procedure = halfvec_concat, leftarg = halfvec, rightarg = halfvec);

alter operator ||(halfvec, halfvec) owner to supabase_admin;

create operator <~> (procedure = hamming_distance, leftarg = bit, rightarg = bit, commutator = <~>);

alter operator <~>(bit, bit) owner to supabase_admin;

create operator <%> (procedure = jaccard_distance, leftarg = bit, rightarg = bit, commutator = <%>);

alter operator <%>(bit, bit) owner to supabase_admin;

create operator <-> (procedure = l2_distance, leftarg = sparsevec, rightarg = sparsevec, commutator = <->);

alter operator <->(sparsevec, sparsevec) owner to supabase_admin;

create operator <#> (procedure = sparsevec_negative_inner_product, leftarg = sparsevec, rightarg = sparsevec, commutator = <#>);

alter operator <#>(sparsevec, sparsevec) owner to supabase_admin;

create operator <=> (procedure = cosine_distance, leftarg = sparsevec, rightarg = sparsevec, commutator = <=>);

alter operator <=>(sparsevec, sparsevec) owner to supabase_admin;

create operator <+> (procedure = l1_distance, leftarg = sparsevec, rightarg = sparsevec, commutator = <+>);

alter operator <+>(sparsevec, sparsevec) owner to supabase_admin;

create aggregate avg(vector) (
    sfunc = vector_accum,
    stype = double precision[],
    finalfunc = vector_avg,
    combinefunc = vector_combine,
    initcond = '{0}',
    parallel = safe
    );

alter aggregate avg(vector) owner to supabase_admin;

grant execute on function avg(vector) to postgres;

grant execute on function avg(vector) to anon;

grant execute on function avg(vector) to authenticated;

grant execute on function avg(vector) to service_role;

create aggregate sum(vector) (
    sfunc = vector_add,
    stype = vector,
    combinefunc = vector_add,
    parallel = safe
    );

alter aggregate sum(vector) owner to supabase_admin;

grant execute on function sum(vector) to postgres;

grant execute on function sum(vector) to anon;

grant execute on function sum(vector) to authenticated;

grant execute on function sum(vector) to service_role;

create aggregate avg(halfvec) (
    sfunc = halfvec_accum,
    stype = double precision[],
    finalfunc = halfvec_avg,
    combinefunc = halfvec_combine,
    initcond = '{0}',
    parallel = safe
    );

alter aggregate avg(halfvec) owner to supabase_admin;

grant execute on function avg(halfvec) to postgres;

grant execute on function avg(halfvec) to anon;

grant execute on function avg(halfvec) to authenticated;

grant execute on function avg(halfvec) to service_role;

create aggregate sum(halfvec) (
    sfunc = halfvec_add,
    stype = halfvec,
    combinefunc = halfvec_add,
    parallel = safe
    );

alter aggregate sum(halfvec) owner to supabase_admin;

grant execute on function sum(halfvec) to postgres;

grant execute on function sum(halfvec) to anon;

grant execute on function sum(halfvec) to authenticated;

grant execute on function sum(halfvec) to service_role;

create operator family gist_trgm_ops using gist;

alter operator family gist_trgm_ops using gist add
    operator 6 ~*(text,text),
    operator 5 ~(text,text),
    operator 4 ~~*(text,text),
    operator 3 ~~(text,text),
    operator 2 <->(text, text) for order by float_ops,
    operator 1 %(text, text),
    operator 11 =(text,text),
    operator 8 <->>(text, text) for order by float_ops,
    operator 7 %>(text, text),
    operator 10 <->>>(text, text) for order by float_ops,
    operator 9 %>>(text, text),
    function 1(text, text) gtrgm_consistent(internal, text, smallint, oid, internal),
    function 2(text, text) gtrgm_union(internal, internal),
    function 3(text, text) gtrgm_compress(internal),
    function 4(text, text) gtrgm_decompress(internal),
    function 5(text, text) gtrgm_penalty(internal, internal, internal),
    function 6(text, text) gtrgm_picksplit(internal, internal),
    function 7(text, text) gtrgm_same(gtrgm, gtrgm, internal),
    function 8(text, text) gtrgm_distance(internal, text, smallint, oid, internal),
    function 10(text, text) gtrgm_options(internal);

alter operator family gist_trgm_ops using gist owner to supabase_admin;

create operator class gist_trgm_ops for type text using gist as storage gtrgm function 6(text, text) gtrgm_picksplit(internal, internal),
	function 7(text, text) gtrgm_same(gtrgm, gtrgm, internal),
	function 5(text, text) gtrgm_penalty(internal, internal, internal),
	function 2(text, text) gtrgm_union(internal, internal),
	function 1(text, text) gtrgm_consistent(internal, text, smallint, oid, internal);

alter operator class gist_trgm_ops using gist owner to supabase_admin;

create operator family gin_trgm_ops using gin;

alter operator family gin_trgm_ops using gin add
    operator 9 %>>(text, text),
    operator 1 %(text, text),
    operator 3 ~~(text,text),
    operator 4 ~~*(text,text),
    operator 5 ~(text,text),
    operator 6 ~*(text,text),
    operator 7 %>(text, text),
    operator 11 =(text,text),
    function 4(text, text) gin_trgm_consistent(internal, smallint, text, integer, internal, internal, internal, internal),
    function 2(text, text) gin_extract_value_trgm(text, internal),
    function 3(text, text) gin_extract_query_trgm(text, internal, smallint, internal, internal, internal, internal),
    function 6(text, text) gin_trgm_triconsistent(internal, smallint, text, integer, internal, internal, internal),
    function 1(text, text) btint4cmp(integer,integer);

alter operator family gin_trgm_ops using gin owner to supabase_admin;

create operator class gin_trgm_ops for type text using gin as storage integer function 3(text, text) gin_extract_query_trgm(text, internal, smallint, internal, internal, internal, internal),
	function 2(text, text) gin_extract_value_trgm(text, internal);

alter operator class gin_trgm_ops using gin owner to supabase_admin;

create operator family vector_ops using btree;

alter operator family vector_ops using btree add
    operator 4 >=(vector, vector),
    operator 1 <(vector, vector),
    operator 2 <=(vector, vector),
    operator 3 =(vector, vector),
    operator 5 >(vector, vector),
    function 1(vector, vector) vector_cmp(vector, vector);

alter operator family vector_ops using btree owner to supabase_admin;

create operator class vector_ops default for type vector using btree as
    operator 1 <(vector, vector),
    operator 5 >(vector, vector),
    operator 4 >=(vector, vector),
    operator 3 =(vector, vector),
    operator 2 <=(vector, vector),
    function 1(vector, vector) vector_cmp(vector, vector);

alter operator class vector_ops using btree owner to supabase_admin;

create operator family vector_l2_ops using ivfflat;

alter operator family vector_l2_ops using ivfflat add
    operator 1 <->(vector, vector) for order by float_ops,
    function 3(vector, vector) l2_distance(vector, vector),
    function 1(vector, vector) vector_l2_squared_distance(vector, vector);

alter operator family vector_l2_ops using ivfflat owner to supabase_admin;

create operator class vector_l2_ops default for type vector using ivfflat as
    operator 1 <->(vector, vector) for order by float_ops,
    function 3(vector, vector) l2_distance(vector, vector),
    function 1(vector, vector) vector_l2_squared_distance(vector, vector);

alter operator class vector_l2_ops using ivfflat owner to supabase_admin;

create operator family vector_ip_ops using ivfflat;

alter operator family vector_ip_ops using ivfflat add
    operator 1 <#>(vector, vector) for order by float_ops,
    function 1(vector, vector) vector_negative_inner_product(vector, vector),
    function 3(vector, vector) vector_spherical_distance(vector, vector),
    function 4(vector, vector) vector_norm(vector);

alter operator family vector_ip_ops using ivfflat owner to supabase_admin;

create operator class vector_ip_ops for type vector using ivfflat as
    operator 1 <#>(vector, vector) for order by float_ops,
    function 4(vector, vector) vector_norm(vector),
    function 3(vector, vector) vector_spherical_distance(vector, vector),
    function 1(vector, vector) vector_negative_inner_product(vector, vector);

alter operator class vector_ip_ops using ivfflat owner to supabase_admin;

create operator family vector_cosine_ops using ivfflat;

alter operator family vector_cosine_ops using ivfflat add
    operator 1 <=>(vector, vector) for order by float_ops,
    function 4(vector, vector) vector_norm(vector),
    function 1(vector, vector) vector_negative_inner_product(vector, vector),
    function 3(vector, vector) vector_spherical_distance(vector, vector),
    function 2(vector, vector) vector_norm(vector);

alter operator family vector_cosine_ops using ivfflat owner to supabase_admin;

create operator class vector_cosine_ops for type vector using ivfflat as
    operator 1 <=>(vector, vector) for order by float_ops,
    function 3(vector, vector) vector_spherical_distance(vector, vector),
    function 2(vector, vector) vector_norm(vector),
    function 1(vector, vector) vector_negative_inner_product(vector, vector),
    function 4(vector, vector) vector_norm(vector);

alter operator class vector_cosine_ops using ivfflat owner to supabase_admin;

create operator family vector_l2_ops using hnsw;

alter operator family vector_l2_ops using hnsw add
    operator 1 <->(vector, vector) for order by float_ops,
    function 1(vector, vector) vector_l2_squared_distance(vector, vector);

alter operator family vector_l2_ops using hnsw owner to supabase_admin;

create operator class vector_l2_ops for type vector using hnsw as
    operator 1 <->(vector, vector) for order by float_ops,
    function 1(vector, vector) vector_l2_squared_distance(vector, vector);

alter operator class vector_l2_ops using hnsw owner to supabase_admin;

create operator family vector_ip_ops using hnsw;

alter operator family vector_ip_ops using hnsw add
    operator 1 <#>(vector, vector) for order by float_ops,
    function 1(vector, vector) vector_negative_inner_product(vector, vector);

alter operator family vector_ip_ops using hnsw owner to supabase_admin;

create operator class vector_ip_ops for type vector using hnsw as
    operator 1 <#>(vector, vector) for order by float_ops,
    function 1(vector, vector) vector_negative_inner_product(vector, vector);

alter operator class vector_ip_ops using hnsw owner to supabase_admin;

create operator family vector_cosine_ops using hnsw;

alter operator family vector_cosine_ops using hnsw add
    operator 1 <=>(vector, vector) for order by float_ops,
    function 1(vector, vector) vector_negative_inner_product(vector, vector),
    function 2(vector, vector) vector_norm(vector);

alter operator family vector_cosine_ops using hnsw owner to supabase_admin;

create operator class vector_cosine_ops for type vector using hnsw as
    operator 1 <=>(vector, vector) for order by float_ops,
    function 2(vector, vector) vector_norm(vector),
    function 1(vector, vector) vector_negative_inner_product(vector, vector);

alter operator class vector_cosine_ops using hnsw owner to supabase_admin;

create operator family vector_l1_ops using hnsw;

alter operator family vector_l1_ops using hnsw add
    operator 1 <+>(vector, vector) for order by float_ops,
    function 1(vector, vector) l1_distance(vector, vector);

alter operator family vector_l1_ops using hnsw owner to supabase_admin;

create operator class vector_l1_ops for type vector using hnsw as
    operator 1 <+>(vector, vector) for order by float_ops,
    function 1(vector, vector) l1_distance(vector, vector);

alter operator class vector_l1_ops using hnsw owner to supabase_admin;

create operator family halfvec_ops using btree;

alter operator family halfvec_ops using btree add
    operator 3 =(halfvec, halfvec),
    operator 4 >=(halfvec, halfvec),
    operator 5 >(halfvec, halfvec),
    operator 2 <=(halfvec, halfvec),
    operator 1 <(halfvec, halfvec),
    function 1(halfvec, halfvec) halfvec_cmp(halfvec, halfvec);

alter operator family halfvec_ops using btree owner to supabase_admin;

create operator class halfvec_ops default for type halfvec using btree as
    operator 4 >=(halfvec, halfvec),
    operator 3 =(halfvec, halfvec),
    operator 2 <=(halfvec, halfvec),
    operator 1 <(halfvec, halfvec),
    operator 5 >(halfvec, halfvec),
    function 1(halfvec, halfvec) halfvec_cmp(halfvec, halfvec);

alter operator class halfvec_ops using btree owner to supabase_admin;

create operator family halfvec_l2_ops using ivfflat;

alter operator family halfvec_l2_ops using ivfflat add
    operator 1 <->(halfvec, halfvec) for order by float_ops,
    function 3(halfvec, halfvec) l2_distance(halfvec, halfvec),
    function 1(halfvec, halfvec) halfvec_l2_squared_distance(halfvec, halfvec),
    function 5(halfvec, halfvec) ivfflat_halfvec_support(internal);

alter operator family halfvec_l2_ops using ivfflat owner to supabase_admin;

create operator class halfvec_l2_ops for type halfvec using ivfflat as
    operator 1 <->(halfvec, halfvec) for order by float_ops,
    function 5(halfvec, halfvec) ivfflat_halfvec_support(internal),
    function 1(halfvec, halfvec) halfvec_l2_squared_distance(halfvec, halfvec),
    function 3(halfvec, halfvec) l2_distance(halfvec, halfvec);

alter operator class halfvec_l2_ops using ivfflat owner to supabase_admin;

create operator family halfvec_ip_ops using ivfflat;

alter operator family halfvec_ip_ops using ivfflat add
    operator 1 <#>(halfvec, halfvec) for order by float_ops,
    function 5(halfvec, halfvec) ivfflat_halfvec_support(internal),
    function 3(halfvec, halfvec) halfvec_spherical_distance(halfvec, halfvec),
    function 4(halfvec, halfvec) l2_norm(halfvec),
    function 1(halfvec, halfvec) halfvec_negative_inner_product(halfvec, halfvec);

alter operator family halfvec_ip_ops using ivfflat owner to supabase_admin;

create operator class halfvec_ip_ops for type halfvec using ivfflat as
    operator 1 <#>(halfvec, halfvec) for order by float_ops,
    function 3(halfvec, halfvec) halfvec_spherical_distance(halfvec, halfvec),
    function 1(halfvec, halfvec) halfvec_negative_inner_product(halfvec, halfvec),
    function 4(halfvec, halfvec) l2_norm(halfvec),
    function 5(halfvec, halfvec) ivfflat_halfvec_support(internal);

alter operator class halfvec_ip_ops using ivfflat owner to supabase_admin;

create operator family halfvec_cosine_ops using ivfflat;

alter operator family halfvec_cosine_ops using ivfflat add
    operator 1 <=>(halfvec, halfvec) for order by float_ops,
    function 5(halfvec, halfvec) ivfflat_halfvec_support(internal),
    function 2(halfvec, halfvec) l2_norm(halfvec),
    function 3(halfvec, halfvec) halfvec_spherical_distance(halfvec, halfvec),
    function 4(halfvec, halfvec) l2_norm(halfvec),
    function 1(halfvec, halfvec) halfvec_negative_inner_product(halfvec, halfvec);

alter operator family halfvec_cosine_ops using ivfflat owner to supabase_admin;

create operator class halfvec_cosine_ops for type halfvec using ivfflat as
    operator 1 <=>(halfvec, halfvec) for order by float_ops,
    function 5(halfvec, halfvec) ivfflat_halfvec_support(internal),
    function 3(halfvec, halfvec) halfvec_spherical_distance(halfvec, halfvec),
    function 2(halfvec, halfvec) l2_norm(halfvec),
    function 1(halfvec, halfvec) halfvec_negative_inner_product(halfvec, halfvec),
    function 4(halfvec, halfvec) l2_norm(halfvec);

alter operator class halfvec_cosine_ops using ivfflat owner to supabase_admin;

create operator family halfvec_l2_ops using hnsw;

alter operator family halfvec_l2_ops using hnsw add
    operator 1 <->(halfvec, halfvec) for order by float_ops,
    function 1(halfvec, halfvec) halfvec_l2_squared_distance(halfvec, halfvec),
    function 3(halfvec, halfvec) hnsw_halfvec_support(internal);

alter operator family halfvec_l2_ops using hnsw owner to supabase_admin;

create operator class halfvec_l2_ops for type halfvec using hnsw as
    operator 1 <->(halfvec, halfvec) for order by float_ops,
    function 3(halfvec, halfvec) hnsw_halfvec_support(internal),
    function 1(halfvec, halfvec) halfvec_l2_squared_distance(halfvec, halfvec);

alter operator class halfvec_l2_ops using hnsw owner to supabase_admin;

create operator family halfvec_ip_ops using hnsw;

alter operator family halfvec_ip_ops using hnsw add
    operator 1 <#>(halfvec, halfvec) for order by float_ops,
    function 3(halfvec, halfvec) hnsw_halfvec_support(internal),
    function 1(halfvec, halfvec) halfvec_negative_inner_product(halfvec, halfvec);

alter operator family halfvec_ip_ops using hnsw owner to supabase_admin;

create operator class halfvec_ip_ops for type halfvec using hnsw as
    operator 1 <#>(halfvec, halfvec) for order by float_ops,
    function 1(halfvec, halfvec) halfvec_negative_inner_product(halfvec, halfvec),
    function 3(halfvec, halfvec) hnsw_halfvec_support(internal);

alter operator class halfvec_ip_ops using hnsw owner to supabase_admin;

create operator family halfvec_cosine_ops using hnsw;

alter operator family halfvec_cosine_ops using hnsw add
    operator 1 <=>(halfvec, halfvec) for order by float_ops,
    function 3(halfvec, halfvec) hnsw_halfvec_support(internal),
    function 2(halfvec, halfvec) l2_norm(halfvec),
    function 1(halfvec, halfvec) halfvec_negative_inner_product(halfvec, halfvec);

alter operator family halfvec_cosine_ops using hnsw owner to supabase_admin;

create operator class halfvec_cosine_ops for type halfvec using hnsw as
    operator 1 <=>(halfvec, halfvec) for order by float_ops,
    function 2(halfvec, halfvec) l2_norm(halfvec),
    function 3(halfvec, halfvec) hnsw_halfvec_support(internal),
    function 1(halfvec, halfvec) halfvec_negative_inner_product(halfvec, halfvec);

alter operator class halfvec_cosine_ops using hnsw owner to supabase_admin;

create operator family halfvec_l1_ops using hnsw;

alter operator family halfvec_l1_ops using hnsw add
    operator 1 <+>(halfvec, halfvec) for order by float_ops,
    function 3(halfvec, halfvec) hnsw_halfvec_support(internal),
    function 1(halfvec, halfvec) l1_distance(halfvec, halfvec);

alter operator family halfvec_l1_ops using hnsw owner to supabase_admin;

create operator class halfvec_l1_ops for type halfvec using hnsw as
    operator 1 <+>(halfvec, halfvec) for order by float_ops,
    function 3(halfvec, halfvec) hnsw_halfvec_support(internal),
    function 1(halfvec, halfvec) l1_distance(halfvec, halfvec);

alter operator class halfvec_l1_ops using hnsw owner to supabase_admin;

create operator family bit_hamming_ops using ivfflat;

alter operator family bit_hamming_ops using ivfflat add
    operator 1 <~>(bit, bit) for order by float_ops,
    function 5(bit, bit) ivfflat_bit_support(internal),
    function 1(bit, bit) hamming_distance(bit, bit),
    function 3(bit, bit) hamming_distance(bit, bit);

alter operator family bit_hamming_ops using ivfflat owner to supabase_admin;

create operator class bit_hamming_ops for type bit using ivfflat as
    operator 1 <~>(bit, bit) for order by float_ops,
    function 1(bit, bit) hamming_distance(bit, bit),
    function 5(bit, bit) ivfflat_bit_support(internal),
    function 3(bit, bit) hamming_distance(bit, bit);

alter operator class bit_hamming_ops using ivfflat owner to supabase_admin;

create operator family bit_hamming_ops using hnsw;

alter operator family bit_hamming_ops using hnsw add
    operator 1 <~>(bit, bit) for order by float_ops,
    function 1(bit, bit) hamming_distance(bit, bit),
    function 3(bit, bit) hnsw_bit_support(internal);

alter operator family bit_hamming_ops using hnsw owner to supabase_admin;

create operator class bit_hamming_ops for type bit using hnsw as
    operator 1 <~>(bit, bit) for order by float_ops,
    function 1(bit, bit) hamming_distance(bit, bit),
    function 3(bit, bit) hnsw_bit_support(internal);

alter operator class bit_hamming_ops using hnsw owner to supabase_admin;

create operator family bit_jaccard_ops using hnsw;

alter operator family bit_jaccard_ops using hnsw add
    operator 1 <%>(bit, bit) for order by float_ops,
    function 1(bit, bit) jaccard_distance(bit, bit),
    function 3(bit, bit) hnsw_bit_support(internal);

alter operator family bit_jaccard_ops using hnsw owner to supabase_admin;

create operator class bit_jaccard_ops for type bit using hnsw as
    operator 1 <%>(bit, bit) for order by float_ops,
    function 3(bit, bit) hnsw_bit_support(internal),
    function 1(bit, bit) jaccard_distance(bit, bit);

alter operator class bit_jaccard_ops using hnsw owner to supabase_admin;

create operator family sparsevec_ops using btree;

alter operator family sparsevec_ops using btree add
    operator 4 >=(sparsevec, sparsevec),
    operator 5 >(sparsevec, sparsevec),
    operator 1 <(sparsevec, sparsevec),
    operator 3 =(sparsevec, sparsevec),
    operator 2 <=(sparsevec, sparsevec),
    function 1(sparsevec, sparsevec) sparsevec_cmp(sparsevec, sparsevec);

alter operator family sparsevec_ops using btree owner to supabase_admin;

create operator class sparsevec_ops default for type sparsevec using btree as
    operator 4 >=(sparsevec, sparsevec),
    operator 5 >(sparsevec, sparsevec),
    operator 1 <(sparsevec, sparsevec),
    operator 3 =(sparsevec, sparsevec),
    operator 2 <=(sparsevec, sparsevec),
    function 1(sparsevec, sparsevec) sparsevec_cmp(sparsevec, sparsevec);

alter operator class sparsevec_ops using btree owner to supabase_admin;

create operator family sparsevec_l2_ops using hnsw;

alter operator family sparsevec_l2_ops using hnsw add
    operator 1 <->(sparsevec, sparsevec) for order by float_ops,
    function 3(sparsevec, sparsevec) hnsw_sparsevec_support(internal),
    function 1(sparsevec, sparsevec) sparsevec_l2_squared_distance(sparsevec, sparsevec);

alter operator family sparsevec_l2_ops using hnsw owner to supabase_admin;

create operator class sparsevec_l2_ops for type sparsevec using hnsw as
    operator 1 <->(sparsevec, sparsevec) for order by float_ops,
    function 3(sparsevec, sparsevec) hnsw_sparsevec_support(internal),
    function 1(sparsevec, sparsevec) sparsevec_l2_squared_distance(sparsevec, sparsevec);

alter operator class sparsevec_l2_ops using hnsw owner to supabase_admin;

create operator family sparsevec_ip_ops using hnsw;

alter operator family sparsevec_ip_ops using hnsw add
    operator 1 <#>(sparsevec, sparsevec) for order by float_ops,
    function 3(sparsevec, sparsevec) hnsw_sparsevec_support(internal),
    function 1(sparsevec, sparsevec) sparsevec_negative_inner_product(sparsevec, sparsevec);

alter operator family sparsevec_ip_ops using hnsw owner to supabase_admin;

create operator class sparsevec_ip_ops for type sparsevec using hnsw as
    operator 1 <#>(sparsevec, sparsevec) for order by float_ops,
    function 3(sparsevec, sparsevec) hnsw_sparsevec_support(internal),
    function 1(sparsevec, sparsevec) sparsevec_negative_inner_product(sparsevec, sparsevec);

alter operator class sparsevec_ip_ops using hnsw owner to supabase_admin;

create operator family sparsevec_cosine_ops using hnsw;

alter operator family sparsevec_cosine_ops using hnsw add
    operator 1 <=>(sparsevec, sparsevec) for order by float_ops,
    function 1(sparsevec, sparsevec) sparsevec_negative_inner_product(sparsevec, sparsevec),
    function 2(sparsevec, sparsevec) l2_norm(sparsevec),
    function 3(sparsevec, sparsevec) hnsw_sparsevec_support(internal);

alter operator family sparsevec_cosine_ops using hnsw owner to supabase_admin;

create operator class sparsevec_cosine_ops for type sparsevec using hnsw as
    operator 1 <=>(sparsevec, sparsevec) for order by float_ops,
    function 1(sparsevec, sparsevec) sparsevec_negative_inner_product(sparsevec, sparsevec),
    function 2(sparsevec, sparsevec) l2_norm(sparsevec),
    function 3(sparsevec, sparsevec) hnsw_sparsevec_support(internal);

alter operator class sparsevec_cosine_ops using hnsw owner to supabase_admin;

create operator family sparsevec_l1_ops using hnsw;

alter operator family sparsevec_l1_ops using hnsw add
    operator 1 <+>(sparsevec, sparsevec) for order by float_ops,
    function 1(sparsevec, sparsevec) l1_distance(sparsevec, sparsevec),
    function 3(sparsevec, sparsevec) hnsw_sparsevec_support(internal);

alter operator family sparsevec_l1_ops using hnsw owner to supabase_admin;

create operator class sparsevec_l1_ops for type sparsevec using hnsw as
    operator 1 <+>(sparsevec, sparsevec) for order by float_ops,
    function 3(sparsevec, sparsevec) hnsw_sparsevec_support(internal),
    function 1(sparsevec, sparsevec) l1_distance(sparsevec, sparsevec);

alter operator class sparsevec_l1_ops using hnsw owner to supabase_admin;

-- Cyclic dependencies found

create operator %> (procedure = word_similarity_commutator_op, leftarg = text, rightarg = text, commutator = <%, join = matchingjoinsel, restrict = matchingsel);

alter operator %>(text, text) owner to supabase_admin;

create operator <% (procedure = word_similarity_op, leftarg = text, rightarg = text, commutator = %>, join = matchingjoinsel, restrict = matchingsel);

alter operator <%(text, text) owner to supabase_admin;

-- Cyclic dependencies found

create operator %>> (procedure = strict_word_similarity_commutator_op, leftarg = text, rightarg = text, commutator = <<%, join = matchingjoinsel, restrict = matchingsel);

alter operator %>>(text, text) owner to supabase_admin;

create operator <<% (procedure = strict_word_similarity_op, leftarg = text, rightarg = text, commutator = %>>, join = matchingjoinsel, restrict = matchingsel);

alter operator <<%(text, text) owner to supabase_admin;

-- Cyclic dependencies found

create operator <->> (procedure = word_similarity_dist_commutator_op, leftarg = text, rightarg = text, commutator = <<->);

alter operator <->>(text, text) owner to supabase_admin;

create operator <<-> (procedure = word_similarity_dist_op, leftarg = text, rightarg = text, commutator = <->>);

alter operator <<->(text, text) owner to supabase_admin;

-- Cyclic dependencies found

create operator <->>> (procedure = strict_word_similarity_dist_commutator_op, leftarg = text, rightarg = text, commutator = <<<->);

alter operator <->>>(text, text) owner to supabase_admin;

create operator <<<-> (procedure = strict_word_similarity_dist_op, leftarg = text, rightarg = text, commutator = <->>>);

alter operator <<<->(text, text) owner to supabase_admin;

-- Cyclic dependencies found

create operator <> (procedure = halfvec_ne, leftarg = halfvec, rightarg = halfvec, commutator = <>, negator = =, join = eqjoinsel, restrict = eqsel);

alter operator <>(halfvec, halfvec) owner to supabase_admin;

create operator = (procedure = halfvec_eq, leftarg = halfvec, rightarg = halfvec, commutator = =, negator = <>, join = eqjoinsel, restrict = eqsel);

alter operator =(halfvec, halfvec) owner to supabase_admin;

-- Cyclic dependencies found

create operator <> (procedure = sparsevec_ne, leftarg = sparsevec, rightarg = sparsevec, commutator = <>, negator = =, join = eqjoinsel, restrict = eqsel);

alter operator <>(sparsevec, sparsevec) owner to supabase_admin;

create operator = (procedure = sparsevec_eq, leftarg = sparsevec, rightarg = sparsevec, commutator = =, negator = <>, join = eqjoinsel, restrict = eqsel);

alter operator =(sparsevec, sparsevec) owner to supabase_admin;

-- Cyclic dependencies found

create operator <> (procedure = vector_ne, leftarg = vector, rightarg = vector, commutator = <>, negator = =, join = eqjoinsel, restrict = eqsel);

alter operator <>(vector, vector) owner to supabase_admin;

create operator = (procedure = vector_eq, leftarg = vector, rightarg = vector, commutator = =, negator = <>, join = eqjoinsel, restrict = eqsel);

alter operator =(vector, vector) owner to supabase_admin;

-- Cyclic dependencies found

create operator < (procedure = halfvec_lt, leftarg = halfvec, rightarg = halfvec, commutator = >, negator = >=, join = scalarltjoinsel, restrict = scalarltsel);

alter operator <(halfvec, halfvec) owner to supabase_admin;

-- Cyclic dependencies found

create operator > (procedure = halfvec_gt, leftarg = halfvec, rightarg = halfvec, commutator = <, negator = <=, join = scalargtjoinsel, restrict = scalargtsel);

alter operator >(halfvec, halfvec) owner to supabase_admin;

-- Cyclic dependencies found

create operator <= (procedure = halfvec_le, leftarg = halfvec, rightarg = halfvec, commutator = >=, negator = >, join = scalarlejoinsel, restrict = scalarlesel);

alter operator <=(halfvec, halfvec) owner to supabase_admin;

create operator >= (procedure = halfvec_ge, leftarg = halfvec, rightarg = halfvec, commutator = <=, negator = <, join = scalargejoinsel, restrict = scalargesel);

alter operator >=(halfvec, halfvec) owner to supabase_admin;

-- Cyclic dependencies found

create operator < (procedure = sparsevec_lt, leftarg = sparsevec, rightarg = sparsevec, commutator = >, negator = >=, join = scalarltjoinsel, restrict = scalarltsel);

alter operator <(sparsevec, sparsevec) owner to supabase_admin;

-- Cyclic dependencies found

create operator > (procedure = sparsevec_gt, leftarg = sparsevec, rightarg = sparsevec, commutator = <, negator = <=, join = scalargtjoinsel, restrict = scalargtsel);

alter operator >(sparsevec, sparsevec) owner to supabase_admin;

-- Cyclic dependencies found

create operator <= (procedure = sparsevec_le, leftarg = sparsevec, rightarg = sparsevec, commutator = >=, negator = >, join = scalarlejoinsel, restrict = scalarlesel);

alter operator <=(sparsevec, sparsevec) owner to supabase_admin;

create operator >= (procedure = sparsevec_ge, leftarg = sparsevec, rightarg = sparsevec, commutator = <=, negator = <, join = scalargejoinsel, restrict = scalargesel);

alter operator >=(sparsevec, sparsevec) owner to supabase_admin;

-- Cyclic dependencies found

create operator < (procedure = vector_lt, leftarg = vector, rightarg = vector, commutator = >, negator = >=, join = scalarltjoinsel, restrict = scalarltsel);

alter operator <(vector, vector) owner to supabase_admin;

-- Cyclic dependencies found

create operator > (procedure = vector_gt, leftarg = vector, rightarg = vector, commutator = <, negator = <=, join = scalargtjoinsel, restrict = scalargtsel);

alter operator >(vector, vector) owner to supabase_admin;

-- Cyclic dependencies found

create operator <= (procedure = vector_le, leftarg = vector, rightarg = vector, commutator = >=, negator = >, join = scalarlejoinsel, restrict = scalarlesel);

alter operator <=(vector, vector) owner to supabase_admin;

create operator >= (procedure = vector_ge, leftarg = vector, rightarg = vector, commutator = <=, negator = <, join = scalargejoinsel, restrict = scalargesel);

alter operator >=(vector, vector) owner to supabase_admin;

