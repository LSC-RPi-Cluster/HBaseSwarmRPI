#!/bin/bash

# truncate -s 0 regionservers
# for i in ${REGIONSERVERS[@]}
# do
#     echo ${i} >> regionservers
# done


# # format namenode 
# $HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR namenode -format $CLUSTER_NAME

# # start namenode
# $HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR namenode &

# # start datanode
# $HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR datanode &

SERVERST="127.0.0.1 portal.inf.ufsm.br"

function wait_for_boot()
{
    local server=$1
    local port=8000

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

for i in ${SERVERST[@]}
do
    wait_for_boot ${i}
done
