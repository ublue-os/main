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

# use negativo17 for 3rd party packages with higher priority than default
if ! grep -q fedora-multimedia <(dnf5 repolist); then
    # Enable or Install Repofile
    dnf5 config-manager setopt fedora-multimedia.enabled=1 ||
        dnf5 config-manager addrepo --from-repofile="https://negativo17.org/repos/fedora-multimedia.repo"
fi
# Set higher priority
dnf5 config-manager setopt fedora-multimedia.priority=90

# Replace podman provided policy.json with ublue-os one.
mv /usr/etc/containers/policy.json /etc/containers/policy.json

# Use Signed Kernel and Versionlock
for pkg in kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra; do
    rpm --erase $pkg --nodeps
done

KERNEL_VERSION="$(find /tmp/kernel-rpms/kernel-core-*.rpm -prune -printf "%f\n" | sed 's/kernel-core-//g;s/.rpm//g')"

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

# use override to replace mesa and others with less crippled versions
OVERRIDES=(
    "libva"
)

if [[ "$FEDORA_MAJOR_VERSION" -lt "42" ]]; then
    OVERRIDES+=(
        "intel-gmmlib"
        "intel-vpl-gpu-rt"
        "intel-mediasdk"
        "libva-intel-media-driver"
        "mesa-dri-drivers"
        "mesa-filesystem"
        "mesa-libEGL"
        "mesa-libGL"
        "mesa-libgbm"
        "mesa-va-drivers"
        "mesa-vulkan-drivers"
    )
fi

if [[ "$FEDORA_MAJOR_VERSION" -lt "41" ]]; then
    OVERRIDES+=(
        "libvdpau"
        "mesa-libglapi"
    )
fi

dnf5 distro-sync -y --repo='fedora-multimedia' "${OVERRIDES[@]}"
dnf5 versionlock add "${OVERRIDES[@]}"

# Not available on F42 yet
# fdk-aac, ffmpeg, libavcodec, libheif
# and mesa-libxatracker in packages.json

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
