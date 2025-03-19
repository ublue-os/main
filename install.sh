#!/usr/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"
KERNEL_SUFFIX=""
QUALIFIED_KERNEL="$(rpm -qa | grep -P 'kernel-(|'"$KERNEL_SUFFIX"'-)(\d+\.\d+\.\d+)' | sed -E 's/kernel-(|'"$KERNEL_SUFFIX"'-)//')"

# mitigate upstream packaging bug: https://bugzilla.redhat.com/show_bug.cgi?id=2332429
# swap the incorrectly installed OpenCL-ICD-Loader for ocl-icd, the expected package
rpm-ostree override replace \
    --from repo='fedora' \
    --experimental \
    --remove=OpenCL-ICD-Loader \
    ocl-icd ||
    true

curl -Lo /etc/yum.repos.d/_copr_ublue-os_staging.repo https://copr.fedorainfracloud.org/coprs/ublue-os/staging/repo/fedora-"${RELEASE}"/ublue-os-staging-fedora-"${RELEASE}".repo
curl -Lo /etc/yum.repos.d/_copr_kylegospo_oversteer.repo https://copr.fedorainfracloud.org/coprs/kylegospo/oversteer/repo/fedora-"${RELEASE}"/kylegospo-oversteer-fedora-"${RELEASE}".repo

rpm-ostree install \
    /tmp/rpms/*.rpm \
    /tmp/akmods-rpms/*.rpm \
    fedora-repos-archive

# Handle Kernel Skew with override replace
if [[ "${KERNEL_VERSION}" == "${QUALIFIED_KERNEL}" ]]; then
    echo "Installing signed kernel from kernel-cache."
    cd /tmp
    rpm2cpio /tmp/kernel-rpms/kernel-core-*.rpm | cpio -idmv
    cp ./lib/modules/*/vmlinuz /usr/lib/modules/*/vmlinuz
    cd /
else
    echo "Install kernel version ${KERNEL_VERSION} from kernel-cache."
    rpm-ostree override replace \
        --experimental \
        --install=zstd \
        /tmp/kernel-rpms/kernel-[0-9]*.rpm \
        /tmp/kernel-rpms/kernel-core-*.rpm \
        /tmp/kernel-rpms/kernel-modules-*.rpm
fi

# use negativo17 for 3rd party packages with higher priority than default
curl -Lo /etc/yum.repos.d/negativo17-fedora-multimedia.repo https://negativo17.org/repos/fedora-multimedia.repo
sed -i '0,/enabled=1/{s/enabled=1/enabled=1\npriority=90/}' /etc/yum.repos.d/negativo17-fedora-multimedia.repo

# use override to replace mesa and others with less crippled versions
OVERRIDES=(
    libva
    libva-intel-media-driver
    mesa-dri-drivers
    mesa-filesystem
    mesa-libEGL
    mesa-libGL
    mesa-libgbm
    mesa-libglapi
    mesa-libxatracker
    mesa-va-drivers
    mesa-vulkan-drivers
)

if [[ "$FEDORA_MAJOR_VERSION" -lt "42" ]]; then
    OVERRIDES+=(
        libheif
    )
fi

if [[ "$FEDORA_MAJOR_VERSION" -lt "41" ]]; then
    OVERRIDES+=(
        libvdpau
    )
fi

rpm-ostree override replace \
        --experimental \
        --from repo='fedora-multimedia' \
        "${OVERRIDES[@]}"

# Disable DKMS support in gnome-software
if [[ "$FEDORA_MAJOR_VERSION" -ge "41" && "$IMAGE_NAME" == "silverblue" ]]; then
    rpm-ostree override remove \
        gnome-software-rpm-ostree
    rpm-ostree override replace \
        --experimental \
        --from repo=copr:copr.fedorainfracloud.org:ublue-os:staging \
        gnome-software
fi

# run common packages script
/ctx/packages.sh

## install packages direct from github
/ctx/github-release-install.sh sigstore/cosign x86_64

# use CoreOS' generator for emergency/rescue boot
# see detail: https://github.com/ublue-os/main/issues/653
CSFG=/usr/lib/systemd/system-generators/coreos-sulogin-force-generator
curl -sSLo ${CSFG} https://raw.githubusercontent.com/coreos/fedora-coreos-config/refs/heads/stable/overlay.d/05core/usr/lib/systemd/system-generators/coreos-sulogin-force-generator
chmod +x ${CSFG}

if [[ "${KERNEL_VERSION}" == "${QUALIFIED_KERNEL}" ]]; then
    /ctx/initramfs.sh
fi
