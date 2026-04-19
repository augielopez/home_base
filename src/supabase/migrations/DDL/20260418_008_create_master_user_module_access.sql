CREATE TABLE IF NOT EXISTS master_user_module_access
(
    user_module_access_id BIGSERIAL PRIMARY KEY,
    user_id               BIGINT                   NOT NULL REFERENCES master_users (user_id) ON DELETE CASCADE,
    module_id             BIGINT                   NOT NULL REFERENCES master_modules (module_id) ON DELETE CASCADE,
    granted_at            TIMESTAMPTZ              NOT NULL DEFAULT NOW(),
    granted_by            BIGINT                   NULL REFERENCES master_users (user_id),
    is_active             BOOLEAN                  NOT NULL DEFAULT TRUE,
    CONSTRAINT uq_master_user_module_access UNIQUE (user_id, module_id)
);
