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
      echo "[$i/$max_try] check for ${server}:${port}..."
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

namedir=`echo $HDFS_CONF_dfs_namenode_name_dir | perl -pe 's#file://##'`
if [ ! -d $namedir ]; then
  echo "Namenode name directory not found: $namedir"
  exit 2
fi

if [ -z "$CLUSTER_NAME" ]; then
  echo "Cluster name not specified"
  exit 2
fi

echo "remove lost+found from $namedir"
rm -r $namedir/lost+found

if [ "`ls -A $namedir`" == "" ]; then
  echo "Formatting namenode name directory: $namedir"
  $HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR namenode -format $CLUSTER_NAME
fi

# Check if all Regionservers have already been initialized
for i in ${REGIONSERVERS[@]}
do
    wait_for_boot ${i} 
done

$HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR namenode &

echo "Starting HBase cluster..."

start-hbase.sh

tail -f $HBASE_PREFIX/logs/hbase-root-master-hmaster.log