#!/bin/bash

set -eux

CONFIG_FILE=/etc/docker-containers/docker-containers.conf

if [ ! -f $CONFIG_FILE ]
then
    echo "$CONFIG_FILE not found"
    exit 1
fi

. $CONFIG_FILE

# Make directories.
mkdir -p $LIGHTTPD_HOME
mkdir -p $MINIDLNA_HOME
mkdir -p $TRANSMISSION_RESUME
mkdir -p $TRANSMISSION_TORRENTS
mkdir -p $TRANSMISSION_DOWNLOADS
mkdir -p $TRANSMISSION_INCOMPLETE

# Pull the latest images.
docker pull johnelse/docker-lighttpd
docker pull johnelse/docker-minidlna
docker pull johnelse/docker-transmission

# Start the containers.
docker run -d --name lighttpd-container-$LIGHTTPD_PORT \
    -p $LIGHTTPD_ADDRESS:$LIGHTTPD_PORT:8080 \
    -v $LIGHTTPD_HOME:/var/www:ro \
    johnelse/docker-lighttpd

docker run -d --name minidlna-container \
    --net=host \
    -v $MINIDLNA_HOME:/media \
    -e MINIDLNA_MEDIA_DIR=/media \
    -e MINIDLNA_LISTENING_IP=$MINIDLNA_ADDRESS \
    -e MINIDLNA_PORT=$MINIDLNA_PORT \
    -e MINIDLNA_FRIENDLY_NAME=$MINIDLNA_FRIENDLY_NAME \
    -e MINIDLNA_INOTIFY=yes \
    johnelse/docker-minidlna

docker run -d --name transmission-container \
    -p 12345:12345 \
    -p 12345:12345/udp \
    -p 9091:9091 \
    -e ADMIN_PASS=$TRANSMISSION_PASSWORD \
    -v $TRANSMISSION_RESUME:/etc/transmission-daemon/resume \
    -v $TRANSMISSION_TORRENTS:/etc/transmission-daemon/torrents \
    -v $TRANSMISSION_DOWNLOADS:/var/lib/transmission-daemon/downloads \
    -v $TRANSMISSION_INCOMPLETE:/var/lib/transmission-daemon/incomplete \
    johnelse/docker-transmission
