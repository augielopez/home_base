-- View: vw_user_permissions
-- Purpose: Aggregate per-user module -> permissions as JSONB for quick lookup by server-side code.
-- Run this once (or include in your migration pipeline).

CREATE OR REPLACE VIEW vw_user_permissions AS
WITH role_module_perms AS (
  SELECT
    ur.user_id,
    m.module_code,
    p.permission_code
  FROM master_user_roles ur
  JOIN master_roles r ON ur.role_id = r.role_id
  JOIN master_role_module_permissions rmp ON r.role_id = rmp.role_id
  JOIN master_modules m ON rmp.module_id = m.module_id
  JOIN master_permissions p ON rmp.permission_id = p.permission_id
  WHERE ur.is_active = true
    AND r.is_active = true
    AND m.is_active = true
)
, per_module AS (
  SELECT
    user_id,
    module_code,
    jsonb_agg(DISTINCT permission_code) AS permissions
  FROM role_module_perms
  GROUP BY user_id, module_code
)
SELECT
  user_id,
  jsonb_object_agg(module_code, permissions) AS modules_perms
FROM per_module
GROUP BY user_id;

-- Example usage:
-- SELECT modules_perms FROM vw_user_permissions WHERE user_id = 123;

