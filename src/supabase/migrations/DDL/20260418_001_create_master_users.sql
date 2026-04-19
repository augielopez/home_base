CREATE TABLE master_users
(
    user_id           BIGSERIAL PRIMARY KEY,
    first_name        VARCHAR(100)                                       NOT NULL,
    last_name         VARCHAR(100)                                       NOT NULL,
    phone_number      VARCHAR(25),
    email             VARCHAR(255),
    address           TEXT,
    birthday          DATE,
    phone_carrier     VARCHAR(50),
    notes             TEXT,
    number_of_invites INTEGER                  DEFAULT 0                 NOT NULL,
    number_attended   INTEGER                  DEFAULT 0                 NOT NULL,
    created_at        TIMESTAMPTZ              DEFAULT NOW()             NOT NULL,
    updated_at        TIMESTAMPTZ              DEFAULT NOW()             NOT NULL,
    username          VARCHAR(100) UNIQUE,
    password_hash     TEXT,
    party_size        SMALLINT                 DEFAULT 4                 NOT NULL
);