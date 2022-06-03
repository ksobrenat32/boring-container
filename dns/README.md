# Ultimate DNS

A container that contains unbound as recursive dns with
 [blocky](https://0xerr0r.github.io/blocky/) as an ad blocking
 dns proxy. It is based on a minimal fedora install for
 ease and security.

By default it uses my configuration for both unbound and blocky,
 in case you want to change it, just mount the ´/dns´ dir.
 To run this container:

```sh
podman run -d \
    --name udns \
    -p 53:53/tcp `# DNS port` \
    -p 53:53/udp `# DNS port` \
    -v /path/to/config:/dns:Z `# Optional custom configuration` \
    ghcr.io/ksobrenat32/udns:latest
```
