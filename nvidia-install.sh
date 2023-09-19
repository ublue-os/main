#!/bin/sh

set -ouex pipefail

if [[ "${FEDORA_MAJOR_VERSION}" -le 38 ]]; then
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/fedora-{cisco-openh264,modular,updates-modular}.repo
else
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/fedora-cisco-openh264.repo
fi

rpm-ostree install \
    /tmp/akmods-rpms/ublue-os/ublue-os-nvidia-addons-*.rpm

source /tmp/akmods-rpms/kmods/nvidia-vars.${NVIDIA_MAJOR_VERSION}

if [[ "${IMAGE_NAME}" == "kinoite" ]]; then
    VARIANT_PKGS="supergfxctl-plasmoid"
elif [[ "${IMAGE_NAME}" == "silverblue" ]]; then
    VARIANT_PKGS="gnome-shell-extension-supergfxctl-gex"
else
    VARIANT_PKGS=""
fi

rpm-ostree install \
    xorg-x11-drv-${NVIDIA_PACKAGE_NAME}-{,cuda-,devel-,kmodsrc-,power-}${NVIDIA_FULL_VERSION} \
    xorg-x11-drv-${NVIDIA_PACKAGE_NAME}-libs.i686 \
    nvidia-container-toolkit nvidia-vaapi-driver supergfxctl ${VARIANT_PKGS} \
    /tmp/akmods-rpms/kmods/kmod-${NVIDIA_PACKAGE_NAME}-${KERNEL_VERSION}-${NVIDIA_AKMOD_VERSION}.fc${RELEASE}.rpm
