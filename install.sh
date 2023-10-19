#!/bin/sh

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

wget -P /tmp/rpms \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${RELEASE}.noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${RELEASE}.noarch.rpm

rpm-ostree install \
    /tmp/rpms/*.rpm \
    fedora-repos-archive

# force use of single rpmfusion mirror
sed -i.bak 's%^metalink=%#metalink=%' /etc/yum.repos.d/rpmfusion-*.repo
sed -i 's%^#baseurl=http://download1.rpmfusion.org%baseurl=http://mirrors.ocf.berkeley.edu/rpmfusion%' /etc/yum.repos.d/rpmfusion-*.repo
# after F39 launches, bump to 40
if [[ "${FEDORA_MAJOR_VERSION}" -ge 39 ]]; then
    sed -i 's%free/fedora/releases%free/fedora/development%' /etc/yum.repos.d/rpmfusion-*.repo
fi

if [[ "${FEDORA_MAJOR_VERSION}" -ge 39 ]]; then
    sed -i 's@enabled=0@enabled=1@g' /etc/yum.repos.d/fedora-updates-testing.repo
    rpm-ostree override \
    --experimental replace \
    --from repo=updates-testing \
        pipewire-libs \
        pipewire \
        pipewire-pulseaudio \
        pipewire-alsa \
        pipewire-jack-audio-connection-kit-libs \
        pipewire-jack-audio-connection-kit \
        pipewire-gstreamer \
        pipewire-utils \
        pipewire-jack-audio-connection-kit-libs.i686
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/fedora-updates-testing.repo
fi

# run common packages script
/tmp/packages.sh

## install packages direct from github
/tmp/github-release-install.sh sigstore/cosign x86_64

# reset forced use of single rpmfusion mirror
rename -v .repo.bak .repo /etc/yum.repos.d/rpmfusion-*repo.bak
