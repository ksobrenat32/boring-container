# Java container prepared to run a minecraft server

This container is prepared for running a full
 minecraft server, either if it existed before or
 if it is brand new. In case you have an existing
 minecraft world, it will try to run that.

There are two types of server, vanilla (mojang) and
 paper (community), the advantage of paper is that
 it can be used with plugins in order to be able to
 join using both java and bedrock clients!

To run this container use:

```sh
podman run -d \
    --name simple-mc \
    -p 25565:25565 `#Java port` \
    -p 19132:19132/udp `#Only needed for paper with bedrock plugins` \
    -p 19133:19133/udp `#Only needed for paper with bedrock plugins` \
    -e XMX=1024M `#Change the maximum ram for java` \
    -e XMS=1024M `#Change the mimimum ram for java` \
    -e SERVER_JAR=server.jar `#The name of the server executable` \
    -e SERVER_TYPE=VANILLA `#The type of server, VANILLA or PAPER` \
    -e SERVER_VERSION=LATEST `# The version (ie. 1.14.3)` \
    -v /path/to/server/data:/data:z \
    ghcr.io/ksobrenat32/simple-mc:latest
```

The container includes the mcrcon program, you can
use it to connect to your server through the terminal
after configuring the rcon service with:

```sh
podman exec -it containerName mcrcon -H 127.0.0.1 -P <port> -p <password> -t
```
