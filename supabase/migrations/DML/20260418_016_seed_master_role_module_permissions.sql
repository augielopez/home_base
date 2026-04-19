INSERT INTO master_role_module_permissions (role_id, module_id, permission_id)
SELECT r.role_id, m.module_id, p.permission_id
FROM master_roles r
         JOIN master_modules m ON TRUE
         JOIN master_applications a ON a.application_id = m.application_id
         JOIN master_permissions p ON TRUE
WHERE r.role_code = 'HOMEBASE_ADMIN'
  AND a.application_code = 'HOMEBASE'
ON CONFLICT (role_id, module_id, permission_id) DO NOTHING;

INSERT INTO master_role_module_permissions (role_id, module_id, permission_id)
SELECT r.role_id, m.module_id, p.permission_id
FROM master_roles r
         JOIN master_modules m ON TRUE
         JOIN master_applications a ON a.application_id = m.application_id
         JOIN master_permissions p ON p.permission_code IN ('VIEW', 'CREATE', 'EDIT', 'APPROVE', 'EXPORT')
WHERE r.role_code = 'HOMEBASE_MANAGER'
  AND a.application_code = 'HOMEBASE'
ON CONFLICT (role_id, module_id, permission_id) DO NOTHING;

INSERT INTO master_role_module_permissions (role_id, module_id, permission_id)
SELECT r.role_id, m.module_id, p.permission_id
FROM master_roles r
         JOIN master_modules m ON TRUE
         JOIN master_applications a ON a.application_id = m.application_id
         JOIN master_permissions p ON p.permission_code IN ('VIEW', 'CREATE', 'EDIT')
WHERE r.role_code = 'HOMEBASE_EDITOR'
  AND a.application_code = 'HOMEBASE'
ON CONFLICT (role_id, module_id, permission_id) DO NOTHING;

INSERT INTO master_role_module_permissions (role_id, module_id, permission_id)
SELECT r.role_id, m.module_id, p.permission_id
FROM master_roles r
         JOIN master_modules m ON TRUE
         JOIN master_applications a ON a.application_id = m.application_id
         JOIN master_permissions p ON p.permission_code = 'VIEW'
WHERE r.role_code = 'HOMEBASE_VIEWER'
  AND a.application_code = 'HOMEBASE'
ON CONFLICT (role_id, module_id, permission_id) DO NOTHING;
