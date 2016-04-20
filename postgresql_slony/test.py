#!/usr/bin/env python

import os
from sqlalchemy import create_engine



pg_master = os.environ["MASTERHOST"]
pg_slave  =  os.environ["SLAVEHOST"]


engine = create_engine("postgresql://postgres:postgres@" +  pg_master + "/fly");

connection  = engine.connect()
trans = connection.begin()


id =  connection.execute("INSERT INTO tasks (submit_time) VALUES ('1999-01-08 04:05:06') RETURNING id;").fetchone()[0];


print id

connection.execute("INSERT INTO flights (task_id, flight_id) VALUES ('%s', '1');"%(id))


trans.commit()
