INSERT INTO master_modules (application_id, module_name, module_code, description)
SELECT a.application_id, v.module_name, v.module_code, v.description
FROM master_applications a
         JOIN (VALUES ('Balance Base', 'BALANCE_BASE', 'Financial tracking'),
                      ('Career Base', 'CAREER_BASE', 'Career development'),
                      ('Celebration Base', 'CELEBRATION_BASE', 'Events and milestones'),
                      ('Productivity Base', 'PRODUCTIVITY_BASE', 'Tasks and workflows'),
                      ('Supply Base', 'SUPPLY_BASE', 'Inventory and supplies')) AS v(module_name, module_code, description)
              ON a.application_code = 'HOMEBASE'
ON CONFLICT (application_id, module_code) DO NOTHING;
