-- Revert your-database:todo-backend from pg

BEGIN;

DROP TABLE todos;

DROP SEQUENCE todos_sequence;

COMMIT;
