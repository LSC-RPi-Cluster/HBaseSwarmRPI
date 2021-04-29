FROM lucasfs/hbase-armhf:base

LABEL maintainer="github.com/lucas-fs"

ADD run.sh /run.sh
RUN chmod a+x /run.sh

EXPOSE 9864

CMD ["/bin/bash", "-c","/entrypoint.sh && /run.sh"]