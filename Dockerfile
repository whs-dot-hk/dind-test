FROM docker:dind

FROM debian:11

RUN apt-get update

RUN apt-get install -y lsb-release

RUN codename=$(lsb_release -cs);echo "deb http://deb.debian.org/debian $codename-backports main contrib non-free"|tee -a /etc/apt/sources.list && apt-get update

RUN apt-get install -y \
  -t bullseye-backports zfsutils-linux \
  btrfs-progs \
  e2fsprogs \
  iptables \
  openssl \
  pigz \
  uidmap \
  xfsprogs \
  xz-utils \
  ;

COPY --from=0 /usr/sbin/addgroup /usr/sbin/addgroup
COPY --from=0 /usr/sbin/adduser /usr/sbin/adduser

RUN apt-get install -y musl

RUN \
  addgroup -S dockremap; \
  adduser -S -G dockremap dockremap; \
  echo 'dockremap:165536:65536' >> /etc/subuid; \
  echo 'dockremap:165536:65536' >> /etc/subgid

COPY --from=0 /usr/local/bin/ /usr/local/bin/
