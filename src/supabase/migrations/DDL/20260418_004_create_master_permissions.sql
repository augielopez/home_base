CREATE TABLE IF NOT EXISTS master_permissions
(
    permission_id   BIGSERIAL PRIMARY KEY,
    permission_name VARCHAR(100)             NOT NULL UNIQUE,
    permission_code VARCHAR(100)             NOT NULL UNIQUE,
    description     TEXT,
    created_at      TIMESTAMPTZ              NOT NULL DEFAULT NOW()
);
