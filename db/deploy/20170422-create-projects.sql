-- Deploy your-database:20170422-create-projects to pg

BEGIN;

CREATE SEQUENCE projects_sequence;

CREATE TABLE projects (
    id INT NOT NULL PRIMARY KEY DEFAULT nextval('projects_sequence'),
    title VARCHAR NOT NULL
);

CREATE UNIQUE INDEX projects_title ON projects(title);

COMMIT;
