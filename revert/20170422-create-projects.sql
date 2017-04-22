-- Revert your-database:20170422-create-projects from pg

BEGIN;

DROP TABLE projects;

DROP SEQUENCE projects_sequence;

COMMIT;
