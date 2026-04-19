INSERT INTO master_user_module_access (user_id, module_id, granted_by)
SELECT 5, module_id, 5
FROM master_modules
ON CONFLICT (user_id, module_id) DO NOTHING;
