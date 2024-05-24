# Olivetin container

A container that includes [Olivetin](https://github.com/OliveTin/OliveTin)
 and wol (WakeOnLan) package so that you can use it to start
 machines on your LAN

```sh
podman run -d --replace \
    --name olivetin \
    --net=host `#For WakeOnLan` \
    -v /olivetin/config:/config:ro,Z `#Your olivetin configuration` \
    ghcr.io/ksobrenat32/olivetin:latest
```
