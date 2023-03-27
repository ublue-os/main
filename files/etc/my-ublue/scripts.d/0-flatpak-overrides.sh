#!/bin/bash
/usr/bin/flatpak --user override --filesystem=xdg-config/gtk-3.0:ro
/usr/bin/flatpak --user override --filesystem=xdg-config/gtk-4.0:ro
/usr/bin/flatpak --user override --filesystem=xdg-data/themes:ro
/usr/bin/flatpak --user override --env=MOZ_ENABLE_WAYLAND=1 org.mozilla.firefox
/usr/bin/flatpak --user override --env=MOZ_DBUS_REMOTE=1
/usr/bin/flatpak --user override --env=FLATPAK_ENABLE_SDK_EXT=* com.visualstudio.code
mkdir -p "$HOME/.local/bin"
cp "/etc/my-ublue/podman-host" "$HOME/.local/bin/podman-host"
chmod +x "$HOME/.local/bin/podman-host"