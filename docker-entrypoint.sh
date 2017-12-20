#!/bin/bash
set -eo pipefail

# if command starts with an option, prepend boinc 
if [ "${1:0:1}" = '-' ]; then
    set -- boinc "$@"
fi

DATA_PATH=/var/lib/boinc-client

if [ "$1" = 'boinc' ]; then
    # work around for activity checking which sends errors to stderr if this directory doesn't exist
    mkdir -p /dev/input/mice
    # fix permissions
    chown -R boinc:boinc $DATA_PATH
    
    if [ ! "$(ls -A $DATA_PATH)" ]
    then
        # reconfigure boinc when the data directory is empty
        dpkg-reconfigure boinc-client
    else
        echo "Existing configuration was found at $DATA_PATH. Not touching."
    fi
    
    exec gosu boinc "$@"
else
    exec "$@"
fi

