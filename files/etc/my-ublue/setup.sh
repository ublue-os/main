#!/bin/bash

# FLatpak overrides
/usr/bin/flatpak --user override --filesystem=xdg-config/gtk-3.0:ro
/usr/bin/flatpak --user override --filesystem=xdg-config/gtk-4.0:ro
/usr/bin/flatpak --user override --filesystem=xdg-data/themes:ro
/usr/bin/flatpak --user override --env=MOZ_ENABLE_WAYLAND=1 org.mozilla.firefox
/usr/bin/flatpak --user override --env=MOZ_DBUS_REMOTE=1
/usr/bin/flatpak --user override --env=FLATPAK_ENABLE_SDK_EXT=* com.visualstudio.code
/usr/bin/flatpak --user override --filesystem=xdg-config/MangoHud:ro com.valvesoftware.Steam
/usr/bin/flatpak --user override --filesystem=~/.var/app/com.valvesoftware.Steam/data/Steam com.usebottles.bottles

# Podman-host
mkdir -p "$HOME/.local/bin"
cp "/etc/my-ublue/podman-host" "$HOME/.local/bin/podman-host"
chmod +x "$HOME/.local/bin/podman-host"

# Rpm-ostree
rpm-ostree initramfs --enable --arg=-I --arg=/lib/firmware/edid/aoc-edid.bin
rpm-ostree kargs --append-if-missing=amdgpu.ppfeaturemask=0xffffffff --append-if-missing=drm.edid_firmware=DP-3:edid/aoc-edid.bin --append-if-missing=video=DP-3:e

# Gamemode
sudo usermod -a -G gamemode "$USER"

# Ratbag
sudo systemctl enable --now ratbagd.service

# Mangohud
mkdir -p "$HOME/.config/MangoHud"
cp "/etc/my-ublue/MangoHud.conf" "$HOME/.config/MangoHud"