FROM alpine
MAINTAINER meti@lplab.net

ENV BIND_USER=bind \
    DATA_DIR=/data

RUN apk update && \
    apk add wget gnupg procps less ca-certificates acf-core acf-dnscache alpine-conf

#COPY setup-acf.sh /sbin/setup-acf
#RUN chmod 755 /sbin/setup-acf

RUN /sbin/setup-acf

RUN rm /etc/dnscache/ip/127 && \
    touch /etc/dnscache/ip/10.1.2 && \
    sed -i 's/IP=127.0.0.1/IP=0.0.0.0/g' /etc/conf.d/dnscache

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 53/udp 53/tcp 10000/tcp
VOLUME ["${DATA_DIR}"]
ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["/usr/sbin/named"]
