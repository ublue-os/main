ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-silverblue}"
ARG BASE_IMAGE="quay.io/fedora-ostree-desktops/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-38}"


FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} AS main
ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-38}"

COPY github-release-install.sh /tmp/github-release-install.sh
COPY main-install.sh /tmp/main-install.sh
COPY main-post-install.sh /tmp/main-post-install.sh
COPY main-packages.json /tmp/main-packages.json

COPY --from=ghcr.io/ublue-os/config:latest /rpms /tmp/rpms
COPY --from=ghcr.io/ublue-os/akmods:${FEDORA_MAJOR_VERSION} /rpms /tmp/akmods-rpms

COPY system_files /

RUN /tmp/main-install.sh
RUN /tmp/main-post-install.sh

# temporary fix for https://github.com/containers/podman/issues/19930
RUN rpm-ostree override replace https://bodhi.fedoraproject.org/updates/FEDORA-2023-8d641964bc

RUN rm -rf /tmp/* /var/*
RUN ostree container commit
RUN mkdir -p /var/tmp && chmod -R 1777 /var/tmp


FROM main AS nvidia
ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-38}"
ARG NVIDIA_MAJOR_VERSION="${NVIDIA_MAJOR_VERSION:-535}"

COPY nvidia-install.sh /tmp/nvidia-install.sh
COPY nvidia-post-install.sh /tmp/nvidia-post-install.sh

COPY --from=ghcr.io/ublue-os/akmods-nvidia:${FEDORA_MAJOR_VERSION}-${NVIDIA_MAJOR_VERSION} /rpms /tmp/akmods-rpms

RUN /tmp/nvidia-install.sh
RUN /tmp/nvidia-post-install.sh
RUN rm -rf /tmp/* /var/*
RUN ostree container commit
RUN mkdir -p /var/tmp && chmod -R 1777 /tmp /var/tmp
