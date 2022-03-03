# Simple Jekyll container for testing without installing full Jekyll

---

## Building

In order to build this image you should run

```sh
podman build -t jekyll:1.0 .
```

## Usage

To run this container use:

```sh
podman run -d \
    --name Jekyll \
    --net=host \
    -v /path/to/page:/page:z \
    jekyll:1.0
```
