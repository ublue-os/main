#!/bin/sh

set -ouex pipefail

ln -s "/usr/share/fonts/google-noto-sans-cjk-fonts" "/usr/share/fonts/noto-cjk"

fc-cache --system-only --really-force --verbose

sed -i "s@enabled=1@enabled=0@g" /etc/yum.repos.d/*.repo
