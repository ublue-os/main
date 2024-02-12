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
    wget https://copr.fedorainfracloud.org/coprs/ublue-os/staging/repo/fedora-$(rpm -E %fedora)/ublue-os-staging-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_ublue-os_staging.repo && \
    wget https://copr.fedorainfracloud.org/coprs/kylegospo/oversteer/repo/fedora-$(rpm -E %fedora)/kylegospo-oversteer-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_kylegospo_oversteer.repo && \
    /tmp/install.sh && \
    /tmp/post-install.sh && \
    rm -f /etc/yum.repos.d/_copr_ublue-os_staging.repo && \
    rm -f /etc/yum.repos.d/_copr_kylegospo_oversteer.repo && \
    rm -rf /tmp/* /var/* && \
    if [[ "$IMAGE_NAME" == "base" ]]; then systemctl enable getty@tty1; fi && \
    ostree container commit && \
    mkdir -p /var/tmp && chmod -R 1777 /var/tmp

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

buildah copy $container_kmods kmods-install.sh /tmp/kmods-install.sh
buildah copy $container_kmods kmods-sys_files /tmp/kmods-files

buildah copy --from=ghcr.io/ublue-os/akmods:main-${FEDORA_MAJOR_VERSION} $container_kmods /rpms /tmp/akmods-rpms

# kmods-install.sh will error if running in Fedora 39 or newer.
buildah run $container_kmods \
    /tmp/kmods-install.sh && \
    rm -rf /tmp/* /var/* && \
    ostree container commit && \
    mkdir -p /var/tmp && chmod -R 1777 /var/tmp

done_building $container_kmods
