#!/bin/bash

set -eux

CONFIG_FILE=/usr/local/etc/docker-containers/docker-containers.conf

if [ ! -f $CONFIG_FILE ]
then
    echo "$CONFIG_FILE not found"
    exit 1
fi

. $CONFIG_FILE

docker exec transmission-container \
    transmission-remote --auth transmission:$TRANSMISSION_PASSWORD -t all --stop

CONTAINERS="lighttpd-container-$LIGHTTPD_PORT minidlna-container transmission-container"

docker stop $CONTAINERS || true
docker rm $CONTAINERS || true
