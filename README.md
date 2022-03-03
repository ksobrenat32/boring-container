# simple-container

Some simple, but useful containerfiles and guides,
 they may not be the most secure configurations
 so remember to read the containerfiles and
 modify it to suit your needs

## Simple java container prepared to run a minecraft server

### Building your own image

In order to build this image you should run

```sh
podman build -t simple-mc ./minecraft/.
```

### Usage

To run this container use:

```sh
podman run -d \
    --name simple-mc \
    -p 25565:25565 \
    -p 19132:19132/udp \
    -p 19133:19133/udp \
    -e XMX=1024M `# Change to maximum ram for java` \
    -e XMS=1024M `# Change to mimimum ram for java` \
    -e SERVER_JAR=server.jar `# The name of the server executable` \
    -v /path/to/server/data:/data:z \
    ghcr.io/ksobrenat32/simple-mc
```

