#!/bin/bash

source tmp.env

init_db() {
  env PGPASSWORD=postgres psql -h $MASTERHOST  -U postgres   -f  init_db.sql
  env PGPASSWORD=postgres psql -h $SLAVEHOST   -U postgres   -f  init_db.sql
}

show_db() {
  host=$1
  echo "+++++++++++++++$host++++++++++++"
#  echo "=====DB         ====="
#  env PGPASSWORD=postgres psql -h $host -U postgres  fly -c  "\d;"
#  echo "=====DB         ====="
  echo "=====TABLE tasks====="
  env PGPASSWORD=postgres psql -h $host -U postgres  fly -c  "\d tasks;"
  echo "=====TABLE tasks====="
  echo "=====TABLE flights==="
  env PGPASSWORD=postgres psql -h $host -U postgres  fly -c  "\d flights;"
  echo "=====TABLE flights==="
  echo "+++++++++++++++$host++++++++++++"
}

init_db
show_db $MASTERHOST
show_db $SLAVEHOST
