ARG IMAGE_NAME="${IMAGE_NAME:-rose-os-silverblue}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-rose-os-silverblue}"
ARG SOURCE_ORG="${SOURCE_ORG:-joshua-stone}"
ARG BASE_IMAGE="ghcr.io/${SOURCE_ORG}/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-40}"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} as builder

ARG IMAGE_NAME="${IMAGE_NAME:-rose-os-silverblue}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-40}"

ARG IMAGE_NAME="${IMAGE_NAME:-rose-os-silverblue}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-40}"

COPY packages.sh /tmp/packages.sh
COPY debug-packages.json /tmp/packages.json
COPY debug-repos.repo /etc/yum.repos.d/debug-repos.repo
RUN /tmp/packages.sh
RUN rm /etc/yum.repos.d/debug-repos.repo
RUN ostree container commit && \
    mkdir -p /var/tmp && chmod -R 1777 /var/tmp

