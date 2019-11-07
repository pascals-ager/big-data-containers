#!/bin/bash

hadoop fs -mkdir       /tmp
hadoop fs -mkdir -p    /user/hive/warehouse
hadoop fs -chmod -R 777 /tmp
hadoop fs -chmod -R 777 /user/hive/warehouse

cd $HIVE_HOME/bin
./hiveserver2
