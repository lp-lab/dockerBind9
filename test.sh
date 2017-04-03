#!/bin/bash
set -e

#ROOT_PASSWORD=${ROOT_PASSWORD:-password}
#CACHESIZE=${CACHESIZE:-size}
#CACHESIZE=$CACHESIZE
#DATALIMIT=${DATALIMIT:-limit}
#export UID=$(id -u dnscache)
#export GID=$(id -g dnscache)
#export ROOT=/etc/dnscache
#export IP=0.0.0.0
#export IPSEND=0.0.0.0
#export CACHESIZE=1000000
#DAEMON=/usr/bin/dnscache
#PIDFILE=/var/run/dnscache.pid

#set_root_passwd() {
#  echo "root:$ROOT_PASSWORD" | chpasswd
#}

update_cachesize() {
  echo "update cachesize"
}

update_datalimit() {
  echo "update datalimit"
}

# Set root password from the commandline
#set_root_passwd

# Synchronize acf root password from system's one
#/usr/bin/acfpasswd -s root

# Start mini_httpd to serve acf on https
#/usr/sbin/mini_httpd -C /etc/mini_httpd/mini_httpd.conf

if [[ -n $CACHESIZE ]]; then
	update_cachesize
fi

if [[ -n "$DATALIMIT" ]]; then
	update_datalimit
fi

#  echo "Starting dnscache..."
#  exec /etc/dnscache/run
#else
#  exec "$@"
#fi
