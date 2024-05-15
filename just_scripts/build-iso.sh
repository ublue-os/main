#!/usr/bin/bash
#shellcheck disable=SC2154,SC2034

if [[ -z ${project_root} ]]; then
    project_root=$(git rev-parse --show-toplevel)
fi
if [[ -z ${git_branch} ]]; then
    git_branch=$(git branch --show-current)
fi

# shellcheck disable=SC1091
. "${project_root}/just_scripts/sudoif.sh"

# Check if inside rootless container
if [[ -f /run/.containerenv ]]; then
    #shellcheck disable=SC1091
    source /run/.containerenv
    #shellcheck disable=SC2154
    if [[ "${rootless}" -eq "1" ]]; then
        echo "Cannot build ISO inside rootless podman container... Exiting..."
        exit 1
    fi
fi
container_mgr=$(just _container_mgr)
# If using rootless container manager, exit. Might not be best check
if "${container_mgr}" info | grep Root | grep -q /home; then
    echo "Cannot build ISO with rootless container..."
    exit 1
fi

# Get Inputs
image=$1
version=$2

# Set image/target/version based on inputs
# shellcheck disable=SC2154,SC1091
. "${project_root}/just_scripts/get-defaults.sh"

# Set Container tag name
tag=$(just _tag "${image}")

# Remove old ISO if present
sudoif rm -f "${project_root}/just_scripts/output/${tag}-${version}-${git_branch}.iso"
sudoif rm -f "${project_root}/just_scripts/output/${tag}-${version}-${git_branch}.iso-CHECKSUM"

# Set variant
if [[ "${image}" =~ "silverblue" ]]; then
    variant=Silverblue
else
    variant=Kinoite
fi

if [[ ${container_mgr} =~ "podman" ]]; then
    api_socket=/run/podman/podman.sock
elif [[ ${container_mgr} =~ "docker" ]]; then
    api_socket=/var/run/docker.sock
fi

# Make sure image actually exists, build if it doesn't
ID=$(${container_mgr} images --filter reference=localhost/"${tag}:${version}-${git_branch}" --format "{{.ID}}")
if [[ -z ${ID} ]]; then
    just build "${image}" "${version}"
fi

workspace=${project_root}
if [[ -f /.dockerenv || -f /run/.containerenv ]]; then
    workspace=${LOCAL_WORKSPACE_FOLDER}
fi

# Make ISO
${container_mgr} run --rm --privileged  \
    --volume "${api_socket}":/var/run/docker.sock \
    --volume "${workspace}"/just_scripts/build-iso-makefile-patch:/build-container-installer/container/Makefile \
    --volume "${workspace}"/just_scripts/output:/build-container-installer/build  \
    ghcr.io/jasonn3/build-container-installer:latest \
    ARCH="x86_64" \
    ENABLE_CACHE_DNF="false" \
    ENABLE_CACHE_SKOPEO="false" \
    ENROLLMENT_PASSWORD="ublue-os" \
    IMAGE_NAME="${tag}" \
    IMAGE_REPO="localhost" \
    IMAGE_TAG="${version}-${git_branch}" \
    ISO_NAME="build/${tag}-${version}-${git_branch}.iso" \
    SECURE_BOOT_KEY_URL='https://github.com/ublue-os/akmods/raw/main/certs/public_key.der' \
    VARIANT="${variant}" \
    VERSION="${version}"
