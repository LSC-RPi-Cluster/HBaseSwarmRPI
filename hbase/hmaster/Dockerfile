FROM lucasfs/hbase-base:hbase-2.2.5

COPY run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 16000 16010

CMD ["/run.sh"]