CREATE TABLE IF NOT EXISTS master_applications
(
    application_id   BIGSERIAL PRIMARY KEY,
    application_name VARCHAR(100) NOT NULL UNIQUE,
    application_code VARCHAR(100) NOT NULL UNIQUE,
    is_active        BOOLEAN                  NOT NULL DEFAULT TRUE,
    created_at       TIMESTAMPTZ              NOT NULL DEFAULT NOW()
);
