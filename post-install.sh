#!/bin/sh

set -ouex pipefail

systemctl enable rpm-ostreed-automatic.timer
systemctl enable flatpak-system-update.timer

systemctl --global enable flatpak-user-update.timer

cp /usr/share/ublue-os/update-services/etc/rpm-ostreed.conf /etc/rpm-ostreed.conf

ln -s "/usr/share/fonts/google-noto-sans-cjk-fonts" "/usr/share/fonts/noto-cjk"

# vim vi neovim symlink
ln -s /usr/bin/nvim /usr/bin/vim
ln -s /usr/bin/nvim /usr/bin/vi

# Add my own config stuff
# Can't be bothered to package my own rpm and include the stuff in the Containerfile atm

# NTS instead of NTP
# NTS is a more secured version of NTP
curl https://raw.githubusercontent.com/GrapheneOS/infrastructure/main/chrony.conf -o /etc/chrony.conf

#Randomize MAC address and disable static hostname. This could be used to track general network activity.
mkdir -p /etc/NetworkManager/conf.d
curl https://gitlab.com/Renner0E/rootfs_config/-/raw/main/etc/NetworkManager/conf.d/00-macrandomize.conf -o /etc/NetworkManager/conf.d/00-macrandomize.conf
