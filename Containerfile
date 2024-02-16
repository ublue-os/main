ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-silverblue}"
ARG SOURCE_ORG="${SOURCE_ORG:-fedora-ostree-desktops}"
ARG BASE_IMAGE="quay.io/${SOURCE_ORG}/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-39}"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} as builder

ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-39}"

COPY build.sh \
     rpmmacros \ 
     /tmp/

COPY files/usr/etc/containers     /tmp/rose-os/signing/usr/etc/containers
COPY files/usr/share/rose-os      /tmp/rose-os/just/usr/share/rose-os
COPY files/usr/etc/profile.d      /tmp/rose-os/just/usr/etc/profile.d
COPY gpg/RPM-GPG-KEY-rose-os.pub  /tmp/rose-os/signing/usr/etc/pki/rpm-gpg/RPM-GPG-KEY-rose-os
COPY gpg/RPM-GPG-KEY-rose-os.priv /tmp/RPM-GPG-KEY-rose-os.priv
COPY cosign.pub                   /tmp/rose-os/signing/usr/etc/pki/containers/rose-os.pub

COPY rpmspec/*.spec /tmp/rose-os

RUN find /tmp/rose-os
RUN /tmp/build.sh

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION}

ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-39}"

COPY github-release-install.sh \
     install.sh \
     post-install.sh \
     packages.sh \
     packages.json \
     /tmp/

COPY --from=builder /tmp/rose-os/rpmbuild/RPMS/noarch /tmp/rpms
COPY --from=builder /var/cache/rpm-ostree /var/cache/rpm-ostree

RUN /tmp/install.sh && \
    /tmp/post-install.sh && \
    ostree container commit && \
    mkdir -p /var/tmp && chmod -R 1777 /var/tmp

