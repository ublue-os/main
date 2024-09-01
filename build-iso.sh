#!/bin/sh

set -oeu pipefail

readonly RELEASE="41"
readonly RELEASE_TYPE="development"
readonly ARCH="$(uname -m)"
readonly ISO_DIR=ISO
readonly OUTFILE="installer.iso"

mkdir "${ISO_DIR}" || echo "Directory '$ISO_DIR/' might have extra files. Running 'rm -rf ${ISO_DIR}/' may be recommended"

cd $ISO_DIR

wget --continue \
     --no-parent \
     --no-directories \
     --recursive \
     --accept-regex "Fedora-Everything-(netinst-${ARCH}-${RELEASE}.*.iso|.*-CHECKSUM)$" \
     "https://dl.fedoraproject.org/pub/fedora/linux/${RELEASE_TYPE}/${RELEASE}/Everything/${ARCH}/iso/"


if [[ "$(ls -1q *-CHECKSUM | wc -l)" -ne 1 || "$(ls -1q *.iso | wc -l)" -ne 1 ]]; then
    echo "Too many checksums and/or ISOs detected. Exiting now."
    exit 1
fi

sha256sum --check Fedora-Everything*-CHECKSUM

cd -

sudo mkksiso --ks anaconda-ks.cfg \
	     --add cosign.pub \
	     --add files/ \
	     ${ISO_DIR}/Fedora-Everything-netinst*.iso \
	     "${OUTFILE}"
