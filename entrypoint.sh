#!/bin/ash
set -e

ROOT_PASSWORD=${ROOT_PASSWORD:-password}
#export UID=$(id -u dnscache)
#export GID=$(id -g dnscache)
#export ROOT=/etc/dnscache
#export IP=0.0.0.0
#export IPSEND=0.0.0.0
#export CACHESIZE=1000000
#DAEMON=/usr/bin/dnscache
#PIDFILE=/var/run/dnscache.pid

set_root_passwd() {
  echo "root:$ROOT_PASSWORD" | chpasswd
}

# Set root password from the commandline
set_root_passwd

# Synchronize acf root password from system's one
/usr/bin/acfpasswd -s root

# Start mini_httpd to serve acf on https
/usr/sbin/mini_httpd -C /etc/mini_httpd/mini_httpd.conf

  echo "Starting dnscache..."
  exec /etc/dnscache/run
else
  exec "$@"
fi
