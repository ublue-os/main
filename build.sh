#!/bin/sh

set -ouex pipefail

sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/fedora-cisco-openh264.repo

rpm-ostree install rpm-build

mkdir -p /tmp/rose-os/rpmbuild/SOURCES
tar cf /tmp/rose-os/rpmbuild/SOURCES/rose-os-signing.tar.gz -C /tmp rose-os/signing

rpmbuild -ba \
    --define '_topdir /tmp/rose-os/rpmbuild' \
    --define '%_tmppath %{_topdir}/tmp' \
    /tmp/rose-os/*.spec
