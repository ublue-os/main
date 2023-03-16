# only run the ublue first boot for initial user after first install
if test "$(id -u)" -eq "1000" && test -d "$HOME"; then
    if test ! -e "$HOME"/.config/ublue/firstboot-done; then
        mkdir -p "$HOME"/.config/autostart
        cp -f /etc/skel.d/.config/autostart/ublue-firstboot.desktop "$HOME"/.config/autostart
    fi
fi
