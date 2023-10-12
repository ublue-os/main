#!/bin/sh

set -ouex pipefail

# !!! WARNING - KMODS IN MAIN IMAGES ARE DEPRECATED !!!

echo "DEPRECATED: Universal Blue will not include kmods in *-main images for Fedora 39 and newer."

# Only run if FEDORA_MAJOR_VERSION is less than 39
if [[ ${FEDORA_MAJOR_VERSION} -gt 38 ]]; then \
    exit 1
fi

# proceed with rest of script without further version checks


# copy kmods related files into image filesystem
cp -rf /tmp/kmods-files/* /


for REPO in $(rpm -ql ublue-os-akmods-addons|grep ^"/etc"|grep repo$); do
    echo "akmods: enable default entry: ${REPO}"
    sed -i '0,/enabled=0/{s/enabled=0/enabled=1/}' ${REPO}
done

# force use of single rpmfusion mirror
sed -i.bak 's%^metalink=%#metalink=%' /etc/yum.repos.d/rpmfusion-*.repo
sed -i 's%^#baseurl=http://download1.rpmfusion.org%baseurl=http://mirrors.ocf.berkeley.edu/rpmfusion%' /etc/yum.repos.d/rpmfusion-*.repo
# after F39 launches, bump to 40
if [[ "${FEDORA_MAJOR_VERSION}" -ge 39 ]]; then
    sed -i 's%free/fedora/releases%free/fedora/development%' /etc/yum.repos.d/rpmfusion-*.repo
fi

rpm-ostree install \
    kernel-devel-matched \
    /tmp/akmods-rpms/kmods/*xpadneo*.rpm \
    /tmp/akmods-rpms/kmods/*xpad-noone*.rpm \
    /tmp/akmods-rpms/kmods/*xone*.rpm \
    /tmp/akmods-rpms/kmods/*openrazer*.rpm \
    /tmp/akmods-rpms/kmods/*v4l2loopback*.rpm \
    /tmp/akmods-rpms/kmods/*wl*.rpm

for REPO in $(rpm -ql ublue-os-akmods-addons|grep ^"/etc"|grep repo$); do
    echo "akmods: disable per defaults: ${REPO}"
    sed -i 's@enabled=1@enabled=0@g' ${REPO}
done

# reset forced use of single rpmfusion mirror
rename -v .repo.bak .repo /etc/yum.repos.d/rpmfusion-*repo.bak
