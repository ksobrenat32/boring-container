# Uptime-kuma container

Container containing uptime-kuma nodejs application.

With the enviroment variables:

```sh
podman run -d --replace \
    --name uptime-kuma \
    --user uid:gid `#Optional: User to run uptime-kuma`\
    -p 3001:3001 \
    -v /path/to/server/data:/app/data:Z \
    ghcr.io/ksobrenat32/uptime-kuma:latest
```
