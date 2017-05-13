-- Verify your-database:todo-backend on pg

BEGIN;

SELECT
        id,
        title,
        completed,
        "order"
    FROM
        todos
    WHERE
        FALSE
    ;

ROLLBACK;
