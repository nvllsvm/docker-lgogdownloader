#!/bin/sh
set -e

chown $PUID:$PGID \
    /cache \
    /config \
    /downloads

export XDG_CACHE_HOME=/dummy/cache
export XDG_CONFIG_HOME=/dummy/config

mkdir -p $XDG_CACHE_HOME $XDG_CONFIG_HOME

ln -s /config $XDG_CONFIG_HOME/lgogdownloader
ln -s /cache $XDG_CACHE_HOME/lgogdownloader

su-exec $PUID:$PGID /bin/sh -c "$@"
