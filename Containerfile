ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-silverblue}"
ARG BASE_IMAGE="quay.io/fedora-ostree-desktops/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-38}"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} AS main

ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-38}"

COPY github-release-install.sh \
     install.sh \
     post-install.sh \
     packages.sh \
     packages.json \
        /tmp/

COPY --from=ghcr.io/ublue-os/config:latest /rpms /tmp/rpms

RUN wget https://copr.fedorainfracloud.org/coprs/ublue-os/staging/repo/fedora-$(rpm -E %fedora)/ublue-os-staging-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_ublue-os_staging.repo && \
    wget https://copr.fedorainfracloud.org/coprs/kylegospo/oversteer/repo/fedora-$(rpm -E %fedora)/kylegospo-oversteer-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_kylegospo_oversteer.repo && \
    /tmp/install.sh && \
    /tmp/post-install.sh && \
    ## bootc 
    wget https://copr.fedorainfracloud.org/coprs/rhcontainerbot/bootc/repo/fedora-"${FEDORA_MAJOR_VERSION}"/bootc-"${FEDORA_MAJOR_VERSION}".repo -O /etc/yum.repos.d/bootc.repo && \
    rpm-ostree install bootc && \
    rm -f /etc/yum.repos.d/bootc.repo && \
    rm -f /etc/yum.repos.d/_copr_ublue-os_staging.repo && \
    rm -f /etc/yum.repos.d/_copr_kylegospo_oversteer.repo && \
    rm -rf /tmp/* /var/* && \
    ostree container commit && \
    mkdir -p /var/tmp && chmod -R 1777 /var/tmp

FROM main AS legacy

ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-38}"

COPY legacy-install.sh /tmp/legacy-install.sh
COPY legacy-sys_files /tmp/legacy

COPY --from=ghcr.io/ublue-os/akmods:main-${FEDORA_MAJOR_VERSION} /rpms /tmp/akmods-rpms

# Only "legacy (Fedora 38 and older) get kmods in Universal Blue "main"
# legacy-install.sh will error if running in Fedora 39 or newer.
RUN /tmp/legacy-install.sh && \
    rm -rf /tmp/* /var/* && \
    ostree container commit && \
    mkdir -p /var/tmp && chmod -R 1777 /var/tmp
