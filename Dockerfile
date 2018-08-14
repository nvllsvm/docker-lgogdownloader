FROM alpine:edge

RUN \
    # Build deps
    apk add help2man cmake make g++ curl-dev liboauth-dev jsoncpp-dev tinyxml2-dev rhash-dev boost-dev && \
    # Run Deps
    apk add boost boost-program_options boost-iostreams boost-date_time jsoncpp liboauth rhash tinyxml2 curl shadow su-exec && \
    # Build and install htmlcxx
    curl --output htmlcxx.tar.gz https://phoenixnap.dl.sourceforge.net/project/htmlcxx/htmlcxx/0.86/htmlcxx-0.86.tar.gz && \
    tar -xvf htmlcxx.tar.gz && \
    cd htmlcxx-0.86 && \
    ./configure --prefix=/usr && \
    make && \
    make install && \
    cd / && \
    # Build and install lgogdownloader
    curl --output lgogdownloader.tar.gz https://codeload.github.com/Sude-/lgogdownloader/tar.gz/v3.3 && \
    tar -xvf lgogdownloader.tar.gz && \
    cd lgogdownloader-3.3 && \
    cmake . -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release && \
    make && \
    make install && \
    cd / && \
    rm -rf /htmlcxx* /lgogdownloader* && \
    apk del help2man cmake make g++ curl-dev liboauth-dev jsoncpp-dev tinyxml2-dev rhash-dev boost-dev && \
    # Setup wrapper to set --directory to /downloads
    mv /usr/bin/lgogdownloader /usr/bin/lgogdownloader_original && \
    printf '#!/usr/bin/env sh\n/usr/bin/lgogdownloader_original --directory /downloads "$@"' > /usr/bin/lgogdownloader && \
    chmod +x /usr/bin/lgogdownloader && \
    rm -rf /var/cache/apk/*


VOLUME /cache /config /downloads

ENTRYPOINT \
    set -e && \
    chown $PUID:$PGID /cache /config /downloads && \
    export XDG_CACHE_HOME=/dummy/cache && \
    export XDG_CONFIG_HOME=/dummy/config && \
    mkdir -p $XDG_CACHE_HOME $XDG_CONFIG_HOME && \
    ln -s /config $XDG_CONFIG_HOME/lgogdownloader && \
    ln -s /cache $XDG_CACHE_HOME/lgogdownloader && \
    su-exec $PUID:$PGID /bin/sh -ec "$@"

CMD lgogdownloader --update-check && \
    lgogdownloader --download --save-serials && \
    rm -rf $(lgogdownloader --check-orphans | grep ^/download)
