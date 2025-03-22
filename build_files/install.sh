#!/usr/bin/bash

set -ouex pipefail

# Copy System Files onto root
rsync -rvK /ctx/sys_files/ /

# make root's home
mkdir -p /var/roothome

# Install dnf5 if not installed
if ! rpm -q dnf5 >/dev/null; then
    rpm-ostree install dnf5 dnf5-plugins
fi

# mitigate upstream packaging bug: https://bugzilla.redhat.com/show_bug.cgi?id=2332429
# swap the incorrectly installed OpenCL-ICD-Loader for ocl-icd, the expected package
dnf5 -y swap --repo='fedora' \
    OpenCL-ICD-Loader ocl-icd

# Add COPRs
dnf5 -y copr enable ublue-os/packages
dnf5 -y copr enable ublue-os/staging
dnf5 -y copr enable kylegospo/oversteer

# Install ublue-os pacakges, fedora archives,and zstd
dnf5 -y install \
    ublue-os-just \
    ublue-os-luks \
    ublue-os-signing \
    ublue-os-udev-rules \
    ublue-os-update-services \
    /tmp/akmods-rpms/*.rpm \
    fedora-repos-archive \
    zstd

# Replace podman provided policy.json with ublue-os one.
mv /usr/etc/containers/policy.json /etc/containers/policy.json

# Use Signed Kernel and Versionlock
for pkg in kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra; do
    rpm --erase $pkg --nodeps
done

KERNEL_VERSION="$(find /tmp/kernel-rpms/kernel-core-*.rpm -prune -printf "%f\n" | sed 's/kernel-core-//g' | sed 's/.rpm//g')"

KERNEL_RPMS=(
    "/tmp/kernel-rpms/kernel-${KERNEL_VERSION}.rpm"
    "/tmp/kernel-rpms/kernel-core-${KERNEL_VERSION}.rpm"
    "/tmp/kernel-rpms/kernel-modules-${KERNEL_VERSION}.rpm"
    "/tmp/kernel-rpms/kernel-modules-core-${KERNEL_VERSION}.rpm"
    "/tmp/kernel-rpms/kernel-modules-extra-${KERNEL_VERSION}.rpm"
    "/tmp/kernel-rpms/kernel-uki-virt-${KERNEL_VERSION}.rpm"
)
dnf5 -y install "${KERNEL_RPMS[@]}"
dnf5 versionlock add kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra

# Ensure Initramfs is generated (Likely unneeded)
/usr/bin/dracut --no-hostonly --kver "${KERNEL_VERSION}" --reproducible -v --add ostree -f "/lib/modules/${KERNEL_VERSION}/initramfs.img"
chmod 0600 "/lib/modules/${KERNEL_VERSION}/initramfs.img"

# use negativo17 for 3rd party packages with higher priority than default
curl -Lo /etc/yum.repos.d/negativo17-fedora-multimedia.repo https://negativo17.org/repos/fedora-multimedia.repo
sed -i '0,/enabled=1/{s/enabled=1/enabled=1\npriority=90/}' /etc/yum.repos.d/negativo17-fedora-multimedia.repo

# use override to replace mesa and others with less crippled versions
declare -A OVERRIDES
OVERRIDES+=(
    ["libva"]="libva"
)

if [[ "$FEDORA_MAJOR_VERSION" -lt "42" ]]; then
    OVERRIDES+=(
        ["libheif"]="libheif"
        ["libva-intel-media-driver"]="libva-intel-media-driver"
        ["mesa-dri-drivers"]="mesa-dri-drivers"
        ["mesa-filesystem"]="mesa-filesystem"
        ["mesa-libEGL"]="mesa-libEGL"
        ["mesa-libGL"]="mesa-libGL"
        ["mesa-libgbm"]="mesa-libgbm"
        ["mesa-libxatracker"]="mesa-libxatracker"
        ["mesa-va-drivers"]="mesa-va-drivers"
        ["mesa-vulkan-drivers"]="mesa-vulkan-drivers"
        ["fdk-aac-free"]="fdk-aac"
        ["ffmpeg-free"]="ffmpeg"
        ["libavcodec-free"]="libavcodec"
    )
fi

if [[ "$FEDORA_MAJOR_VERSION" -lt "41" ]]; then
    OVERRIDES+=(
        ["libvdpau"]="libvdpau"
        ["mesa-libglapi"]="mesa-libglapi"
    )
fi

for override in "${!OVERRIDES[@]}"; do
    dnf5 swap -y --repo='fedora-multimedia' \
        "$override" "${OVERRIDES[$override]}"
    dnf5 versionlock add "${OVERRIDES[$override]}"
done

# Disable DKMS support in gnome-software
if [[ "$FEDORA_MAJOR_VERSION" -ge "41" && "$IMAGE_NAME" == "silverblue" ]]; then
    dnf5 remove -y \
        gnome-software-rpm-ostree
    dnf5 swap -y \
        --repo=copr:copr.fedorainfracloud.org:ublue-os:staging \
        gnome-software gnome-software
    dnf5 versionlock add gnome-software
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
