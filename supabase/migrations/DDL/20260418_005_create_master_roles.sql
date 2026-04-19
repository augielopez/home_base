CREATE TABLE IF NOT EXISTS master_roles
(
    role_id      BIGSERIAL PRIMARY KEY,
    role_name    VARCHAR(100)             NOT NULL UNIQUE,
    role_code    VARCHAR(100)             NOT NULL UNIQUE,
    description  TEXT,
    is_active    BOOLEAN                  NOT NULL DEFAULT TRUE,
    created_at   TIMESTAMPTZ              NOT NULL DEFAULT NOW()
);
