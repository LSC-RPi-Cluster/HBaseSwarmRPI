#!/bin/bash

# Base
docker build ~/HBaseSwarmRPI/hbase/base/ -t lucasfs/hbase-base:hbase-1.4.13 --no-cache
docker push lucasfs/hbase-base:hbase-1.4.13

# Master
docker build ~/HBaseSwarmRPI/hbase/hmaster/ -t lucasfs/hbase-hmaster:hbase-1.4.13 --no-cache
docker push lucasfs/hbase-hmaster:hbase-1.4.13

# Regionserver
docker build ~/HBaseSwarmRPI/hbase/hregionserver/ -t lucasfs/hbase-hregionserver:hbase-1.4.13 --no-cache
docker push lucasfs/hbase-hregionserver:hbase-1.4.13
