#!/usr/bin/env python
import os
import time
from sqlalchemy import create_engine
import unittest

class TestConcurrency(unittest.TestCase):
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
        id = connection.execute("INSERT INTO tasks (submit_time) VALUES ('1999-01-08 04:05:06') RETURNING id;").fetchone()[0];
        connection.execute("INSERT INTO flights (task_id, flight_id) VALUES ('%s', '1');"%(id));


