#!/bin/sh


start_nodes() {
   docker pull  trumanz/postgresql
   docker rm -f  pg0
   docker rm -f  pg1
   DIR=$(pwd)
   docker run --name=pg0 -h pg0  -t -d -i  -v $DIR:/hostdata trumanz/postgresql  /start_pg.sh
   docker run --name=pg1 -h pg1  -t -d -i  -v $DIR:/hostdata trumanz/postgresql  /start_pg.sh
   sleep 5
}


generate_env() {
  IP0=$(docker inspect --format='{{ .NetworkSettings.IPAddress }}'  pg0)
  IP1=$(docker inspect --format='{{ .NetworkSettings.IPAddress }}'  pg1)
  rm -f tmp.env
  echo "export CLUSTERNAME=trumanzPGC"   >> tmp.env
  echo "export MASTERHOST=$IP0"   >> tmp.env
  echo "export MASTERDBNAME=fly"  >> tmp.env
  echo "export SLAVEHOST=$IP1"    >> tmp.env
  echo "export SLAVEDBNAME=fly"   >> tmp.env 
}

start_nodes
generate_env
