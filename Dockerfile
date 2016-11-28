FROM alpine:edge
MAINTAINER Thomas Boerger <thomas@webhippie.de>

EXPOSE 22 3000

RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
  apk -U add \
    gosu@testing \
    shadow \
    ca-certificates \
    sqlite \
    bash \
    git \
    linux-pam \
    s6 \
    curl \
    openssh \
    tzdata && \
  rm -rf \
    /var/cache/apk/* && \
  groupadd \
    -r \
    -g 1000 \
    git && \
  useradd \
    -r -M \
    -p '*' \
    -d /data/git \
    -s /bin/bash \
    -u 1000 \
    -g git \
    git

ENV USER git
ENV GITEA_CUSTOM /data/gitea
ENV GODEBUG=netdns=go

VOLUME ["/data"]

ENTRYPOINT ["/usr/bin/entrypoint"]
CMD ["/bin/s6-svscan", "/etc/s6"]

COPY docker /

COPY public /app/gitea/public
COPY templates /app/gitea/templates
COPY bin/gitea /app/gitea/gitea
