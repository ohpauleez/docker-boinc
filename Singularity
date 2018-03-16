Bootstrap: docker
From: debian:stretch

%labels
    Maintainer https://github.com/ohpauleez/docker-boinc
    Description "A base container image for lightweight BOINC clients"
    Version stretch_7.6.33
    Boinc-Version 7.6.33
    Base-Version debian:stretch

%files
    docker-entrypoint.sh

%environment
    GOSU_VERSION=1.10
    export GOSU_VERSION

%post
    export GOSU_VERSION=1.10

    # Now install the BOINC client and setup gosu
    set -x
    apt-get update && apt-get install -y --no-install-recommends procps boinc-client ca-certificates dirmngr gnupg wget && rm -rf /var/lib/apt/lists/*
    dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"
    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"
    wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"
    export GNUPGHOME="$(mktemp -d)"
    gpg --keyserver ipv4.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
    gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu
    rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc
    chmod +x /usr/local/bin/gosu
    gosu nobody true
    apt-get purge -y --auto-remove wget
    apt-get clean
    rm -rf /var/lib/apt/lists/*

    # Patch up the boinc user
    userdel -r boinc
    adduser --uid 9001 --disabled-password --gecos "" boinc

%runscript
    exec /docker-entrypoint.sh boinc "$@"

%startscript
    exec /docker-entrypoint.sh boinc "$@"

