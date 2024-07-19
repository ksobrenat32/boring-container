# move-movies container

A container that including ffmpeg and prename so you
 can delete metadata name and rename it to only alphanumeric
 characters.

```sh
podman run -d --replace \
    --name move-movies \
    --network=none `# No network needed` \
    -e CUID=1000 `# User to own the file` \
    -v /mnt/downloads:/origin:z `# Where movies appear` \
    -v /mnt/media:/destiny:z `# Where you move them` \
    ghcr.io/ksobrenat32/move-movies:latest
```
