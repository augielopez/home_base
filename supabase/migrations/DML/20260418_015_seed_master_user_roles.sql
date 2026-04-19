INSERT INTO master_user_roles (user_id, role_id, assigned_by)
SELECT 5, role_id, 5
FROM master_roles
ON CONFLICT (user_id, role_id) DO NOTHING;
