#!/usr/bin/bash

set -eoux pipefail

source /etc/os-release

IMPORTANT_PACKAGES=(
    systemd
    pipewire
    wireplumber
)

case "${VARIANT_ID:-}" in
"silverblue")
    IMPORTANT_PACKAGES+=(
        gdm
        mutter
        gnome-session
        gnome-software
    )
    ;;
"kinoite")
    IMPORTANT_PACKAGES+=(
        kwin
        plasma-desktop
        sddm
        plasma-discover
    )
    ;;
"budgie-atomic")
    IMPORTANT_PACKAGES+=(
        lightdm
        magpie
        budgie-desktop
        plasma-discover
    )
    ;;
"sway-atomic")
    IMPORTANT_PACKAGES+=(
        sddm
        sway
    )
    ;;
*) ;;
esac

for package in "${IMPORTANT_PACKAGES[@]}"; do
    rpm -q "$package" >/dev/null || { echo "Missing package: $package... Exiting"; exit 1 ; }
done
