INSERT INTO master_roles (role_name, role_code, description)
VALUES ('HomeBase Admin', 'HOMEBASE_ADMIN', 'Full system access'),
       ('HomeBase Manager', 'HOMEBASE_MANAGER', 'Operational control'),
       ('HomeBase Editor', 'HOMEBASE_EDITOR', 'Create and edit'),
       ('HomeBase Viewer', 'HOMEBASE_VIEWER', 'Read-only access')
ON CONFLICT (role_code) DO NOTHING;
