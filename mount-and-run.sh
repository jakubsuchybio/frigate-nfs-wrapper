#!/usr/bin/env bash
set -euo pipefail

# ── parameters from docker‑compose.yml ─────────────────────────────
SERVER="${NFS_SERVER:?env NFS_SERVER required}"              # 192.168.32.31
EXPORT_ROOT="${NFS_EXPORT_ROOT:?env NFS_EXPORT_ROOT required}"  # /mnt/NAS-2/cameras
SUBDIR="${NFS_SUBDIR:-camera-storage}"                       # sub‑folder in export
TARGET="${NFS_MOUNT:-/media/frigate}"                        # where Frigate looks
OPTS="${NFS_OPTS:-rw,vers=4,soft,timeo=14,retrans=3}"        # NFS options

# ── helpers ───────────────────────────────────────────────────────
log(){ echo "$(date -u +'%Y-%m-%dT%H:%M:%SZ') $*"; }

ROOT_MNT=/mnt/nfsroot          # temp mount‑point for the export root
mkdir -p "$ROOT_MNT" "$TARGET"

# ── 1. wait for NAS then mount the export root ────────────────────
until mount -t nfs -o "$OPTS" "$SERVER:$EXPORT_ROOT" "$ROOT_MNT"; do
  log "[wait‑for‑nfs] mount root failed → retry in 5 s"
  sleep 5
done
log "[wait‑for‑nfs] mounted $EXPORT_ROOT → $ROOT_MNT"

# ── 2. make sure the sub‑folder exists, then bind‑mount it ────────
mkdir -p "$ROOT_MNT/$SUBDIR"
mount --bind "$ROOT_MNT/$SUBDIR" "$TARGET"
log "[wait‑for‑nfs] bind‑mounted subdir $SUBDIR → $TARGET"

# ─── 3. start Frigate ─────────────────────────────────────────────
exec /init
