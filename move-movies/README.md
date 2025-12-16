# move-movies container

A container that includes ffmpeg and prename to delete metadata title and rename files to only alphanumeric characters. It preserves subtitle names and language information while removing the global title metadata.

## Features

- Removes global title metadata from video files
- Preserves subtitle names and language information
- Converts MKV files to MP4 format
- Normalizes filenames (removes spaces, accents, special characters)
- Supports both automatic watching mode and manual execution

## Automatic Mode

Runs continuously, watching the origin directory for changes:

```sh
podman run -d --replace \
    --name move-movies \
    --network=none `# No network needed` \
    -e CUID=1000 `# User to own the resulting file` \
    -v /mnt/downloads:/origin:z `# Where movies appear` \
    -v /mnt/media:/destiny:z `# Where you move them` \
    ghcr.io/ksobrenat32/move-movies:latest
```

## Manual Mode

Process specific files on demand without waiting:

```sh
podman run --rm \
    --name move-movies-manual \
    --network=none \
    -e CUID=1000 \
    -v /path/to/source:/origin:z \
    -v /path/to/destination:/destiny:z \
    --entrypoint /manual.sh \
    ghcr.io/ksobrenat32/move-movies:latest
```

Or process a single file:

```sh
podman run --rm \
    --network=none \
    -e CUID=1000 \
    -v /path/to/video.mkv:/origin/video.mkv:z \
    -v /path/to/output:/destiny:z \
    --entrypoint /manual.sh \
    ghcr.io/ksobrenat32/move-movies:latest
```

## Environment Variables

- `CUID` - User ID to own the resulting files (default: 1000)
- `ORIGIN` - Source directory path (default: /origin)
- `DESTINY` - Destination directory path (default: /destiny)

## Notes

- **Original files are deleted** after successful conversion in automatic mode
- Manual mode does not delete original files by default
- Subtitle formats are preserved (MP4) or converted (MKV to mov_text)
- Files with `.chunk*` extension are ignored (incomplete downloads)
