Yet another [lgogdownloader](https://github.com/Sude-/lgogdownloader) Docker image.

# Volumes

- ``/cache`` - Cache directory
- ``/config`` - Configuration directory
- ``/downloads`` - Downloaded games directory

# Usage

```
$ docker run \
    --user $(id -u):$(id -g) \
    -v /home/user/.cache/lgogdownloader:/cache \
    -v /home/user/.config/lgogdownloader:/config \
    -v /backup/GOG:/downloads \
    ghcr.io/nvllsvm/lgogdownloader
```
