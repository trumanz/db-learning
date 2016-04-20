#!/bin/sh


start_nodes() {
   docker rm -f  pg0
   docker rm -f  pg1

   docker run --name=pg0 -h pg0  -t -d -i  trumanz/postgresql_slony  /run.sh
   docker run --name=pg1 -h pg1  -t -d -i  trumanz/postgresql_slony  /run.sh
   sleep 5
}


#import db in master aand slave
init_db() {
  env PGPASSWORD=postgres psql -h $IP0 -U postgres   -f  init_db.sql
  env PGPASSWORD=postgres psql -h $IP1 -U postgres   -f  init_db.sql
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

generate_env() {
  rm -f tmp.env
  echo "export CLUSTERNAME=trumanzPGC"   >> tmp.env
  echo "export MASTERHOST=$IP0"   >> tmp.env
  echo "export MASTERDBNAME=fly"  >> tmp.env
  echo "export SLAVEHOST=$IP1"    >> tmp.env
  echo "export SLAVEDBNAME=fly"   >> tmp.env 
}

generate_slon_conf() {
  conf=tmp.node0.slon.conf
  rm -f  $conf 
  echo "log_level=2" >> $conf
  echo "sync_max_rowsize=32768" >> $conf
  echo "conn_info='host=$IP0 port=5432 dbname=fly user=slony password=slony'" >> $conf
  echo  "cluster_name='trumanzPGC'" >> $conf
   
  docker exec -ti  pg0 mkdir /etc/slony1/node0
  docker cp $conf pg0:/etc/slony1/node0/slon.conf

  conf=tmp.node1.slon.conf
  rm -f  $conf 
  echo "log_level=2" >> $conf
  echo "sync_max_rowsize=32768" >> $conf
  echo "conn_info='host=$IP1 port=5432 dbname=fly user=slony password=slony'" >> $conf
  echo  "cluster_name='trumanzPGC'" >> $conf
  docker exec -ti  pg1 mkdir /etc/slony1/node0
  docker cp $conf pg1:/etc/slony1/node0/slon.conf
  docker exec -d -ti  pg0   /etc/init.d/slony1  start
  docker exec -d -ti  pg1   /etc/init.d/slony1  start
}

run_1() {
rm -f all.tar.gz 
tar czvf all.tar.gz  *
docker exec -ti  pg0  rm -rf /test
docker exec -ti  pg0  mkdir /test
docker cp  all.tar.gz  pg0:/test
docker exec -ti pg0  sh -c "cd /test  && tar xf  all.tar.gz && ./slonik_1.sh"
}

start_nodes
IP0=$(docker inspect --format='{{ .NetworkSettings.IPAddress }}'  pg0)
IP1=$(docker inspect --format='{{ .NetworkSettings.IPAddress }}'  pg1)
init_db
generate_env

./slonik_init_cluster.sh
generate_slon_conf
show_db $IP0
show_db $IP1

./slonik_set_subscribe.sh
show_db $IP0
show_db $IP1
sleep 1
show_db $IP0
show_db $IP1
