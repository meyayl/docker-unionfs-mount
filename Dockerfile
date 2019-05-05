FROM alpine:3.8

ARG BUILD_DATE
ARG VERSION
ENV VERSION=${VERSION:-1.0.0}
LABEL build_version="metyay version:- ${VERSION} Build-date:- ${BUILD_DATE}"

ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2
ENV TZ="Europe/Berlin" PUID=1000 PGID=1000 MOUNT_PATH=/unionfs

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
