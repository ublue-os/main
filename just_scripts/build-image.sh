#!/usr/bin/bash
set -eo pipefail
if [[ -z ${project_root} ]]; then
    project_root=$(git rev-parse --show-toplevel)
fi 
if [[ -z ${git_branch} ]]; then
    git_branch=$(git branch --show-current)
fi

# Get Inputs
image=$1
version=$2

# Set image/target/version based on inputs
# shellcheck disable=SC2154,SC1091
. "${project_root}/just_scripts/get-defaults.sh"

# Get info
container_mgr=$(just _container_mgr)
tag=$(just _tag "${image}")

# Build Image
$container_mgr build -f Containerfile \
    --build-arg="IMAGE_NAME=${tag}" \
    --build-arg="SOURCE_ORG=fedora-ostree-desktops" \
    --build-arg="SOURCE_IMAGE=${image}" \
    --build-arg="FEDORA_MAJOR_VERSION=${version}" \
    --tag localhost/"${tag}:${version}-${git_branch}" \
    "${project_root}"
