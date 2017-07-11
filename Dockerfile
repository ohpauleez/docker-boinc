FROM debian:stretch

LABEL                                                                      \
    Maintainer="https://github.com/apicht/docker-boinc"                                               \
    Description="A base container image for lightweight BOINC clients"     \
    Version="stretch_7.6.33"                                                \
    Boinc-Version="7.6.33"                                                 \
    Base-Version="debian:stretch"

# -- BOINC ---------------------------------------------------------------

ENV GOSU_VERSION 1.10
RUN set -x \
    && apt-get update && apt-get install -y --no-install-recommends boinc-client ca-certificates dirmngr gnupg wget && rm -rf /var/lib/apt/lists/* \
    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \
    && apt-get purge -y --auto-remove wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 31416

VOLUME ["/var/lib/boinc-client"]
WORKDIR /var/lib/boinc-client

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["boinc"]
