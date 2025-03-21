#!/bin/bash

set -ouex pipefail

# Enable getty on tty1 for image with no Display Manager
if [[ "$IMAGE_NAME" == "base" ]]; then
    systemctl enable getty@tty1
fi

# Remove dnf5 versionlocks
dnf5 versionlock clear

# Enable Update Timers
systemctl enable rpm-ostreed-automatic.timer
systemctl enable flatpak-system-update.timer
systemctl --global enable flatpak-user-update.timer

# Configure staged updates for rpm-ostree
cp /usr/share/ublue-os/update-services/etc/rpm-ostreed.conf /etc/rpm-ostreed.conf

# Fix cjk fonts
ln -s "/usr/share/fonts/google-noto-sans-cjk-fonts" "/usr/share/fonts/noto-cjk"

# Remove coprs
dnf5 -y copr remove ublue-os/staging
dnf5 -y copr remove ublue-os/packages
dnf5 -y copr remove kylegospo/oversteer

# Cleanup
# Remove tmp files and everything in dirs that make bootc unhappy
rm -rf /tmp/* || true
rm -rf /usr/etc
rm -rf /boot && mkdir /boot

shopt -s extglob
rm -rf /var/!(cache)
rm -rf /var/cache/!(libdnf5)

# Make sure /var/tmp is properly created
mkdir -p /var/tmp
chmod -R 1777 /var/tmp

# bootc/ostree checks
bootc container lint
ostree container commit
