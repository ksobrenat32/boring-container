# Simple java container prepared to run a minecraft server

---

## Building

In order to build this image you should run

```sh
podman build -t simple-mc:1.0 .
```

## Usage

To run this container use:

```sh
podman run -d \
    --name simple-mc \
    -p 25565:25565 \
    -p 19132:19132/udp \
    -p 19133:19132/udp \
    -e XMX=1024M `# Change to maximum ram for java` \
    -e XMS=1024M `# Change to mimimum ram for java` \
    -e SERVER_JAR=server.jar `# The name of the server executable` \
    -v /path/to/server/data:/data:z \
    simple-mc:1.0
```
