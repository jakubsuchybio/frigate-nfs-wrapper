FROM ghcr.io/blakeblackshear/frigate:0.15.1

RUN apk add --no-cache nfs-utils curl bash
COPY mount-and-run.sh /opt/mount-and-run.sh
RUN chmod +x /opt/mount-and-run.sh
ENTRYPOINT ["/opt/mount-and-run.sh"]
