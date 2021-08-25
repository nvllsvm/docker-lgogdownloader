FROM alpine
ARG LGOGDOWNLOADER_VERSION=3.8

RUN \
    # Build deps
    apk add -t .dev help2man cmake make g++ curl-dev jsoncpp-dev tinyxml2-dev rhash-dev boost-dev && \
    # Run Deps
    apk add boost boost-program_options boost-iostreams boost-date_time jsoncpp rhash tinyxml2 curl shadow && \
    # Build and install htmlcxx
    curl --output htmlcxx.tar.gz https://phoenixnap.dl.sourceforge.net/project/htmlcxx/htmlcxx/0.86/htmlcxx-0.86.tar.gz && \
    tar -xvf htmlcxx.tar.gz && \
    cd htmlcxx-0.86 && \
    ./configure --prefix=/usr && \
    make && \
    make install && \
    cd / && \
    # Build and install lgogdownloader
    curl --output lgogdownloader.tar.gz https://codeload.github.com/Sude-/lgogdownloader/tar.gz/v${LGOGDOWNLOADER_VERSION} && \
    tar -xvf lgogdownloader.tar.gz && \
    cd lgogdownloader-${LGOGDOWNLOADER_VERSION} && \
    cmake . -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release && \
    make && \
    make install && \
    cd / && \
    rm -rf /htmlcxx* /lgogdownloader* && \
    apk del .dev && \
    # Setup wrapper to set --directory to /downloads
    mv /usr/bin/lgogdownloader /usr/bin/lgogdownloader_original && \
    printf '#!/usr/bin/env sh\n/usr/bin/lgogdownloader_original --directory /downloads "$@"' > /usr/bin/lgogdownloader && \
    chmod +x /usr/bin/lgogdownloader && \
    rm -rf /var/cache/apk/* && \
    mkdir -m 777 /dummy

VOLUME /cache /config /downloads

ENTRYPOINT \
    set -e && \
    export XDG_CACHE_HOME=/dummy/cache && \
    export XDG_CONFIG_HOME=/dummy/config && \
    mkdir -p $XDG_CACHE_HOME $XDG_CONFIG_HOME && \
    ln -s /config $XDG_CONFIG_HOME/lgogdownloader && \
    ln -s /cache $XDG_CACHE_HOME/lgogdownloader && \
    exec /bin/sh -ec "$@"

CMD lgogdownloader --download --save-serials && \
    rm -rf $(lgogdownloader --check-orphans | grep ^/download)
