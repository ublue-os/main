ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-silverblue}"
ARG BASE_IMAGE="quay.io/fedora-ostree-desktops/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-38}"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} AS nokmods

ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-38}"

COPY github-release-install.sh /tmp/github-release-install.sh
COPY nokmods-install.sh /tmp/nokmods-install.sh
COPY nokmods-post-install.sh /tmp/nokmods-post-install.sh
COPY nokmods-packages.json /tmp/nokmods-packages.json

COPY --from=ghcr.io/ublue-os/config:latest /rpms /tmp/rpms

RUN wget https://copr.fedorainfracloud.org/coprs/ublue-os/staging/repo/fedora-$(rpm -E %fedora)/ublue-os-staging-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_ublue-os_staging.repo && \
    wget https://copr.fedorainfracloud.org/coprs/kylegospo/oversteer/repo/fedora-$(rpm -E %fedora)/kylegospo-oversteer-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_kylegospo_oversteer.repo && \
    /tmp/nokmods-install.sh && \
    /tmp/nokmods-post-install.sh && \
    # temporary fix for https://github.com/containers/podman/issues/19930
    rpm-ostree override replace https://bodhi.fedoraproject.org/updates/FEDORA-2023-8d641964bc && \
    ## bootc 
    wget https://copr.fedorainfracloud.org/coprs/rhcontainerbot/bootc/repo/fedora-"${FEDORA_MAJOR_VERSION}"/bootc-"${FEDORA_MAJOR_VERSION}".repo -O /etc/yum.repos.d/bootc.repo && \
    rpm-ostree install bootc && \
    rm -f /etc/yum.repos.d/bootc.repo && \
    rm -f /etc/yum.repos.d/_copr_ublue-os_staging.repo && \
    rm -f /etc/yum.repos.d/_copr_kylegospo_oversteer.repo && \
    rm -rf /tmp/* /var/*

RUN ostree container commit && \
    mkdir -p /var/tmp && chmod -R 1777 /var/tmp

FROM nokmods AS main

ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-38}"

COPY main-install.sh /tmp/main-install.sh

COPY --from=ghcr.io/ublue-os/akmods:${FEDORA_MAJOR_VERSION} /rpms /tmp/akmods-rpms

COPY main-sys_files /

RUN /tmp/main-install.sh && \
    rm -rf /tmp/* /var/*

RUN ostree container commit && \
    mkdir -p /var/tmp && chmod -R 1777 /var/tmp
