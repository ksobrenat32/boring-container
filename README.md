# boring-container

Simple but useful containerfiles and guides, boring because
 you set it up and forget. Remember to read the containerfiles
 and modify them to suit your needs.

## Building a local image

```sh
cd project
podman build . --tag $(basename "`pwd`")
```
