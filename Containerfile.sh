#!/bin/bash

set -ouex pipefail

done_building() {
  buildah commit $1 $IMAGE_NAME
  for tag in $IMAGE_TAGS
  do  
    buildah push $IMAGE_NAME docker-daemon:$IMAGE_NAME:$tag
  done
  exit 0
}


IMAGE_NAME="${IMAGE_NAME:-silverblue}"
SOURCE_IMAGE="${SOURCE_IMAGE:-silverblue}"
SOURCE_ORG="${SOURCE_ORG:-fedora-ostree-desktops}"
BASE_IMAGE="quay.io/${SOURCE_ORG}/${SOURCE_IMAGE}"
FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-39}"

container_nokmods=$(buildah from ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION})

IMAGE_NAME="${IMAGE_NAME:-silverblue}"
FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-39}"
RPMFUSION_MIRROR=""

buildah config \
    --env IMAGE_NAME=${IMAGE_NAME} \
    --env SOURCE_IMAGE=${SOURCE_IMAGE} \
    --env SOURCE_ORG=${SOURCE_ORG} \
    --env BASE_IMAGE=${BASE_IMAGE} \
    --env FEDORA_MAJOR_VERSION=${FEDORA_MAJOR_VERSION} \
    --env RPMFUSION_MIRROR=${RPMFUSION_MIRROR} \
    $container_nokmods

for label in $IMAGE_LABELS
do
    buildah config --label $label $container_nokmods
done

buildah copy $container_nokmods \
    github-release-install.sh \
    install.sh \
    post-install.sh \
    packages.sh \
    packages.json \
      /tmp/

buildah copy --from=ghcr.io/ublue-os/config:latest $container_nokmods /rpms /tmp/rpms
buildah copy --from=ghcr.io/ublue-os/akmods:main-${FEDORA_MAJOR_VERSION} $container_nokmods /rpms/ublue-os /tmp/rpms

buildah run $container_nokmods \
    wget https://copr.fedorainfracloud.org/coprs/ublue-os/staging/repo/fedora-${FEDORA_MAJOR_VERSION}/ublue-os-staging-fedora-${FEDORA_MAJOR_VERSION}.repo -O /etc/yum.repos.d/_copr_ublue-os_staging.repo

buildah run $container_nokmods \
    wget https://copr.fedorainfracloud.org/coprs/kylegospo/oversteer/repo/fedora-${FEDORA_MAJOR_VERSION}/kylegospo-oversteer-fedora-${FEDORA_MAJOR_VERSION}.repo -O /etc/yum.repos.d/_copr_kylegospo_oversteer.repo

buildah run $container_nokmods \
    /tmp/install.sh

buildah run $container_nokmods \
    /tmp/post-install.sh

buildah run $container_nokmods \
    rm -f /etc/yum.repos.d/_copr_ublue-os_staging.repo

buildah run $container_nokmods \
    rm -f /etc/yum.repos.d/_copr_kylegospo_oversteer.repo

buildah run $container_nokmods \
    rm -rf /tmp/* /var/*

if [[ "$IMAGE_NAME" == "base" ]]
then
  buildah run $container_nokmods systemctl enable getty@tty1
fi

buildah run $container_nokmods \
    ostree container commit

buildah run $container_nokmods \
    mkdir -p /var/tmp

buildah run $container_nokmods \
    chmod -R 1777 /var/tmp

if [[ $TARGET_STAGE == "nokmods" ]]
then
  done_building $container_nokmods
fi

# !!! WARNING - KMODS IN MAIN IMAGES ARE DEPRECATED !!!

# Only "legacy" (Fedora 38 and older) have custom kmods included in the "main" images.
#FROM nokmods as kmods
container_kmods=$container_nokmods

IMAGE_NAME="${IMAGE_NAME:-silverblue}"
FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-38}"
RPMFUSION_MIRROR=""

buildah config \
    --env IMAGE_NAME=${IMAGE_NAME} \
    --env FEDORA_MAJOR_VERSION=${FEDORA_MAJOR_VERSION} \
    --env RPMFUSION_MIRROR=${RPMFUSION_MIRROR} \
    $container_kmods

buildah copy $container_kmods kmods-install.sh /tmp/kmods-install.sh
buildah copy $container_kmods kmods-sys_files /tmp/kmods-files

buildah copy --from=ghcr.io/ublue-os/akmods:main-${FEDORA_MAJOR_VERSION} $container_kmods /rpms /tmp/akmods-rpms

# kmods-install.sh will error if running in Fedora 39 or newer.
buildah run $container_kmods \
    /tmp/kmods-install.sh
buildah run $container_kmods \
    rm -rf /tmp/* /var/*
buildah run $container_kmods \
    ostree container commit
buildah run $container_kmods \
    mkdir -p /var/tmp
buildah run $container_kmods \
    chmod -R 1777 /var/tmp

done_building $container_kmods
