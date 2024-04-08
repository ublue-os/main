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

if [[ "${FEDORA_MAJOR_VERSION}" -ge 39 ]]; then
    # note: this is done before single mirror hack to ensure this persists in image and is not reset
    echo "Enable rpmfusion-(non)free-updates-testing with low priority for Fedora ${FEDORA_MAJOR_VERSION}"
    sed -i '0,/enabled=0/{s/enabled=0/enabled=1\npriority=110/}' /etc/yum.repos.d/rpmfusion-*-updates-testing.repo
fi

if [ -n "${RPMFUSION_MIRROR}" ]; then
    # force use of single rpmfusion mirror
    echo "Using single rpmfusion mirror: ${RPMFUSION_MIRROR}"
    sed -i.bak "s%^metalink=%#metalink=%" /etc/yum.repos.d/rpmfusion-*.repo
    sed -i "s%^#baseurl=http://download1.rpmfusion.org%baseurl=${RPMFUSION_MIRROR}%" /etc/yum.repos.d/rpmfusion-*.repo
fi

rpm-ostree install \
    kernel-devel-matched \
    /tmp/akmods-rpms/kmods/*xpadneo*.rpm \
    /tmp/akmods-rpms/kmods/*xone*.rpm \
    /tmp/akmods-rpms/kmods/*openrazer*.rpm \
    /tmp/akmods-rpms/kmods/*wl*.rpm

#    Disabled due to failure to build on 6.8
#    /tmp/akmods-rpms/kmods/*v4l2loopback*.rpm \

for REPO in $(rpm -ql ublue-os-akmods-addons|grep ^"/etc"|grep repo$); do
    echo "akmods: disable per defaults: ${REPO}"
    sed -i 's@enabled=1@enabled=0@g' ${REPO}
done

if [ -n "${RPMFUSION_MIRROR}" ]; then
    # reset forced use of single rpmfusion mirror
    echo "Revert from single rpmfusion mirror: ${RPMFUSION_MIRROR}"
    rename -v .repo.bak .repo /etc/yum.repos.d/rpmfusion-*repo.bak
fi
