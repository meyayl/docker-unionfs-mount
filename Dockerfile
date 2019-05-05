FROM alpine:3.8

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Docker UnionFS Mount" \
      org.label-schema.description="Unionfs-mount based on alpine/s6-overlay" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/meyayl/docker-unionfs-mount" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"

ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2 TZ="Europe/Berlin" PUID=1000 PGID=1000 MOUNT_PATH=/unionfs

RUN \
  echo "**** install s6-overlay ****" && \
  apk add --no-cache curl && \
  curl -L -s https://github.com/just-containers/s6-overlay/releases/download/v1.21.8.0/s6-overlay-amd64.tar.gz | tar xvzf - -C / && \
  apk del --no-cache curl && \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
    ca-certificates \
    tzdata \
    unionfs-fuse && \
  echo "**** configure fuse ****" && \
  sed -ri 's/^#user_allow_other/user_allow_other/' /etc/fuse.conf && \
  echo "**** cleanup ****" && \
  rm -rf /tmp/*

COPY root/ /
VOLUME ["/read-only", "/read-write", "/unionfs"]
CMD ["/init"]
