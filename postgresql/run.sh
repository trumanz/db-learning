#!/bin/bash

#docker pull  trumanz/postgresql
docker run --name=pg -h pg  -t -d -i  trumanz/postgresql  /start_pg.sh
IP=$(docker inspect --format='{{ .NetworkSettings.IPAddress }}'  pg)
echo $IP

ping -c 5 $IP
export PG_HOST=$IP
env PGPASSWORD=postgres psql -h $PG_HOST   -U postgres   -f  init_db.sql

python -m unittest discover -v  -s  ./test  -p test*.py
ci_status=$?
docker rm -f  pg

exit $ci_status
