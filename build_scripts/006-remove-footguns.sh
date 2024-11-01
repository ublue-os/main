#!/usr/bin/bash

set -eoux pipefail

rm -f /usr/bin/chsh
rm -f /usr/bin/lchsh

# prevent gnome software from warning about dkms secureboot as these warnings
# would duplicate warnings provided by ublue already. we don't want confusion
rm -f /usr/libexec/gnome-software-dkms-helper
