#!/bin/ash
set -e

ROOT_PASSWORD=${ROOT_PASSWORD:-password}
export UID=$(id -u dnscache)
export GID=$(id -g dnscache)
export ROOT=/etc/dnscache
export IP=0.0.0.0
export IPSEND=0.0.0.0
export CACHESIZE=1000000
DAEMON=/usr/bin/dnscache
PIDFILE=/var/run/dnscache.pid

set_root_passwd() {
  echo "root:$ROOT_PASSWORD" | chpasswd
}

# default behaviour is to launch named
set_root_passwd

/usr/bin/acfpasswd -s root

/usr/sbin/mini_httpd -C /etc/mini_httpd/mini_httpd.conf

  echo "Starting dnscache..."
  exec /usr/bin/dnscache < /dev/urandom
else
  exec "$@"
fi
