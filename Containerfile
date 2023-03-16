ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-silverblue}"
ARG BASE_IMAGE="quay.io/fedora-ostree-desktops/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-37}"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} AS builder

ARG IMAGE_NAME="${IMAGE_NAME}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION}"

ADD build.sh /tmp/build.sh
ADD post-install.sh /tmp/post-install.sh
ADD packages.json /tmp/packages.json

COPY --from=ghcr.io/ublue-os/config:latest /rpms /tmp/rpms
COPY luks-*-tpm2-autounlock /usr/bin
COPY ublue-firstboot /usr/bin

RUN /tmp/build.sh
RUN /tmp/post-install.sh

RUN   sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=30s/' /etc/systemd/user.conf
RUN   sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=30s/' /etc/systemd/system.conf
RUN   systemctl unmask dconf-update.service
RUN   systemctl enable dconf-update.service
RUN   systemctl enable tailscaled

RUN rm -rf /tmp/* /var/*
RUN ostree container commit
RUN mkdir -p /var/tmp && chmod -R 1777 /var/tmp


