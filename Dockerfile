FROM alpine:edge

LABEL maintainer="github@lplab.net" \
      version="1.0.4" \
      description="Caching DNS resolver for a local LAN. Based on Alpine and dnscache from D. J. Bernstein"

ENV DATA_DIR=/data

# Add testing repository for daemontools retrieve
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

RUN apk update && \
    apk add wget gnupg procps less ca-certificates acf-core acf-unbound alpine-conf unbound bash

# Use a dummy root password, will be changed at container startup via CLI
#RUN echo -n root:test123 | chpasswd

RUN /sbin/setup-acf && \
    rm -f /etc/unbound/unbound.conf

# Add root servers IPs for dnscache retrieval
#COPY dnsroots.global /etc/dnsroots.global

COPY unbound.conf.git /etc/unbound/unbound.conf

# Remove default Alpine's dnscache configuration and use dnscache's own tool to configure it
#RUN rm -rf /etc/dnscache

#RUN dnscache-conf dnscache dnscache /etc/dnscache 0.0.0.0

# Change initial random seed from a static one to /dev/urandom and change relative paths on startup script to absolute ones
#RUN sed -i 's/exec\ <seed/exec\ \<\/dev\/urandom/g' /etc/dnscache/run && \
#    sed -i -- "s/exec envdir .\/env sh \-c '/exec envdir \/etc\/dnscache\/env sh \-c '/g" /etc/dnscache/run

RUN apk add --update tini

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 53/udp 53/tcp 443/tcp
VOLUME ["${DATA_DIR}"]
ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/sbin/entrypoint.sh"]
