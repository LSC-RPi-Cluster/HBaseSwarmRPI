FROM lucasfs/hbase:base-x86

LABEL maintainer="github.com/lucas-fs"

ADD run.sh /run.sh
RUN chmod a+x /run.sh

EXPOSE 50070 9000

CMD ["/run.sh"]