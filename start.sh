#!/bin/bash

docker run --name bind -d --restart=always --publish <ip>:53:53/tcp \
  --publish <ip>:53:53/udp \
  --publish <ip>:443:443/tcp \
  --volume /etc/localtime:/etc/localtime \
  --volume /srv/docker/bind:/data \
  --env ROOT_PASSWORD=<password> \
  --env CACHESIZE=<size> \
  --env DATALIMIT=<limit> \
  --env TIMEZONE="<your/timezone>" \
  lplab/dockerdns:latest
