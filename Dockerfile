FROM debian:jessie

MAINTAINER Radosław Niestrój <niestrojradoslaw@gmail.com>

COPY src/docker-install.sh /tmp/docker-install.sh
RUN /tmp/docker-install.sh \
 && rm -rvf /tmp/*

COPY src/*.py src/track* src/*.sh  /
COPY src/reload                    /usr/bin/reload
COPY src/default.vcl               /etc/varnish/default.vcl

EXPOSE 6081 6085

RUN apt-get clean && apt-get update && apt-get install -y locales
RUN update-locale --locale-file FILE

HEALTHCHECK --interval=1m --timeout=3s \
  CMD ["/docker-healthcheck.sh"]

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["varnish"]
