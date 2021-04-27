FROM lucasfs/hbase:base-x86

LABEL maintainer="github.com/lucas-fs"

ADD run.sh /run.sh
RUN chmod a+x /run.sh

EXPOSE 50075

CMD ["/run.sh"]