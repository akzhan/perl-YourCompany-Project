-- Verify your-database:20170422-create-projects on pg

BEGIN;

SELECT
        id,
        title
    FROM
        projects
    WHERE
        FALSE
    ;

ROLLBACK;
