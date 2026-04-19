INSERT INTO master_permissions (permission_name, permission_code, description)
VALUES ('View', 'VIEW', 'Read access'),
       ('Create', 'CREATE', 'Create records'),
       ('Edit', 'EDIT', 'Modify records'),
       ('Delete', 'DELETE', 'Remove records'),
       ('Approve', 'APPROVE', 'Approval actions'),
       ('Export', 'EXPORT', 'Export data'),
       ('Admin', 'ADMIN', 'Full access')
ON CONFLICT (permission_code) DO NOTHING;
