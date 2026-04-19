CREATE TABLE IF NOT EXISTS master_modules
(
    module_id       BIGSERIAL PRIMARY KEY,
    application_id  BIGINT                   NOT NULL REFERENCES master_applications (application_id) ON DELETE CASCADE,
    module_name     VARCHAR(100)             NOT NULL,
    module_code     VARCHAR(100)             NOT NULL,
    description     TEXT,
    is_active       BOOLEAN                  NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ              NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_master_modules_app_code UNIQUE (application_id, module_code),
    CONSTRAINT uq_master_modules_app_name UNIQUE (application_id, module_name)
);
