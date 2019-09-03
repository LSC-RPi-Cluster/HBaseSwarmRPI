#!/bin/bash
docker build -t hadoop-base ./base
docker build -t hadoop-namenode ./namenode
docker build -t hadoop-datanode ./datanode
docker build -t hadoop-resourcemanager ./resourcemanager
docker build -t hadoop-nodemanager ./nodemanager
docker build -t hadoop-historyserver ./historyserver