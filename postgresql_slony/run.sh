#!/bin/bash

cd  pg_script  && ./start_pg_slony_cluster.sh && cd -
source  pg_script/tmp.env
./test.py

