#!/usr/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"
KERNEL_SUFFIX=""
QUALIFIED_KERNEL="$(rpm -qa | grep -P 'kernel-(|'"$KERNEL_SUFFIX"'-)(\d+\.\d+\.\d+)' | sed -E 's/kernel-(|'"$KERNEL_SUFFIX"'-)//')"

curl -Lo /etc/yum.repos.d/_copr_ublue-os_staging.repo https://copr.fedorainfracloud.org/coprs/ublue-os/staging/repo/fedora-"${RELEASE}"/ublue-os-staging-fedora-"${RELEASE}".repo
curl -Lo /etc/yum.repos.d/_copr_kylegospo_oversteer.repo https://copr.fedorainfracloud.org/coprs/kylegospo/oversteer/repo/fedora-"${RELEASE}"/kylegospo-oversteer-fedora-"${RELEASE}".repo

rpm-ostree install \
    /tmp/rpms/*.rpm \
    /tmp/akmods-rpms/*.rpm \
    fedora-repos-archive

# Handle Kernel Skew with override replace
rpm-ostree cliwrap install-to-root /
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

# Temporary fix for an upstream issue
# https://github.com/coreos/rpm-ostree/issues/5048
if [[ "${FEDORA_MAJOR_VERSION}" -eq 40 ]]; then
    rpm-ostree override replace \
    --experimental \
    --from repo=copr:copr.fedorainfracloud.org:ublue-os:staging \
        rpm-ostree \
        rpm-ostree-libs
fi

# use negativo17 for 3rd party packages with higher priority than default
curl -Lo /etc/yum.repos.d/negativo17-fedora-multimedia.repo https://negativo17.org/repos/fedora-multimedia.repo
sed -i '0,/enabled=0/{s/enabled=0/enabled=1\npriority=90/}' /etc/yum.repos.d/negativo17-fedora-multimedia.repo
cat /etc/yum.repos.d/negativo17-fedora-multimedia.repo

# use override to replace mesa drivers with the less crippled version
rpm-ostree override replace --experimental --from repo='fedora-multimedia' mesa-filesystem mesa-va-drivers

# run common packages script
/ctx/packages.sh

## install packages direct from github
/ctx/github-release-install.sh sigstore/cosign x86_64

if [[ "${KERNEL_VERSION}" == "${QUALIFIED_KERNEL}" ]]; then
    /ctx/initramfs.sh
fi
