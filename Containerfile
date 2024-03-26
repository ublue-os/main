ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-silverblue}"
ARG SOURCE_ORG="${SOURCE_ORG:-fedora-ostree-desktops}"
ARG BASE_IMAGE="quay.io/${SOURCE_ORG}/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-39}"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} AS nokmods

ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-39}"
ARG RPMFUSION_MIRROR=""

COPY github-release-install.sh \
     install.sh \
     post-install.sh \
     packages.sh \
     packages.json \
        /tmp/

COPY --from=ghcr.io/ublue-os/config:latest /rpms /tmp/rpms
COPY --from=ghcr.io/ublue-os/akmods:main-${FEDORA_MAJOR_VERSION} /rpms/ublue-os /tmp/rpms
COPY sys_files/usr /usr

RUN /tmp/install.sh && \
    /tmp/post-install.sh && \
    rm -rf /tmp/* /var/* && \
    ostree container commit && \
    mkdir -p /var/tmp && chmod -R 1777 /var/tmp


# !!! WARNING - KMODS IN MAIN IMAGES ARE DEPRECATED !!!

# Only "legacy" (Fedora 38 and older) have custom kmods included in the "main" images.
FROM nokmods AS kmods

ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-38}"
ARG RPMFUSION_MIRROR=""

COPY kmods-install.sh /tmp/kmods-install.sh
COPY kmods-sys_files /tmp/kmods-files

COPY --from=ghcr.io/ublue-os/akmods:main-${FEDORA_MAJOR_VERSION} /rpms /tmp/akmods-rpms

# kmods-install.sh will error if running in Fedora 39 or newer.
RUN /tmp/kmods-install.sh && \
    rm -rf /tmp/* /var/* && \
    ostree container commit && \
    mkdir -p /var/tmp && chmod -R 1777 /var/tmp
