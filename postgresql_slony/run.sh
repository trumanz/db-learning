#!/bin/sh
./pg_start_cluster.sh
./pg_init_db.sh
./slonik_init_cluster.sh
./pg_start_slon.sh
./slonik_set_subscribe.sh
