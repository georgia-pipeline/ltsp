FROM georgiapipeline/ltsp-base

COPY --from=georgiapipeline/ltsp-image /opt/ltsp/images /opt/ltsp/images
COPY --from=georgiapipeline/ltsp-image /etc/nbd-server/conf.d /etc/nbd-server/conf.d
COPY --from=georgiapipeline/ltsp-image /var/lib/tftpboot /var/lib/tftpboot
