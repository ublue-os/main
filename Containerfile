ARG IMAGE_NAME=silverblue
ARG SOURCE_IMAGE=silverblue
ARG SOURCE_ORG=fedora-ostree-desktops
ARG BASE_IMAGE="quay.io/${SOURCE_ORG}/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION=40
ARG KERNEL_VERSION=6.9.7-200.fc40.x86_64

# workaround for selinux denying direct access to mounted buildcontext
FROM scratch as context
COPY / /

FROM ghcr.io/ublue-os/config:latest as config
FROM ghcr.io/ublue-os/akmods:main-${FEDORA_MAJOR_VERSION} as akmods
FROM ghcr.io/ublue-os/main-kernel:${KERNEL_VERSION} AS kernel
FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION}

ARG IMAGE_NAME=silverblue
ARG FEDORA_MAJOR_VERSION=40
ARG RPMFUSION_MIRROR=
ARG KERNEL_VERSION=6.9.7-200.fc40.x86_64

COPY sys_files/usr /usr

RUN --mount=type=bind,from=context,source=/,target=/buildcontext \
    --mount=type=bind,from=config,source=/rpms,target=/buildcontext/rpms/config \
    --mount=type=bind,from=akmods,source=/rpms/ublue-os,target=/buildcontext/rpms/akmods \
    --mount=type=bind,from=kernel,source=/tmp/rpms,target=/buildcontext/kernel-rpms \
    --mount=type=tmpfs,target=/buildcontext/rpms/tmp \
    <<EOF
set -eux

mkdir -p /var/lib/alternatives
/buildcontext/install.sh
/buildcontext/post-install.sh
mv /var/lib/alternatives /staged-alternatives
rm -rf /tmp/* /var/*
ostree container commit
mkdir -p /var/lib
mv /staged-alternatives /var/lib/alternatives
mkdir -p /tmp /var/tmp
chmod -R 1777 /tmp /var/tmp
EOF
