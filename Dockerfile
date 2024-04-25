FROM alpine:3.19
ARG LGOGDOWNLOADER_VERSION=3.12
ARG HTMLCXX_VERSION=0.87

# note: https://pkgs.alpinelinux.org/package/edge/testing/x86/htmlcxx
RUN \
    # Build deps
    apk add -t .dev help2man cmake make g++ curl-dev jsoncpp-dev tinyxml2-dev rhash-dev boost-dev && \
    # Run Deps
    apk add boost boost-program_options boost-iostreams boost-date_time jsoncpp rhash tinyxml2 curl shadow && \
    # Build and install htmlcxx
    curl -L --output htmlcxx.tar.gz https://sourceforge.net/projects/htmlcxx/files/v${HTMLCXX_VERSION}/htmlcxx-${HTMLCXX_VERSION}.tar.gz/download && \
    tar -xvf htmlcxx.tar.gz && \
    cd htmlcxx-${HTMLCXX_VERSION} && \
    export CXXFLAGS="$CXXFLAGS -std=c++14" && \
    ./configure --prefix=/usr && \
    make && \
    make install && \
    cd / && \
    # Build and install lgogdownloader
    curl -L --output lgogdownloader.tar.gz https://github.com/Sude-/lgogdownloader/releases/download/v${LGOGDOWNLOADER_VERSION}/lgogdownloader-${LGOGDOWNLOADER_VERSION}.tar.gz && \
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

CMD lgogdownloader --update-cache && \
    lgogdownloader --use-cache --download --save-serials && \
    lgogdownloader --use-cache --check-orphans --delete-orphans
