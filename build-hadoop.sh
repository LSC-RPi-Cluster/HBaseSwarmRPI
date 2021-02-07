#!/bin/bash

# Base
docker build ~/HBaseSwarmRPI/hadoop/base/ -t lucasfs/hadoop-base:hadoop-3.2.1 --no-cache
docker push lucasfs/hadoop-base:hadoop-3.2.1

# Datanode
docker build ~/HBaseSwarmRPI/hadoop/datanode/ -t lucasfs/hadoop-datanode:hadoop-3.2.1 --no-cache
docker push lucasfs/hadoop-hmaster:hadoop-3.2.1

# Namenode
docker build ~/HBaseSwarmRPI/hadoop/namenode/ -t lucasfs/hbase-namenode:hadoop-3.2.1 --no-cache
docker push lucasfs/hbase-namenode:hadoop-3.2.1
