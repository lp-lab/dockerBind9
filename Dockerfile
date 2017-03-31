FROM alpine

LABEL maintainer="github@lplab.net" \
      version="1.0.1-rc1" \
      description="Caching DNS resolver for a local LAN. Based on Alpine and dnscache from D. J. Bernstein"

ENV DATA_DIR=/data

RUN apk update && \
    apk add wget gnupg procps less ca-certificates acf-core acf-dnscache alpine-conf dnscache

RUN echo -n root:test123 | chpasswd

RUN /sbin/setup-acf

COPY dnsroots.global /etc/dnsroots.global

RUN dnscache-conf dnscache dnscache /etc/dnscache 0.0.0.0

RUN rm /etc/dnscache/root/ip/127.0.0.1 && \
    touch /etc/dnscache/root/ip/10.1.2 && \
    touch /etc/dnscache/root/ip/172.17.0
#    sed -i 's/IP=127.0.0.1/IP=0.0.0.0/g' /etc/conf.d/dnscache

RUN apk add --update tini

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 53/udp 53/tcp 443/tcp
VOLUME ["${DATA_DIR}"]
#ENTRYPOINT ["/sbin/entrypoint.sh"]
ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/sbin/entrypoint.sh"]
