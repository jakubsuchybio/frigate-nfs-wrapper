# Use the same Frigate tag you want to run
FROM ghcr.io/blakeblackshear/frigate:0.15.1

# ---- install NFS client + helpers ---------------------------------
# Debian/Ubuntu base ⇒ apt; package name is nfs-common
RUN apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    nfs-common curl bash \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ---- copy the entry script and make it executable -----------------
COPY mount-and-run.sh /opt/mount-and-run.sh
RUN chmod +x /opt/mount-and-run.sh

ENTRYPOINT ["/opt/mount-and-run.sh"]
