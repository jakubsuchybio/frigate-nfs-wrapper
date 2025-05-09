#!/usr/bin/env bash
set -euo pipefail

# ─── parameters coming from the stack ──────────────────────────
SERVER="${NFS_SERVER:?env NFS_SERVER is required}"          # required
EXPORT="${NFS_EXPORT:?env NFS_EXPORT is required}"          # required
TARGET="${NFS_MOUNT:-/media/frigate}"                       # optional override; defaults to /media/frigate
OPTS="${NFS_OPTS:-rw,soft,timeo=14,retrans=3}"              # extra NFS mount options

# ─── helper ───────────────────────────────────────────────────
log() { echo "$(date -u +'%Y-%m-%dT%H:%M:%SZ') $*"; }

mkdir -p "$TARGET"

log "[wait-for-nfs] checking if $SERVER exports are up…"
until showmount -e "$SERVER" &>/dev/null; do
  log "[wait-for-nfs] still waiting…"
  sleep 3
done

log "[wait-for-nfs] mounting $SERVER:$EXPORT → $TARGET ($OPTS)"
mount -t nfs -o "$OPTS" "$SERVER:$EXPORT" "$TARGET"

log "[wait-for-nfs] done, starting Frigate"
/usr/bin/dumb-init /entrypoint.sh "$@"
