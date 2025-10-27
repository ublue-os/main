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

# mitigate upstream bug with rpm-ostree failing to layer packages in F43.
# can be removed when rpm-ostree's libdnf submodule is 8eadf440 or newer
if [[ "$(rpm -E %fedora)" -gt 41 ]]; then
    dnf5 -y copr enable ublue-os/staging
    dnf5 -y swap --repo='copr:copr.fedorainfracloud.org:ublue-os:staging' \
        rpm-ostree rpm-ostree
    dnf5 versionlock add rpm-ostree
    dnf5 -y copr disable ublue-os/staging
fi

# mitigate upstream packaging bug: https://bugzilla.redhat.com/show_bug.cgi?id=2332429
# swap the incorrectly installed OpenCL-ICD-Loader for ocl-icd, the expected package
dnf5 -y swap --repo='fedora' \
    OpenCL-ICD-Loader ocl-icd

# Add COPRs
dnf5 -y copr enable ublue-os/packages
dnf5 -y copr enable ublue-os/staging

# Install ublue-os packages, fedora archives,and zstd
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
)

# on F43, a new problem manifests where during kernel install, dracut errors and fails

# shim to bypass all of kernel-install... safe?
#mv /usr/sbin/kernel-install /usr/sbin/kernel-install.bak
#printf '%s\n' '#!/bin/sh' 'exit 0' > /usr/sbin/kernel-install
#mv -f /usr/sbin/kernel-install.bak /usr/sbin/kernel-install

# create a shims to bypass kernel install triggering dracut/rpm-ostree
# seems to be minimal impact, but allows progress on build
cd /usr/lib/kernel/install.d \
&& mv 05-rpmostree.install 05-rpmostree.install.bak \
&& mv 50-dracut.install 50-dracut.install.bak \
&& printf '%s\n' '#!/bin/sh' 'exit 0' > 05-rpmostree.install \
&& printf '%s\n' '#!/bin/sh' 'exit 0' > 50-dracut.install \
&& chmod +x  05-rpmostree.install 50-dracut.install

# instead of shims, could skip scriptlets: dnf install -y --setopt=tsflags=noscripts
# but skipping all scriptlets for kernel install may not be safe
dnf5 -y install "${KERNEL_RPMS[@]}"

# restore kernel install
mv -f 05-rpmostree.install.bak 05-rpmostree.install \
&& mv -f 50-dracut.install.bak 50-dracut.install
cd -

dnf5 versionlock add kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra

# use override to replace mesa and others with less crippled versions
OVERRIDES=(
    "intel-gmmlib"
    "intel-mediasdk"
    "intel-vpl-gpu-rt"
    "libheif"
    "libva"
    "libva-intel-media-driver"
    "mesa-dri-drivers"
    "mesa-filesystem"
    "mesa-libEGL"
    "mesa-libGL"
    "mesa-libgbm"
    "mesa-va-drivers"
    "mesa-vulkan-drivers"
)

dnf5 distro-sync --skip-unavailable -y --repo='fedora-multimedia' "${OVERRIDES[@]}"
dnf5 versionlock add "${OVERRIDES[@]}"

# Disable DKMS support in gnome-software
if [[ "$IMAGE_NAME" == "silverblue" ]]; then
    dnf5 remove -y \
        gnome-software-rpm-ostree
    dnf5 swap -y \
        --repo=copr:copr.fedorainfracloud.org:ublue-os:staging \
        gnome-software gnome-software
    dnf5 versionlock add gnome-software
fi

# Remove Fedora Flatpak and related packages
dnf5 remove -y \
    fedora-flathub-remote

# fedora-third-party has a trojan horse via plasma-discover requiring it in its spec, replace it with a dummy package.
dnf5 swap -y \
    fedora-third-party ublue-os-flatpak

# Add Flathub to the image for eventual application
mkdir -p /etc/flatpak/remotes.d/
curl --retry 3 -Lo /etc/flatpak/remotes.d/flathub.flatpakrepo https://dl.flathub.org/repo/flathub.flatpakrepo

# Fedora Flatpak service is a part of the flatpak package, ensure it's overridden by moving to replace it at the end of the build.
mv -f /usr/lib/systemd/system/flatpak-add-flathub-repos.service /usr/lib/systemd/system/flatpak-add-fedora-repos.service

# Prevent partial QT upgrades that may break SDDM/KWin
if [[ "$IMAGE_NAME" == "kinoite" ]]; then
    dnf5 versionlock add "qt6-*"
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
