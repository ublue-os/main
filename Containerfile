ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-silverblue}"
ARG SOURCE_ORG="${SOURCE_ORG:-fedora-ostree-desktops}"
ARG BASE_IMAGE="quay.io/${SOURCE_ORG}/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-45}"
ARG KERNEL_VERSION="${KERNEL_VERSION:-7.2.15-300.fc45.x86_64}"
ARG IMAGE_REGISTRY=ghcr.io/ublue-os
ARG AKMODS_DIGEST=""
ARG BASE_IMAGE_DIGEST=""

FROM scratch AS ctx
COPY /sys_files /sys_files
COPY /build_files /
COPY packages.json /

FROM ${IMAGE_REGISTRY}/akmods:main-${FEDORA_MAJOR_VERSION}${AKMODS_DIGEST:+@${AKMODS_DIGEST}} AS akmods

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION}${BASE_IMAGE_DIGEST:+@${BASE_IMAGE_DIGEST}}

ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-45}"
ARG KERNEL_VERSION="${KERNEL_VERSION:-7.2.15-300.fc45.x86_64}"

RUN --mount=type=bind,from=ctx,src=/,dst=/ctx \
    --mount=type=cache,target=/var/cache \
    --mount=type=cache,target=/var/log \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=bind,from=akmods,src=/rpms/ublue-os,dst=/tmp/akmods-rpms \
    --mount=type=bind,from=akmods,src=/kernel-rpms,dst=/tmp/kernel-rpms \
    rm -f /usr/bin/chsh && \
    rm -f /usr/bin/lchsh && \
    /ctx/install.sh && \
    /ctx/initramfs.sh && \
    /ctx/post-install.sh

# bootc lint
RUN ["bootc", "container", "lint"]
