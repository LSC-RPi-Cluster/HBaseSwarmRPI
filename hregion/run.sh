#!/bin/bash

function wait_for_boot()
{
    local server=$1
    local port=2122

    local retry_seconds=5
    local max_try=100
    let i=1

    nc -z $server $port
    result=$?

    until [ $result -eq 0 ]; do
      echo "[$i/$max_try] check for namenode in ${server}:${port}..."
      echo "[$i/$max_try] ${server}:${port} is not available yet"
      if (( $i == $max_try )); then
        echo "[$i/$max_try] ${server}:${port} is still not available; giving up after ${max_try} tries."
        exit 1
      fi
      
      echo "[$i/$max_try] try in ${retry_seconds}s once again ..."
      let "i++"
      sleep $retry_seconds

      nc -z $server $port
      result=$?
    done
    echo "[$i/$max_try] $server:${port} is available!"
}

wait_for_boot $HBASE_CONF_hbase_master_hostname

sleep $TIME_TO_WAIT

datadir=`echo $HDFS_CONF_dfs_datanode_data_dir | perl -pe 's#file://##'`
if [ ! -d $datadir ]; then
  echo "Datanode data directory not found: $datadir"
  exit 2
fi

$HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR datanode

echo "Hregion Done!"
