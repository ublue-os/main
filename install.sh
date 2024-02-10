#!/bin/sh

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

wget -P /tmp/rpms \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${RELEASE}.noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${RELEASE}.noarch.rpm

rpm-ostree install \
    /tmp/rpms/*.rpm \
    fedora-repos-archive

rpm --import /usr/etc/pki/rpm-gpg/RPM-GPG-KEY-rose-os

# after F40 launches, bump to 41
if [[ "${FEDORA_MAJOR_VERSION}" -ge 40 ]]; then
    sed -i 's%free/fedora/releases%free/fedora/development%' /etc/yum.repos.d/rpmfusion-*.repo
fi

# run common packages script
/tmp/packages.sh

## install packages direct from github
/tmp/github-release-install.sh sigstore/cosign x86_64

