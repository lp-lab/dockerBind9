#!/bin/bash
set -e

ROOT_PASSWORD=${ROOT_PASSWORD:-password}
DATE=$(date +%Y%m%d)-$(date +%H%M)

set_root_passwd() {
  echo "root:$ROOT_PASSWORD" | chpasswd
}

update_cachesize() {
  echo "$CACHESIZE" > /etc/dnscache/env/CACHESIZE
}

update_datalimit() {
  echo "$DATALIMIT" > /etc/dnscache/env/DATALIMIT
}

update_timezone() {
  echo "$TIMEZONE" > /etc/timezone
}

update_listener() {
  rm /etc/dnscache/root/ip/127.0.0.1 && \
  touch /etc/dnscache/root/ip/10 && \
  touch /etc/dnscache/root/ip/192.168 && \
  touch /etc/dnscache/root/ip/172.{16..31}
}

# Set root password from the commandline
set_root_passwd

# Synchronize acf root password from system's one
/usr/bin/acfpasswd -s root

# Start mini_httpd to serve acf on https
/usr/sbin/mini_httpd -C /etc/mini_httpd/mini_httpd.conf

if [[ -n $CACHESIZE ]]; then
  update_cachesize
fi

if [[ -n $DATALIMIT ]]; then
  update_datalimit
fi

if [[ -n $TIMEZONE ]]; then
  update_timezone
fi

update_listener

echo "Starting dnscache..."
exec /etc/dnscache/run > /data/log/dnscache-"$DATE".log
