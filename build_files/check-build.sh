#!/usr/bin/bash

set -eoux pipefail

# This provides VARIANT_ID and VERSION_ID
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
        plasma-discover
    )
    
    # Check if Fedora version is 44 or newer
    if [[ "${VERSION_ID}" -ge 44 ]]; then
        IMPORTANT_PACKAGES+=("plasma-login-manager")
    else
        IMPORTANT_PACKAGES+=("sddm")
    fi
    ;;
*) ;;
esac

for package in "${IMPORTANT_PACKAGES[@]}"; do
    rpm -q "$package" >/dev/null || { echo "Missing package: $package... Exiting"; exit 1 ; }
done