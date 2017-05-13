-- Deploy your-database:todo-backend to pg

BEGIN;

CREATE SEQUENCE todos_sequence;

CREATE TABLE todos (
    id INT NOT NULL PRIMARY KEY DEFAULT nextval('todos_sequence'),
    title VARCHAR NOT NULL,
    completed BOOL NOT NULL DEFAULT FALSE,
    "order" INTEGER NULL
);

COMMIT;
