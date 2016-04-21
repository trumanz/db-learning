#!/usr/bin/env python
import os
import time
from sqlalchemy import create_engine
import unittest

class pgFunction(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
          cls._cluster  = ""
    @classmethod
    def tearDownClass(cls):
          #close all sessions and connection assocaiated with this Cluster
          cls._cluster = "x"

    def test_set(self):
        engine = create_engine("postgresql://postgres:postgres@" +  os.environ["PG_HOST"]   + "/fly");
        conn  = engine.connect()
        id = conn.execute("INSERT INTO tasks (submit_time) VALUES ('2000-01-01 04:05:06') RETURNING id;").fetchone()[0];
        conn.execute("INSERT INTO airports (id) VALUES ('A');");
        conn.execute("INSERT INTO airports (id) VALUES ('B');");
        conn.execute("INSERT INTO flights (task_id, flight_id, departure_airport, arrival_airport, departure_timestampe) VALUES ('%s', '1', 'A', 'B', '2000-01-01 01:00:00');"%(id));
        conn.execute("INSERT INTO flights (task_id, flight_id, departure_airport, arrival_airport, departure_timestampe) VALUES ('%s', '2', 'A', 'B', '2000-01-01 01:00:00');"%(id));
        conn.execute("INSERT INTO flights (task_id, flight_id, departure_airport, arrival_airport, departure_timestampe) VALUES ('%s', '3', 'A', 'B', '2000-01-01 02:00:00');"%(id));
        conn.execute("INSERT INTO flights (task_id, flight_id, departure_airport, arrival_airport, departure_timestampe) VALUES ('%s', '4', 'A', 'B', '2000-01-01 04:00:00');"%(id));
        rs = conn.execute("SELECT * from tasks").fetchall();
        print rs
        rs = conn.execute("SELECT * from load_flights_with_departure('A', '2000-01-01 01:00:00', '2000-01-01 04:00:00')").fetchall();
        print rs

