ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-silverblue}"
ARG SOURCE_ORG="${SOURCE_ORG:-fedora-ostree-desktops}"
ARG BASE_IMAGE="quay.io/${SOURCE_ORG}/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-40}"
ARG KERNEL_VERSION="${KERNEL_VERSION:-6.9.7-200.fc40.x86_64}"
ARG IMAGE_REGISTRY=ghcr.io/ublue-os

FROM ${IMAGE_REGISTRY}/config:latest AS config
FROM ${IMAGE_REGISTRY}/akmods:main-${FEDORA_MAJOR_VERSION} AS akmods
FROM ${IMAGE_REGISTRY}/main-kernel:${KERNEL_VERSION} AS kernel

FROM scratch AS ctx
COPY / /

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION}

ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-40}"
ARG KERNEL_VERSION="${KERNEL_VERSION:-6.9.7-200.fc40.x86_64}"

COPY system_files/usr /usr

RUN --mount=type=cache,dst=/var/cache/rpm-ostree \
    --mount=type=bind,rw=true,from=ctx,src=/,dst=/ctx \
    --mount=type=bind,from=config,src=/rpms,dst=/tmp/rpms \
    --mount=type=bind,from=akmods,src=/rpms/ublue-os,dst=/tmp/akmods-rpms \
    --mount=type=bind,from=kernel,src=/tmp/rpms,dst=/tmp/kernel-rpms \
    mkdir -p /var/lib/alternatives && \
    chmod +x /ctx/build_scripts/*.sh && \
    for script in /ctx/build_scripts/*.sh; do $script; done && \
    ostree container commit && \
    mkdir -p /var/lib && mv /staged-alternatives /var/lib/alternatives && \
    mkdir -p /var/tmp && \
    chmod -R 1777 /var/tmp
