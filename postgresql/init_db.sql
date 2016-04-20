CREATE ROLE fly WITH PASSWORD 'fly';
CREATE ROLE slony WITH PASSWORD 'slony' LOGIN SUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
ALTER ROLE slony
  SET log_min_error_statement = 'debug';
ALTER ROLE slony
  SET log_min_messages = 'warning';


DROP DATABASE IF EXISTS fly;

CREATE DATABASE fly  OWNER fly;


\c fly;


CREATE TABLE tasks(
     id serial,
         submit_time timestamp,
     PRIMARY KEY(id)
);

CREATE TABLE flights (
    task_id serial,
    flight_id  text,

    FOREIGN KEY(task_id) REFERENCES tasks(id),
    PRIMARY KEY(task_id, flight_id)
);

CREATE INDEX task_id_idx ON flights(task_id);
