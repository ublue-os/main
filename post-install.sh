#!/usr/bin/bash

set -ouex pipefail

if [[ "$IMAGE_NAME" == "base" ]]; then
    systemctl enable getty@tty1
fi

systemctl enable rpm-ostreed-automatic.timer
systemctl enable flatpak-system-update.timer

systemctl --global enable flatpak-user-update.timer

cp /usr/share/ublue-os/update-services/etc/rpm-ostreed.conf /etc/rpm-ostreed.conf

ln -s "/usr/share/fonts/google-noto-sans-cjk-fonts" "/usr/share/fonts/noto-cjk" 

rm -f /etc/yum.repos.d/_copr_ublue-os_staging.repo
rm -f /etc/yum.repos.d/_copr_kylegospo_oversteer.repo
