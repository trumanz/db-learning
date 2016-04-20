#!/usr/bin/env python

import os
import time
from sqlalchemy import create_engine






def create_data(connection):
   trans = connection.begin()
   id =  connection.execute("INSERT INTO tasks (submit_time) VALUES ('1999-01-08 04:05:06') RETURNING id;").fetchone()[0];
   print id
   connection.execute("INSERT INTO flights (task_id, flight_id) VALUES ('%s', '1');"%(id))
   trans.commit()
   
def show_data(connection):
   print  connection.execute("SELECT * from flights").fetchall();
   

if __name__ ==  '__main__' :
   pg_master = os.environ["MASTERHOST"]
   pg_slave  =  os.environ["SLAVEHOST"]

   master_engine = create_engine("postgresql://postgres:postgres@" +  pg_master + "/fly");
   master_conn  = master_engine.connect()

   create_data(master_conn)
   time.sleep(2)

   slave_engine = create_engine("postgresql://postgres:postgres@" +  pg_slave + "/fly");
   slave_conn  = slave_engine.connect()
   #connection.close()
   #engine.dispose()

   show_data(slave_conn)
   show_data(slave_conn)
