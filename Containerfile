ARG IMAGE_NAME=silverblue
ARG SOURCE_IMAGE=silverblue
ARG SOURCE_ORG=fedora-ostree-desktops
ARG BASE_IMAGE="quay.io/${SOURCE_ORG}/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION=40
ARG KERNEL_VERSION=6.9.7-200.fc40.x86_64

FROM ghcr.io/ublue-os/config:latest AS config
FROM ghcr.io/ublue-os/akmods:main-${FEDORA_MAJOR_VERSION} AS akmods
FROM ghcr.io/ublue-os/main-kernel:${KERNEL_VERSION} AS kernel

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION}

ARG IMAGE_NAME=silverblue
ARG FEDORA_MAJOR_VERSION=40
ARG RPMFUSION_MIRROR=
ARG KERNEL_VERSION=6.9.7-200.fc40.x86_64

COPY github-release-install.sh \
     install.sh \
     post-install.sh \
     packages.sh \
     packages.json \
        /tmp/

COPY --from=config /rpms /tmp/rpms
COPY --from=akmods /rpms/ublue-os /tmp/rpms
COPY --from=kernel /tmp/rpms /tmp/kernel-rpms
COPY sys_files/usr /usr

RUN mkdir -p /var/lib/alternatives && \
    /tmp/install.sh && \
    /tmp/post-install.sh && \
    mv /var/lib/alternatives /staged-alternatives && \
    rm -rf /tmp/* /var/* && \
    ostree container commit && \
    mkdir -p /var/lib && mv /staged-alternatives /var/lib/alternatives && \
    mkdir -p /tmp /var/tmp && \
    chmod -R 1777 /tmp /var/tmp
