ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-silverblue}"
ARG SOURCE_ORG="${SOURCE_ORG:-fedora-ostree-desktops}"
ARG BASE_IMAGE="quay.io/${SOURCE_ORG}/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-42}"
ARG KERNEL_VERSION="${KERNEL_VERSION:-6.14.0-0.rc3.29.fc42.x86_64}"
ARG IMAGE_REGISTRY=ghcr.io/ublue-os

FROM ${IMAGE_REGISTRY}/config:latest AS config
FROM ${IMAGE_REGISTRY}/akmods:main-${FEDORA_MAJOR_VERSION} AS akmods

FROM scratch AS ctx
COPY / /

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION}

ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-42}"
ARG KERNEL_VERSION="${KERNEL_VERSION:-6.14.0-0.rc3.29.fc42.x86_64}"

COPY sys_files/usr /usr

RUN --mount=type=cache,dst=/var/cache/rpm-ostree \
    --mount=type=bind,from=ctx,src=/,dst=/ctx \
    --mount=type=bind,from=config,src=/rpms,dst=/tmp/rpms \
    --mount=type=bind,from=akmods,src=/rpms/ublue-os,dst=/tmp/akmods-rpms \
    --mount=type=bind,from=akmods,src=/kernel-rpms,dst=/tmp/kernel-rpms \
    rm -f /usr/bin/chsh && \
    rm -f /usr/bin/lchsh && \
    /ctx/install.sh && \
    /ctx/post-install.sh && \
    /ctx/cleanup.sh && \
    ostree container commit && \
    mkdir -p /var/tmp && \
    chmod -R 1777 /var/tmp
