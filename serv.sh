#!/bin/bash

start_hmaster_stand() {
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
		lucasfs/hbase-armhf:hmaster
}


start_hregion1_stand() {
	docker service create -dt \
	    --name hregion1 \
		--network hbase \
		--hostname hregion1 \
		--replicas 1 \
		--endpoint-mode dnsrr \
		--env-file ./hbase.env \
		--env HBASE_CONF_hbase_regionserver_hostname=hregion1 \
		--entrypoint /bin/bash \
		lucasfs/hbase-armhf:hregion
}

start_hregion2_stand() {
	docker service create -dt \
	    --name hregion2 \
		--network hbase \
		--hostname hregion2 \
		--replicas 1 \
		--endpoint-mode dnsrr \
		--env-file ./hbase.env \
		--env HBASE_CONF_hbase_regionserver_hostname=hregion2 \
		--entrypoint /bin/bash \
		lucasfs/hbase-armhf:hregion
}

start_hmaster() {
	docker service create -d \
	    --name hmaster \
		--network hbase \
		--hostname hmaster \
		--replicas 1 \
		--endpoint-mode dnsrr \
		--env CLUSTER_NAME=test \
		--env-file ./hbase.env \
		--publish published=16010,target=16010,mode=host \
		--publish published=9870,target=9870,mode=host \
		lucasfs/hbase-armhf:hmaster
}

start_hregion1() {
	docker service create -d \
	    --name hregion1 \
		--network hbase \
		--hostname hregion1 \
		--replicas 1 \
		--endpoint-mode dnsrr \
		--env-file ./hbase.env \
		--env HBASE_CONF_hbase_regionserver_hostname=hregion1 \
		lucasfs/hbase-armhf:hregion
}

start_hregion2() {
	docker service create -d \
	    --name hregion2 \
		--network hbase \
		--hostname hregion2 \
		--replicas 1 \
		--endpoint-mode dnsrr \
		--env-file ./hbase.env \
		--env HBASE_CONF_hbase_regionserver_hostname=hregion2 \
		lucasfs/hbase-armhf:hregion
}

buildall() {
	docker build -t lucasfs/hbase-armhf:base ./base/ --no-cache && docker push lucasfs/hbase-armhf:base
	docker build -t lucasfs/hbase-armhf:hmaster ./hmaster/ --no-cache && docker push lucasfs/hbase-armhf:hmaster
	docker build -t lucasfs/hbase-armhf:hregion ./hregion/ --no-cache && docker push lucasfs/hbase-armhf:hregion
}

killall() {
	docker service rm $(docker service ls -q)
}

startall() {
	start_hmaster
	start_hregion1
	start_hregion2
}

startall_stand() {
	start_hmaster_stand
	start_hregion1_stand
	start_hregion2_stand
}

"$@"