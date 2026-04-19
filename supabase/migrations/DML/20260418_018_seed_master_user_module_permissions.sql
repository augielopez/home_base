INSERT INTO master_user_module_permissions (user_module_access_id, permission_id, granted_by)
SELECT uma.user_module_access_id, p.permission_id, 5
FROM master_user_module_access uma
         CROSS JOIN master_permissions p
WHERE uma.user_id = 5
ON CONFLICT (user_module_access_id, permission_id) DO NOTHING;
