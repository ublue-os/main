#!/usr/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"
KERNEL_SUFFIX=""
QUALIFIED_KERNEL="$(rpm -qa | grep -P 'kernel-(|'"$KERNEL_SUFFIX"'-)(\d+\.\d+\.\d+)' | sed -E 's/kernel-(|'"$KERNEL_SUFFIX"'-)//')"

RPMFUSION_MIRROR_RPMS="https://mirrors.rpmfusion.org"
if [ -n "${RPMFUSION_MIRROR}" ]; then
    RPMFUSION_MIRROR_RPMS=${RPMFUSION_MIRROR}
fi

curl -Lo /tmp/rpms/rpmfusion-free-release-"${RELEASE}".noarch.rpm "${RPMFUSION_MIRROR_RPMS}"/free/fedora/rpmfusion-free-release-"${RELEASE}".noarch.rpm
curl -Lo /tmp/rpms/rpmfusion-nonfree-release-"${RELEASE}".noarch.rpm "${RPMFUSION_MIRROR_RPMS}"/nonfree/fedora/rpmfusion-nonfree-release-"${RELEASE}".noarch.rpm

curl -Lo /etc/yum.repos.d/_copr_ublue-os_staging.repo https://copr.fedorainfracloud.org/coprs/ublue-os/staging/repo/fedora-"${RELEASE}"/ublue-os-staging-fedora-"${RELEASE}".repo
curl -Lo /etc/yum.repos.d/_copr_kylegospo_oversteer.repo https://copr.fedorainfracloud.org/coprs/kylegospo/oversteer/repo/fedora-"${RELEASE}"/kylegospo-oversteer-fedora-"${RELEASE}".repo

rpm-ostree install \
    /tmp/rpms/*.rpm \
    fedora-repos-archive

# Handle Kernel Skew with override replace
rpm-ostree cliwrap install-to-root /
if [[ "${KERNEL_VERSION}" == "${QUALIFIED_KERNEL}" ]]; then
    echo "Installing signed kernel from kernel-cache."
    cd /tmp/kernel-rpms
    rpm2cpio /tmp/kernel-rpms/kernel-core-*.rpm | cpio -idmv
    cp ./lib/modules/*/vmlinuz /usr/lib/modules/*/vmlinuz
    cd /
else
    echo "Install kernel version ${KERNEL_VERSION} from kernel-cache."
    rpm-ostree override replace \
        --experimental \
        /tmp/kernel-rpms/kernel-[0-9]*.rpm \
        /tmp/kernel-rpms/kernel-core-*.rpm \
        /tmp/kernel-rpms/kernel-modules-*.rpm
fi

if [[ "${FEDORA_MAJOR_VERSION}" -ge 39 ]]; then
    # note: this is done before single mirror hack to ensure this persists in image and is not reset
    echo "Enable rpmfusion-(non)free-updates-testing with low priority for Fedora ${FEDORA_MAJOR_VERSION}"
    sed -i '0,/enabled=0/{s/enabled=0/enabled=1\npriority=110/}' /etc/yum.repos.d/rpmfusion-*-updates-testing.repo
fi

# after F41 launches, bump to 42
if [[ "${FEDORA_MAJOR_VERSION}" -ge 41 ]]; then
    # note: this is done before single mirror hack to ensure this persists in image and is not reset
    # pre-release rpmfusion is in a different location
    sed -i "s%free/fedora/releases%free/fedora/development%" /etc/yum.repos.d/rpmfusion-*.repo
fi

if [ -n "${RPMFUSION_MIRROR}" ]; then
    # force use of single rpmfusion mirror
    echo "Using single rpmfusion mirror: ${RPMFUSION_MIRROR}"
    sed -i.bak "s%^metalink=%#metalink=%" /etc/yum.repos.d/rpmfusion-*.repo
    sed -i "s%^#baseurl=http://download1.rpmfusion.org%baseurl=${RPMFUSION_MIRROR}%" /etc/yum.repos.d/rpmfusion-*.repo
fi

# run common packages script
/tmp/packages.sh

## install packages direct from github
/tmp/github-release-install.sh sigstore/cosign x86_64

if [ -n "${RPMFUSION_MIRROR}" ]; then
    # reset forced use of single rpmfusion mirror
    echo "Revert from single rpmfusion mirror: ${RPMFUSION_MIRROR}"
    rename -v .repo.bak .repo /etc/yum.repos.d/rpmfusion-*repo.bak
fi
