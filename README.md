# Frigate NFS Wrapper

A Docker wrapper for [Frigate](https://frigate.video/) that adds NFS client capabilities, allowing Frigate to store recordings, snapshots, and other data on an NFS share.

## Overview

This project extends the official Frigate Docker image (`ghcr.io/blakeblackshear/frigate`) by adding NFS client support and a wrapper script that handles mounting an NFS share before starting Frigate. This is especially useful in containerized environments where you want to store Frigate's media on network storage.

## Usage

### Environment Variables

The container requires the following environment variables:

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `NFS_SERVER` | Yes | - | The hostname or IP address of your NFS server |
| `NFS_EXPORT` | Yes | - | The export path on the NFS server |
| `NFS_MOUNT` | No | `/media/frigate` | Target mount point inside the container |
| `NFS_OPTS` | No | `rw,soft,timeo=14,retrans=3` | NFS mount options |

## How It Works

1. The container checks if the NFS server is reachable
2. Once the NFS server is available, it mounts the specified export to the target directory
3. After successful mounting, it starts Frigate with all the arguments passed to the container

## Building Locally

To build the image locally:

```bash
docker build -t frigate-nfs-wrapper .
```

## License

This project extends the Frigate image, which is licensed under [MIT License](https://github.com/blakeblackshear/frigate/blob/master/LICENSE).

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
