
-- User for slony-I
CREATE ROLE slony WITH PASSWORD 'slony' LOGIN SUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
ALTER ROLE slony
  SET log_min_error_statement = 'debug';
ALTER ROLE slony
  SET log_min_messages = 'warning';

--create Database 
CREATE ROLE fly WITH PASSWORD 'fly';
DROP DATABASE IF EXISTS fly;

CREATE DATABASE fly  OWNER fly;


\c fly;

CREATE TABLE tasks(
     id serial,
     submit_time timestamp,
     PRIMARY KEY(id)
);
CREATE TABLE  airports(
     id text,
     PRIMARY KEY(id)
);

CREATE TABLE flights (
    task_id serial,
    flight_id  text,
    departure_airport text,
    arrival_airport text,
    departure_timestampe  timestamp,

    FOREIGN KEY(task_id) REFERENCES tasks(id),
    FOREIGN KEY(departure_airport) REFERENCES airports(id),
    FOREIGN KEY(arrival_airport) REFERENCES airports(id),
    PRIMARY KEY(task_id, flight_id)
);
CREATE INDEX task_id_idx ON flights(task_id);

CREATE OR REPLACE FUNCTION public.load_flights_with_departure(
     _departure_airport text,
     _departure_timestampe_l timestamp,
     _departure_timestampe_r timestamp)
   RETURNS SETOF flights AS  $$
   SELECT * FROM flights WHERE departure_airport = $1
                 AND ($2 IS NULL OR departure_timestampe >= _departure_timestampe_l)
                 AND ($3 IS NULL OR departure_timestampe <  _departure_timestampe_r)
   $$ 
   LANGUAGE sql STABLE;

