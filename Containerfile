ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG BASE_IMAGE="quay.io/fedora-ostree-desktops/${IMAGE_NAME}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-37}"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} AS builder

ARG IMAGE_NAME="${IMAGE_NAME}"

ADD build.sh /tmp/build.sh
ADD packages.json /tmp/packages.json

COPY --from=ghcr.io/ublue-os/udev-rules:latest /ublue-os-udev-rules.noarch.rpm /tmp/ublue-os-udev-rules.noarch.rpm

RUN /tmp/build.sh
RUN rm -rf /tmp/*
RUN ostree container commit
RUN mkdir -p /var/tmp && chmod -R 1777 /var/tmp
