#!/bin/sh

set -ouex pipefail

sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/fedora-cisco-openh264.repo

readonly RPM_BUILD_DIR="/tmp/rose-os/rpmbuild"

rpm-ostree install cabextract rpm-build rpm-sign

mkdir -p ${RPM_BUILD_DIR}/SOURCES /tmp/rpms

tar cf ${RPM_BUILD_DIR}/SOURCES/rose-os-signing.tar.gz -C /tmp rose-os/signing

cp /tmp/rose-os/signing/usr/etc/containers/policy.json \
   /tmp/rose-os/signing/usr/etc/containers/registries.d/rose-os.yaml \
   /tmp/rose-os/signing/usr/etc/pki/containers/rose-os.pub \
   /tmp/rose-os/signing/usr/etc/pki/rpm-gpg/RPM-GPG-KEY-rose-os \
   ${RPM_BUILD_DIR}/SOURCES

cp /tmp/rose-os/just/usr/etc/profile.d/rose-os-just.sh \
   /tmp/rose-os/just/usr/share/rose-os/flatpak-apps.txt \
   /tmp/rose-os/just/usr/share/rose-os/justfile \
   /tmp/rose-os/just/usr/share/rose-os/just/setup-flatpak-apps.sh \
   ${RPM_BUILD_DIR}/SOURCES

rpmbuild -ba \
    --define "_topdir ${RPM_BUILD_DIR}" \
    --load /tmp/rpmmacros \
    /tmp/rose-os/*.spec

find ${RPM_BUILD_DIR}/RPMS -name '*.rpm' -exec cp {} /tmp/rpms \;

/tmp/github-release-install.sh sigstore/cosign x86_64

if [[ -s /tmp/RPM-GPG-KEY-rose-os.priv ]]; then
    mkdir -p -m 700 /tmp/gnupg

    gpg --import \
        --homedir /tmp/gnupg \
        /tmp/RPM-GPG-KEY-rose-os.priv \
        /tmp/rose-os/signing/usr/etc/pki/rpm-gpg/RPM-GPG-KEY-rose-os

    rpm --import /tmp/rose-os/signing/usr/etc/pki/rpm-gpg/RPM-GPG-KEY-rose-os

    rpm --addsign \
	--load /tmp/rpmmacros \
        /tmp/rpms/*.rpm

    rpm -qi /tmp/rpms/*.rpm

    rpm --checksig \
        --load /tmp/rpmmacros \
        /tmp/rpms/*.rpm
else
    echo "No GPG key found. Skipping RPM signing."
fi
