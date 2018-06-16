Yet another [lgogdownloader](https://github.com/Sude-/lgogdownloader) Docker image.

# Environment Variables

**Optional**
- ``PUID`` - User ID to run as (default 1000)
- ``PGID`` - Group ID to run as (default 1000)

# Volumes

- ``/cache`` - Cache directory
- ``/config`` - Configuration directory
- ``/downloads`` - Downloaded games directory

# Usage

```
$ docker run \
    -e PUID=1000 \
    -e PGID=1000 \
    -v /home/user/.cache/lgogdownloader:/cache \
    -v /home/user/.config/lgogdownloader:/config \
    -v /backup/GOG:/downloads \
    nvllsvm/lgogdownloader <ARGUMENTS>
```
