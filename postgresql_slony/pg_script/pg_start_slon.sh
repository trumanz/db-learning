#!/bin/bash

source tmp.env

generate_slon_conf() {
  conf=tmp.node0.slon.conf
  rm -f  $conf 
  echo "log_level=2" >> $conf
  echo "sync_max_rowsize=32768" >> $conf
  echo "conn_info='host=$MASTERHOST port=5432 dbname=fly user=slony password=slony'" >> $conf
  echo  "cluster_name='trumanzPGC'" >> $conf
   
  docker exec -ti  pg0 mkdir /etc/slony1/node0
  docker cp $conf pg0:/etc/slony1/node0/slon.conf

  conf=tmp.node1.slon.conf
  rm -f  $conf 
  echo "log_level=2" >> $conf
  echo "sync_max_rowsize=32768" >> $conf
  echo "conn_info='host=$SLAVEHOST port=5432 dbname=fly user=slony password=slony'" >> $conf
  echo  "cluster_name='trumanzPGC'" >> $conf
  docker exec -ti  pg1 mkdir /etc/slony1/node0
  docker cp $conf pg1:/etc/slony1/node0/slon.conf
}

start_slon() {
  docker exec -d -ti  pg0   /etc/init.d/slony1  start
  docker exec -d -ti  pg1   /etc/init.d/slony1  start
}

generate_slon_conf
start_slon
