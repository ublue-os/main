#!/bin/sh

set -ouex pipefail

systemctl enable flatpak-system-update.timer

systemctl --global enable flatpak-user-update.timer

cp /usr/share/ublue-os/ublue-os-update-services/etc/rpm-ostreed.conf /etc/rpm-ostreed.conf
