FROM arm32v7/ubuntu

MAINTAINER Lucas Ferreira da Silva <lferreira@inf.ufsm.br>

RUN apt-get update

RUN apt-get install -y --no-install-recommends openjdk-8-jdk wget

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-armhf/

ENV HADOOP_VERSION=2.9.2

RUN wget -nv --show-progress -P /tmp/ http://ftp.unicamp.br/pub/apache/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz 

RUN tar -xvf /tmp/hadoop-$HADOOP_VERSION.tar.gz -C /opt/

RUN rm /tmp/hadoop-$HADOOP_VERSION.tar.gz 

RUN ln -s /opt/hadoop-$HADOOP_VERSION/etc/hadoop /etc/hadoop

RUN mkdir /opt/hadoop-$HADOOP_VERSION/logs

RUN mkdir /hadoop-data

ENV HADOOP_PREFIX=/opt/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=/etc/hadoop
ENV MULTIHOMED_NETWORK=1
ENV USER=root
ENV PATH $HADOOP_PREFIX/bin/:$PATH

ADD entrypoint.sh /entrypoint.sh

RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
