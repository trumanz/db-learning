#!/bin/bash

#docker pull  trumanz/postgresql
docker run --name=pg -h pg  -t -d -i  trumanz/postgresql  /start_pg.sh
IP=$(docker inspect --format='{{ .NetworkSettings.IPAddress }}'  pg)
echo $IP

docker rm -f  pg

