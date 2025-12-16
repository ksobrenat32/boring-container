# move-movies container

A container that includes ffmpeg and prename to delete metadata title and rename files to only alphanumeric characters. It preserves subtitle names and language information while removing the global title metadata.

## Features

- Removes global title metadata from video files
- Preserves subtitle names and language information
- Converts MKV files to MP4 format
- Normalizes filenames (removes spaces, accents, special characters)
- Supports both automatic watching mode and manual execution
- **Hardware acceleration support**: VAAPI for accelerated video encoding (Intel/AMD on Linux)
- Software fallback for systems without hardware acceleration

## Automatic Mode

Runs continuously, watching the origin directory for changes:

### Software Encoding (CPU-based)

```sh
podman run -d --replace \
    --name move-movies \
    --network=none \
    -e CUID=1000 \
    -v /mnt/downloads:/origin:z \
    -v /mnt/media:/destiny:z \
    ghcr.io/ksobrenat32/move-movies:latest
```

### Hardware Acceleration (VAAPI)

For Intel/AMD GPUs on Linux:

```sh
podman run -d --replace \
    --name move-movies \
    --network=none \
    --device /dev/dri \
    -e CUID=1000 \
    -e HWACCEL=vaapi \
    -v /mnt/downloads:/origin:z \
    -v /mnt/media:/destiny:z \
    ghcr.io/ksobrenat32/move-movies:latest
```

**Requirements for VAAPI:**
- Intel or AMD GPU with VAAPI support
- User must be in `video` and `render` groups: `sudo usermod -aG video,render $USER`
- Requires logout/login for group changes to take effect

## Manual Mode

Process specific files on demand without waiting:

### Software Encoding

```sh
podman run --rm \
    --network=none \
    -e CUID=1000 \
    -v /path/to/source:/origin:z \
    -v /path/to/destination:/destiny:z \
    --entrypoint /manual.sh \
    ghcr.io/ksobrenat32/move-movies:latest
```

### Hardware Acceleration (VAAPI)

```sh
podman run --rm \
    --network=none \
    --device /dev/dri \
    -e CUID=1000 \
    -e HWACCEL=vaapi \
    -v /path/to/source:/origin:z \
    -v /path/to/destination:/destiny:z \
    --entrypoint /manual.sh \
    ghcr.io/ksobrenat32/move-movies:latest
```

Or process a single file with hardware acceleration:

```sh
podman run --rm \
    --network=none \
    --device /dev/dri \
    -e CUID=1000 \
    -e HWACCEL=vaapi \
    -v /path/to/video.mkv:/origin/video.mkv:z \
    -v /path/to/output:/destiny:z \
    --entrypoint /manual.sh \
    ghcr.io/ksobrenat32/move-movies:latest
```

## Environment Variables

- `CUID` - User ID to own the resulting files (default: 1000)
- `ORIGIN` - Source directory path (default: /origin)
- `DESTINY` - Destination directory path (default: /destiny)
- `HWACCEL` - Hardware acceleration backend (default: `none`)
  - `none` - Use software encoding with libx264 (CPU-based)
  - `vaapi` - Use VAAPI (requires `--device /dev/dri` and user in `video`/`render` groups)

## Notes

- **Original files are deleted** after successful conversion in automatic mode
- Manual mode does not delete original files by default
- Subtitle formats are preserved (MP4) or converted (MKV to mov_text)
- Files with `.chunk*` extension are ignored (incomplete downloads)

## Hardware Acceleration Details

### VAAPI (Video Acceleration API)

VAAPI is the standard Linux interface for hardware video acceleration. It works with Intel and AMD GPUs.

**Supported Hardware:**
- Intel: Coffee Lake (8th gen) and newer processors
- AMD: GPUs with VAAPI support

**Performance:** VAAPI can be 3-5x faster than libx264 software encoding, with minimal quality loss.

**Setup:**

1. Ensure your user is in the required groups:
   ```sh
   sudo usermod -aG video,render $USER
   ```
   Then logout and login for changes to take effect.

2. If using SELinux, allow podman to access DRI devices:
   ```sh
   sudo setsebool -P container_use_dri_devices 1
   ```

3. Use `--device /dev/dri` when running the container to expose GPU devices.

4. Set `-e HWACCEL=vaapi` to enable VAAPI encoding.

**Troubleshooting:**

If VAAPI isn't working, verify:
- User is in `video` and `render` groups
- `--device /dev/dri` is passed to podman
- VAAPI driver is available on the host system (`vainfo` command)
- Fallback to software encoding by removing `HWACCEL=vaapi`
