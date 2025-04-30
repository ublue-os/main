ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-silverblue}"
ARG SOURCE_ORG="${SOURCE_ORG:-fedora-ostree-desktops}"
ARG BASE_IMAGE="quay.io/${SOURCE_ORG}/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-42}"
ARG KERNEL_VERSION="${KERNEL_VERSION:-6.14.0-0.rc3.29.fc42.x86_64}"
ARG IMAGE_REGISTRY=ghcr.io/ublue-os
ARG AKMODS_DIGEST=""
ARG AKMODS_NVIDIA_DIGEST=""
ARG BASE_IMAGE_DIGEST=""

FROM scratch AS ctx
COPY /sys_files /sys_files
COPY /build_files /
COPY packages.json /

FROM ${IMAGE_REGISTRY}/akmods:main-${FEDORA_MAJOR_VERSION}${AKMODS_DIGEST:+@${AKMODS_DIGEST}} AS akmods

FROM ${IMAGE_REGISTRY}/akmods-nvidia-open:main-${FEDORA_MAJOR_VERSION}${AKMODS_NVIDIA_DIGEST:+@${AKMODS_NVIDIA_DIGEST}} AS akmods_nvidia

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION}${BASE_IMAGE_DIGEST:+@${BASE_IMAGE_DIGEST}}

ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-42}"
ARG KERNEL_VERSION="${KERNEL_VERSION:-6.14.0-0.rc3.29.fc42.x86_64}"
ARG BUILD_NVIDIA="${BUILD_NVIDIA:-N}"

RUN --mount=type=cache,dst=/var/cache/libdnf5 \
    --mount=type=bind,from=ctx,src=/,dst=/ctx \
    --mount=type=bind,from=akmods,src=/rpms/ublue-os,dst=/tmp/akmods-rpms \
    --mount=type=bind,from=akmods,src=/kernel-rpms,dst=/tmp/kernel-rpms \
    --mount=type=bind,from=akmods_nvidia,src=/rpms,dst=/tmp/akmods-nv-rpms \
    rm -f /usr/bin/chsh && \
    rm -f /usr/bin/lchsh && \
    /ctx/install.sh && \
    if [ "${BUILD_NVIDIA}" == "Y" ]; then \
        AKMODNV_PATH=/tmp/akmods-nv-rpms /ctx/nvidia-install.sh \
    ; fi && \
    /ctx/initramfs.sh && \
    /ctx/post-install.sh
