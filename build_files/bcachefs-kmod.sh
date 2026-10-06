#!/usr/bin/env bash

set -xeu

# Enable copr
dnf -y copr enable "ngompa/bcachefs"

# Install kernel-devel and then module
KVER="$(ls /lib/modules)"
dnf -y install "kernel-devel-${KVER}"
dnf -y install dkms-bcachefs

# Move module elsewhere
MOD="$(find /lib/modules -type f -name 'bcachefs.ko*' -print -quit)"
cp -pa "${MOD}" /lib/modules/

# Remove surrounding builddeps
dnf -y remove dkms "kernel-devel-${KVER}"
mkdir -p "/lib/modules/${KVER}/extra/"

# Move module back
mv /lib/modules/bcachefs.ko* "/lib/modules/${KVER}/extra/"

# Register module for kernel
depmod -A -m "/lib/modules/${KVER}"

# Install userspace helper
dnf -y install bcachefs-tools

exit 0
