#!/usr/bin/env bash
set -euo pipefail

SERVER="${NFS_SERVER:?env NFS_SERVER required}"
EXPORT="${NFS_EXPORT:?env NFS_EXPORT required}"
TARGET="${NFS_MOUNT:-/media/frigate}"
OPTS="${NFS_OPTS:-rw,soft,timeo=14,retrans=3}"

log() { echo "$(date -u +'%Y-%m-%dT%H:%M:%SZ') $*"; }

mkdir -p "$TARGET"

until mount -t nfs -o "$OPTS" "$SERVER:$EXPORT" "$TARGET"; do
  log "[wait‑for‑nfs] mount failed → retry in 5 s"
  sleep 5
done

log "[wait‑for‑nfs] mounted, starting Frigate"
/usr/bin/dumb-init /entrypoint.sh "$@"
