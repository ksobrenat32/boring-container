# move_movies container

A container that including ffmpeg and prename so you
 can delete metadata name and rename it to only alphanumeric
 characters.

```sh
podman run -d --replace \
    --name move_movies \
    --network=none `# No network needed so reduce the attack surface` \
    -v /mnt/downloads:/origin:z `# Where movies appear` \
    -v /mnt/media:/destiny:z `# Where you move them` \
    ghcr.io/ksobrenat32/move_movies:latest
```
