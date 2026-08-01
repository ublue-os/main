#!/bin/bash

set -ouex pipefail

FRELEASE="$(rpm -E %fedora)"
: "${AKMODNV_PATH:=/tmp/akmods-rpms}"

# this is only to aid in human understanding of any issues in CI
find "${AKMODNV_PATH}"/

if ! command -v dnf5 >/dev/null; then
    echo "Requires dnf5... Exiting"
    exit 1
fi

# Check if any rpmfusion repos exist before trying to disable them
if dnf5 repolist --all | grep -q rpmfusion; then
    dnf5 config-manager setopt "rpmfusion*".enabled=0
fi

# Always try to disable cisco repo (or add similar check)
dnf5 config-manager setopt fedora-cisco-openh264.enabled=0

## nvidia install steps
dnf5 install -y "${AKMODNV_PATH}"/ublue-os/ublue-os-nvidia-addons-*.rpm

# Install MULTILIB packages from negativo17-multimedia prior to disabling repo

MULTILIB=(
    mesa-dri-drivers.i686
    mesa-filesystem.i686
    mesa-libEGL.i686
    mesa-libGL.i686
    mesa-libgbm.i686
    mesa-vulkan-drivers.i686
)

dnf5 install -y "${MULTILIB[@]}"

# F44 does not need this: https://src.fedoraproject.org/rpms/mesa/c/f747343d109d2b691d3abcf4649cd10ad42d6578?branch=f44
if [ "$FRELEASE" -lt 44 ]; then
    dnf5 install -y mesa-va-drivers.i686
fi

# enable repos provided by ublue-os-nvidia-addons (not enabling fedora-nvidia-lts)
dnf5 config-manager setopt fedora-nvidia.enabled=1 nvidia-container-toolkit.enabled=1

# Disable Multimedia
NEGATIVO17_MULT_PREV_ENABLED=N
if dnf5 repolist --enabled | grep -q "fedora-multimedia"; then
    NEGATIVO17_MULT_PREV_ENABLED=Y
    echo "disabling negativo17-fedora-multimedia to ensure negativo17-fedora-nvidia is used"
    dnf5 config-manager setopt fedora-multimedia.enabled=0
fi

# Enable staging for supergfxctl if repo file exists
if [[ -f /etc/yum.repos.d/_copr_ublue-os-staging.repo ]]; then
    sed -i 's@enabled=0@enabled=1@g' /etc/yum.repos.d/_copr_ublue-os-staging.repo
elif [[ -f /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:ublue-os:staging.repo ]]; then
    sed -i 's@enabled=0@enabled=1@g' /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:ublue-os:staging.repo
else
    # Otherwise, retrieve the repo file for staging
    curl -Lo /etc/yum.repos.d/_copr_ublue-os-staging.repo https://copr.fedorainfracloud.org/coprs/ublue-os/staging/repo/fedora-"${FRELEASE}"/ublue-os-staging-fedora-"${FRELEASE}".repo
fi

source "${AKMODNV_PATH}"/kmods/nvidia-vars

if [[ "${IMAGE_NAME}" == "kinoite" ]]; then
    VARIANT_PKGS="supergfxctl"
elif [[ "${IMAGE_NAME}" == "silverblue" ]]; then
    VARIANT_PKGS="gnome-shell-extension-supergfxctl-gex supergfxctl"
else
    VARIANT_PKGS=""
fi

# As of 610.43.02, negativo17 merged libnvidia-cfg/libnvidia-gpucomp/libnvidia-ml
# into nvidia-driver-common (which now Obsoletes/Provides the old package names),
# so the legacy standalone libnvidia-ml package no longer exists on newer drivers.
# Mirrors the version checks in ublue-os/akmods build_files/nvidia/download-nvidia-rpms.sh
NVIDIA_DRIVER_VERSION="${NVIDIA_AKMOD_VERSION%-*}"
NVIDIA_ML_PKGS=()
if dnf5 repoquery --qf '%{version}\n' nvidia-driver-common 2>/dev/null | grep -qxF "${NVIDIA_DRIVER_VERSION}"; then
    echo "Using nvidia-driver-common for NVIDIA ${NVIDIA_DRIVER_VERSION} (provides libnvidia-ml/libnvidia-gpucomp)"
    # nvidia-driver-cuda-libs.i686/nvidia-driver-libs.i686 already pull in a matching
    # nvidia-driver-common.i686 transitively; only request it explicitly when a
    # matching i686 build actually exists, in case it ever lags behind x86_64.
    if dnf5 repoquery --qf '%{version}\n' nvidia-driver-common.i686 2>/dev/null | grep -qxF "${NVIDIA_DRIVER_VERSION}"; then
        NVIDIA_ML_PKGS+=(nvidia-driver-common.i686)
    fi
else
    echo "Using legacy NVIDIA split library packages for NVIDIA ${NVIDIA_DRIVER_VERSION}"
    NVIDIA_ML_PKGS+=(libnvidia-ml.i686)
fi

dnf5 install -y \
    libnvidia-fbc \
    "${NVIDIA_ML_PKGS[@]}" \
    libva-nvidia-driver \
    nvidia-driver \
    nvidia-driver-cuda \
    nvidia-driver-cuda-libs.i686 \
    nvidia-driver-libs.i686 \
    nvidia-settings \
    nvidia-container-toolkit \
    ${VARIANT_PKGS} \
    "${AKMODNV_PATH}"/kmods/kmod-nvidia-"${KERNEL_VERSION}"-"${NVIDIA_AKMOD_VERSION}"."${DIST_ARCH}".rpm

# Ensure the version of the Nvidia module matches the driver
KMOD_VERSION="$(rpm -q --queryformat '%{VERSION}' kmod-nvidia)"
DRIVER_VERSION="$(rpm -q --queryformat '%{VERSION}' nvidia-driver)"
if [ "$KMOD_VERSION" != "$DRIVER_VERSION" ]; then
    echo "Error: kmod-nvidia version ($KMOD_VERSION) does not match nvidia-driver version ($DRIVER_VERSION)"
    exit 1
fi

## nvidia post-install steps
# disable repos provided by ublue-os-nvidia-addons
dnf5 config-manager setopt fedora-nvidia.enabled=0 fedora-nvidia-lts.enabled=0 nvidia-container-toolkit.enabled=0

# Disable staging
if [[ -f /etc/yum.repos.d/_copr_ublue-os-staging.repo ]]; then
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_ublue-os-staging.repo
elif [[ -f /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:ublue-os:staging.repo ]]; then
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:ublue-os:staging.repo
fi

systemctl enable ublue-nvctk-cdi.service
semodule --verbose --install /usr/share/selinux/packages/nvidia-container.pp

# we must force driver load to fix black screen on boot for nvidia desktops
sed -i 's@omit_drivers@force_drivers@g' /usr/lib/dracut/dracut.conf.d/99-nvidia.conf
# as we need forced load, also mustpre-load intel/amd iGPU else chromium web browsers fail to use hardware acceleration
sed -i 's@ nvidia @ i915 amdgpu nvidia @g' /usr/lib/dracut/dracut.conf.d/99-nvidia.conf

# re-enable negativo17-mutlimedia since we disabled it
if [[ "${NEGATIVO17_MULT_PREV_ENABLED}" = "Y" ]]; then
    dnf5 config-manager setopt fedora-multimedia.enabled=1
fi
