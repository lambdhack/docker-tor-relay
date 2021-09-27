FROM rust:bullseye AS tor-builder

LABEL maintainer="lambdhack@lambdhack.bzh"

WORKDIR /tor/
RUN DEBIAN_FRONTEND=noninteractive \
    apt update -q \
    && apt install -qy \
        --no-install-recommends \
        libevent-dev \
        libzstd-dev \
        openssl \
        zlib1g-dev \
        wget \
        gcc \
        libssl-dev \
        make \
        ca-certificates \
        python3 \
    && apt-get clean

ENV TOR_VERSION 0.4.6.7

RUN wget -q https://dist.torproject.org/tor-${TOR_VERSION}.tar.gz \
    && tar xzf tor-${TOR_VERSION}.tar.gz \
    && cd tor-${TOR_VERSION} \
    && ./configure \
        --enable-rust \
        --enable-cargo-online-mode \
        --enable-static-tor \
        --enable-static-openssl \
        --with-openssl-dir=/usr/lib/x86_64-linux-gnu/ \
        --enable-static-libevent \
        --with-libevent-dir=/usr/lib/x86_64-linux-gnu/ \
        --enable-static-zlib \
        --with-zlib-dir=/usr/lib/x86_64-linux-gnu/ \
        --disable-asciidoc \
        --disable-manpage \
        --disable-html-manual \
        --disable-system-torrc \
    && make -j $(($(nproc)-1)) \
    && cp src/app/tor /tor/tor \
    && cp src/config/geoip /tor/geoip \
    && cp src/config/geoip6 /tor/geoip6


FROM scratch

LABEL maintainer="lambdhack@lambdhack.bzh"

COPY --from=tor-builder /tor/tor /
COPY --from=tor-builder /tor/geoip /var/lib/tor/
COPY --from=tor-builder /tor/geoip6 /var/lib/tor/

ENTRYPOINT ["/tor", "-f", "/etc/torrc", "--DataDirectory", "/var/lib/tor/keys"]
