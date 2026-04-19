CREATE TABLE IF NOT EXISTS master_user_module_permissions
(
    user_module_permission_id BIGSERIAL PRIMARY KEY,
    user_module_access_id     BIGINT                   NOT NULL REFERENCES master_user_module_access (user_module_access_id) ON DELETE CASCADE,
    permission_id             BIGINT                   NOT NULL REFERENCES master_permissions (permission_id) ON DELETE CASCADE,
    granted_at                TIMESTAMPTZ              NOT NULL DEFAULT NOW(),
    granted_by                BIGINT                   NULL REFERENCES master_users (user_id),
    CONSTRAINT uq_master_user_module_permission UNIQUE (user_module_access_id, permission_id)
);
