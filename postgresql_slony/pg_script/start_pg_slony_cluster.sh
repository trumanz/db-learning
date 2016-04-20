#!/bin/sh

./pg_start_cluster.sh
./pg_init_db.sh

#TODO, this command could run on client node
docker exec -ti  pg0  sh -c  "cd /hostdata/  && ./slonik_init_cluster.sh"

./pg_start_slon.sh

#TODO, this command could run on client node
docker exec -ti  pg0  sh -c  "cd /hostdata/ &&  ./slonik_set_subscribe.sh"
