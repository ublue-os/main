#!/bin/sh

set -ouex pipefail

ln -s "/usr/share/fonts/google-noto-sans-cjk-fonts" "/usr/share/fonts/noto-cjk"

sed -i "s@enabled=1@enabled=0@g" /etc/yum.repos.d/fedora-cisco-openh264.repo \
                                 /etc/yum.repos.d/rpmfusion-*.repo
