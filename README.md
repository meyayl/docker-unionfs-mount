# unionfs-mount

Create a unionfs mount, merging the content of a read only source, and a read/write source folder.

It is based on alpine linux and leverages s6-overlay's SIGTERM handling to achieve a clean unionfs unmount when the container is stopped.

No more 'Transport endpoint is not connected"! :)

## Docker CLI Usage 
```sh
docker run -d \
 --name=unionfs-mount \
 --privileged \
 --env TZ=Europe/Berlin \
 --env PUID=1026 \
 --env PGID=100 \
 --volume $PWD/archive:/read-only:ro\
 --volume $PWD/current:/read-write:rw\
 --volume $PWD/unionfs:/unionfs:shared \
  meyay/unionfs-mount:1.0.0
```

## Docker Compose Usage 
```
version: '2.2'
services:
  unionfs :
    image:  meyay/unionfs-mount:1.0.0
    container_name: unionfs-mount
    privileged: true
    volumes:
    - $PWD/archive:/read-only:ro
    - $PWD/current:read-write:rw
    - $PWD/unionfs:/unionfs:shared
    environment:
      TZ: 'Europe/Berlin'
      PUID: '1026'
      PGID: '100'
    network_mode: 'none'
```

## Parameters
The environment parameters are split into two halves, separated by an equal, the left hand side representing the host and the right the container side.

| ENV| DEFAULT | DESCRIPTION |
| ------ | ------ | ------ |
| TZ | Europe/Berlin | The timezone to use for file operations and the log. |
| PUID | 1000 | The user id used to access files. |
| PGID | 1000 | The group id used to access files. |
| MOUNT_PATH  | /unionfs |  Optional: the container target path for the unionfs volume mapping. |

The volume parameters are split into two halves, separated by a colon, the left hand side representing the host and the right the container side.

| VOLUMES |  DESCRIPTION |
| ------ | ------ |
| /read-only  |  The read only mount point. |
| /read-write |  The read write mount point.|
| /unionfs  |  The unionfs mount. Needs to match the MOUNT_PATH. |

The examples form above assume that /read-only and /read-write exist localy in your filesystem.

If the host path for the /read-only bind is a mounted remote share, you might want to switch the propagation from `ro` to `shared`.

If the host path for the /read-write bind is a mounted remote share, you might want to switch the propagation from 'rw' to 'shared'

See for further details: https://docs.docker.com/storage/bind-mounts/#configure-bind-propagation

## Shell access
For shell access while the container is running, `docker exec -it unionfs-mount /bin/sh`

## Troubleshooting
The filesystem where the host path is located needs to be marked as shared. Otherwise the volume binding for /unionfs will result in an error and the container will not start. To mark a filesystem as shared, adopt following line to your needs:
```sh
mount --make-shared /
```
Please use the mount point of your volume, as the mount point "/" is just an example.

If you expose your unionfs folder as a remote share: 
- nfs: unionfs folder is empty
- cifs: unionfs folder can see and access the content

## Docker Swarm
Since the container needs to be run in privliged mode, this image can not be used on Docker Swarm. Sadly, Docker Swarm lacks support for priviliged containers. 
It is based on alpine linux. For shell access while the container is running, `docker exec -it unionfs-mount /bin/bash`.
