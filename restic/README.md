# restic container

A container that including restic backup utility.

With the enviroment variables:

```sh
podman run -d --replace \
    --name restic-backup \
    --security-opt label=disable \
    --network=host \
    -e RESTIC_REPOSITORY='sftp:user@host:/srv/restic-repo' \
    -e RESTIC_PASSWORD=''secure-password' \
    -v /data:/data `# dir to backup` \
    ghcr.io/ksobrenat32/restic:latest backup --host Host /data
```

With an enviroment file

```sh
podman run -d --replace \
    --name restic-backup \
    --security-opt label=disable \
    --network=host \
    --env-file /service/restic/env \
    -v /data:/data `# dir to backup` \
    ghcr.io/ksobrenat32/restic:latest backup --host Host /data
```

It needs to have selinux labels disabled so it does not changes your
 original labels.
It needs the host network in case the backup server is not public.
