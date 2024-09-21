ARG IMAGE_NAME="${IMAGE_NAME:-fedora-minimal}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-fedora-minimal}"
ARG SOURCE_ORG="${SOURCE_ORG:-fedora}"
ARG BASE_IMAGE="quay.io/${SOURCE_ORG}/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-40}"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} as builder

ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-40}"

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

FROM scratch
COPY --from=builder /tmp/rpms /rpms
