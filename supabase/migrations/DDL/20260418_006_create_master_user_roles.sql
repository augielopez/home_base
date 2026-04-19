CREATE TABLE IF NOT EXISTS master_user_roles
(
    user_role_id BIGSERIAL PRIMARY KEY,
    user_id      BIGINT                   NOT NULL REFERENCES master_users (user_id) ON DELETE CASCADE,
    role_id      BIGINT                   NOT NULL REFERENCES master_roles (role_id) ON DELETE CASCADE,
    assigned_at  TIMESTAMPTZ              NOT NULL DEFAULT NOW(),
    assigned_by  BIGINT                   NULL REFERENCES master_users (user_id),
    is_active    BOOLEAN                  NOT NULL DEFAULT TRUE,
    CONSTRAINT uq_master_user_roles UNIQUE (user_id, role_id)
);
