INSERT INTO master_applications (application_name, application_code)
VALUES ('HomeBase', 'HOMEBASE'),
       ('Tagify', 'TAGIFY'),
       ('ChristmasCalls', 'CHRISTMASCALLS')
ON CONFLICT (application_code) DO NOTHING;
