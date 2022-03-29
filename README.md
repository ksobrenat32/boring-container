# simple-container

Some simple, but useful containerfiles and guides,
 they may not be the most secure configurations
 so remember to read the containerfiles and
 modify it to suit your needs

## Building your own image

```sh
podman build -t image-name ./project/.
```

## Simple java container prepared to run a minecraft server

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

```sh
podman exec -it simple-mc mcrcon -H 127.0.0.1 -P <port> -p <password> -t
```

## Simple Jekyll container for testing without installing full Jekyll

To run this container use:

```sh
podman run -d \
    --name Jekyll \
    --net=host \
    -v /path/to/page:/page:z \
    ghcr.io/ksobrenat32/jekyll
```
