#!/bin/sh

set -uoex pipefail

readonly SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
readonly FLATPAK_FILE="$(dirname "${SCRIPT_DIR}")/flatpak-apps.txt"
FLATPAK_APPS=$(<"${FLATPAK_FILE}")

readonly REMOTES=($(flatpak remotes --columns=name))

for REMOTE in "${REMOTES[@]}"; do
    if [[ "${REMOTE}" =~ fedora* ]]; then
	echo "Deleting flatpak remote: ${REMOTE}"
        flatpak remote-delete "${REMOTE}"
    fi
done

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak remotes --columns=name | grep -q "^flathub$" || flatpak remote-modify flathub --enable

flatpak install --noninteractive ${FLATPAK_APPS[@]}
