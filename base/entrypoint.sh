#!/bin/bash

# Set some sensible defaults
export CORE_CONF_fs_defaultFS=${CORE_CONF_fs_defaultFS:-hdfs://`hostname -f`:8020}

function addProperty() {
  local path=$1
  local name=$2
  local value=$3

  local entry="<property><name>$name</name><value>${value}</value></property>"
  local escapedEntry=$(echo $entry | sed 's/\//\\\//g')
  sed -i "/<\/configuration>/ s/.*/${escapedEntry}\n&/" $path
}

function configure() {
    local path=$1
    local module=$2
    local envPrefix=$3

    local var
    local value
    
    echo "Configuring $module"
    for c in `printenv | perl -sne 'print "$1 " if m/^${envPrefix}_(.+?)=.*/' -- -envPrefix=$envPrefix`; do 
        name=`echo ${c} | perl -pe 's/___/-/g; s/__/@/g; s/_/./g; s/@/_/g;'`
        var="${envPrefix}_${c}"
        value=${!var}
        echo " - Setting $name=$value"
        # addProperty /etc/hadoop/$module-site.xml $name "$value"
        addProperty $path/$module-site.xml $name "$value"
    done
}

configure /etc/hadoop core CORE_CONF
configure /etc/hadoop hdfs HDFS_CONF
configure /etc/hbase hbase HBASE_CONF

if [ "$MULTIHOMED_NETWORK" = "1" ]; then
    echo "Configuring for multihomed network"

    # HDFS
    addProperty /etc/hadoop/hdfs-site.xml dfs.namenode.rpc-bind-host 0.0.0.0
    addProperty /etc/hadoop/hdfs-site.xml dfs.namenode.servicerpc-bind-host 0.0.0.0
    addProperty /etc/hadoop/hdfs-site.xml dfs.namenode.http-bind-host 0.0.0.0
    addProperty /etc/hadoop/hdfs-site.xml dfs.namenode.https-bind-host 0.0.0.0
    addProperty /etc/hadoop/hdfs-site.xml dfs.client.use.datanode.hostname true
    addProperty /etc/hadoop/hdfs-site.xml dfs.datanode.use.datanode.hostname true

fi

# Fill HBase regionservers file
truncate -s 0 /etc/hbase/regionservers
for i in ${REGIONSERVERS[@]}
do
    echo ${i} >> /etc/hbase/regionservers
done

# Fill HDFS workers file
truncate -s 0 /etc/hadoop/workers
for i in ${REGIONSERVERS[@]}
do
    echo ${i} >> /etc/hadoop/workers    
done

# Set JAVA_HOME in hbase-env.sh
echo "export JAVA_HOME=$JAVA_HOME" >> $HBASE_PREFIX/conf/hbase-env.sh

# Start SSH service
/usr/sbin/sshd

exec $@
