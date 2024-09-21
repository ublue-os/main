ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-silverblue}"
ARG SOURCE_ORG="${SOURCE_ORG:-fedora-ostree-desktops}"
ARG BASE_IMAGE="quay.io/${SOURCE_ORG}/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-40}"


FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION}

COPY install.sh \
     post-install.sh \
     packages.sh \
     packages.json \
     /tmp/

ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-40}"

ARG BUILD_CACHE_NAME="${BUILD_IMAGE_NAME:-rose-os-rpms}"
ARG BUILD_CACHE_ORG="${BUILD_IMAGE_ORG:-joshua-stone}"
ARG BUILD_CACHE="ghcr.io/${BUILD_CACHE_ORG}/${BUILD_CACHE_NAME}:${FEDORA_MAJOR_VERSION}"

COPY --from=${BUILD_CACHE} /rpms /tmp/rpms

RUN /tmp/install.sh && \
    /tmp/post-install.sh && \
    ostree container commit && \
    mkdir -p /var/tmp && chmod -R 1777 /var/tmp

