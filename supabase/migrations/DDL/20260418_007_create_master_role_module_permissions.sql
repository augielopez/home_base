CREATE TABLE IF NOT EXISTS master_role_module_permissions
(
    role_module_permission_id BIGSERIAL PRIMARY KEY,
    role_id                   BIGINT                   NOT NULL REFERENCES master_roles (role_id) ON DELETE CASCADE,
    module_id                 BIGINT                   NOT NULL REFERENCES master_modules (module_id) ON DELETE CASCADE,
    permission_id             BIGINT                   NOT NULL REFERENCES master_permissions (permission_id) ON DELETE CASCADE,
    created_at                TIMESTAMPTZ              NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_master_role_module_permission UNIQUE (role_id, module_id, permission_id)
);
