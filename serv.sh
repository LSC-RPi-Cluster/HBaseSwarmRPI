#!/bin/bash

start_hmaster() {
	docker service create -dt \
	    --name hmaster \
		--network hbase \
		--hostname hmaster \
		--replicas 1 \
		--endpoint-mode dnsrr \
		--env CLUSTER_NAME=test \
		--env-file ./hbase.env \
		--publish published=16010,target=16010,mode=host \
		--publish published=9870,target=9870,mode=host \
		--entrypoint /bin/bash \
		lucasfs/hbase:latest
}

start_hregion1() {
	docker service create -dt \
	    --name hregion1 \
		--network hbase \
		--hostname hregion1 \
		--replicas 1 \
		--endpoint-mode dnsrr \
		--env-file ./hbase.env \
		--env HBASE_CONF_hbase_regionserver_hostname=hregion1 \
		--entrypoint /bin/bash \
		lucasfs/hbase:latest
}

start_hregion2() {
	docker service create -dt \
	    --name hregion2 \
		--network hbase \
		--hostname hregion2 \
		--replicas 1 \
		--endpoint-mode dnsrr \
		--env-file ./hbase.env \
		--env HBASE_CONF_hbase_regionserver_hostname=hregion2 \
		--entrypoint /bin/bash \
		lucasfs/hbase:latest
}

start_zoo() {
	docker stack deploy -c docker-compose-zoo.yml zookeeper
}

killall() {
	docker service rm $(docker service ls -q)
}

startall() {
	start_hmaster
	start_hregion1
	start_hregion2
}

"$@"