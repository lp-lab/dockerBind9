#!/bin/bash
set -e

ROOT_PASSWORD=${ROOT_PASSWORD:-password}
DATE=`date +%Y%m%d`-`date +%H%M`

set_root_passwd() {
  echo "root:$ROOT_PASSWORD" | chpasswd
}

update_cachesize() {
  echo "$CACHESIZE" > /etc/dnscache/env/CACHESIZE
}

update_datalimit() {
  echo "$DATALIMIT" > /etc/dnscache/env/DATALIMIT
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

  echo "Starting dnscache..."
  exec /etc/dnscache/run > /data/log/dnscache-$DATE.log
else
  exec "$@"
fi
