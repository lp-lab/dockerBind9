FROM debian:sid-slim

LABEL maintainer="meti@lplab.net" \
      version="0.9b" \
      description="Caching DNS resolver for a local LAN. Based on Debian Sid and Bind 9"

ENV BIND_USER=bind \
    DATA_DIR=/data

RUN rm -rf /etc/apt/apt.conf.d/docker-gzip-indexes \
 && apt-get update

RUN apt-get -y dist-upgrade

RUN apt-get install -y wget gnupg procps busybox less

RUN wget http://www.webmin.com/jcameron-key.asc -qO - | apt-key add - \
 && echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list \
 && apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y bind9 bind9-host

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y webmin

RUN apt-get install -y dnsutils net-tools

RUN rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 53/udp 53/tcp 10000/tcp
VOLUME ["${DATA_DIR}"]
ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["/usr/sbin/named"]
