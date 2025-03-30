export gts := "40"
export latest := "41"
export beta := "42"
export default_version := latest
export default_image := "silverblue"
export source_org := "fedora-ostree-desktops"
export org := "ublue-os"
export repo := "main"
export IMAGE_REGISTRY := "ghcr.io/" + org
images := '(
    ["base"]="base-atomic"
    ["silverblue"]="silverblue"
    ["kinoite"]="kinoite"
    ["sway-atomic"]="sway-atomic"
    ["budgie-atomic"]="budgie-atomic"
    ["sericea"]="sway-atomic"
    ["onyx"]="budgie-atomic"
    ["lazurite"]="lxqt-atomic"
    ["vauxite"]="xfce-atomic"
)'
fedora_versions := '(
    ["gts"]="' + gts + '"
    ["' + gts + '"]="' + gts + '"
    ["latest"]="' + latest + '"
    ["' + latest + '"]="' + latest + '"
    ["beta"]="' + beta + '"
    ["' + beta + '"]="' + beta + '"
)'

_default:
    @just --list

alias run := run-container
alias build := build-container

# Run a Container
[group('Container')]
run-container $fedora_version=default_version $image_name=default_image:
    #!/usr/bin/bash
    set -eoux pipefail

    declare -a _images="$(just image-name-check $fedora_version $image_name)"
    image_name="${_images[0]}"
    fedora_version="$(just fedora-version-check $fedora_version)"

    podman image exists "localhost/$image_name:$fedora_version" ||
        just build "$fedora_version" "$image_name"
    podman run -it --rm "localhost/$image_name:$fedora_version" bash

# Build a Container
[group('Container')]
build-container $fedora_version=default_version $image_name=default_image $github="":
    #!/usr/bin/bash
    set -eoux pipefail

    declare -a _images="$(just image-name-check $fedora_version $image_name)"
    image_name="${_images[0]}"
    source_image_name="${_images[1]}"
    fedora_version="$(just fedora-version-check $fedora_version)"

    # Tags
    declare -A gen_tags="($(just gen-tags $fedora_version $image_name))"
    if [[ -z "$github" || ! "$github" =~ pull_request ]]; then
        declare -a tags="(${gen_tags["BUILD_TAGS"]})"
        TIMESTAMP="${gen_tags["TIMESTAMP"]}"
    else
        declare -a tags="(${gen_tags["COMMIT_TAGS"]})"
        TIMESTAMP="${gen_tags["TIMESTAMP"]}"
    fi
    TAGS=()
    for tag in "${tags[@]}"; do
        TAGS+=("--tag" "localhost/${image_name}:$tag")
    done

    # Labels
    VERSION="$fedora_version.$TIMESTAMP"
    KERNEL_VERSION="$(skopeo inspect docker://$IMAGE_REGISTRY/akmods:main-$fedora_version | jq -r '.Labels["ostree.linux"]')"
    LABELS=(
        "--label" "org.opencontainers.image.title=${image_name}"
        "--label" "org.opencontainers.image.version=${VERSION}"
        "--label" "org.opencontainers.image.description=A base Universal Blue {{ image_name }} image with batteries included"
        "--label" "ostree.linux=${KERNEL_VERSION}"
        "--label" "io.artifacthub.package.readme-url=https://raw.githubusercontent.com/${org}/${repo}/main/README.md"
        "--label" "io.artifacthub.package.logo-url=https://avatars.githubusercontent.com/u/120078124?s=200&v=4"
    )

    # Build Arguments
    BUILD_ARGS=(
        "--build-arg" "IMAGE_NAME=$image_name"
        "--build-arg" "SOURCE_ORG=$source_org"
        "--build-arg" "SOURCE_IMAGE=$source_image_name"
        "--build-arg" "FEDORA_MAJOR_VERSION=$fedora_version"
        "--build-arg" "KERNEL_VERSION=$KERNEL_VERSION"
        "--build-arg" "IMAGE_REGISTRY=$IMAGE_REGISTRY"
    )

    # Pull Images with retry
    podman pull --retry=3 "$IMAGE_REGISTRY/akmods:main-$fedora_version"
    podman pull --retry=3 "quay.io/$source_org/$source_image_name:$fedora_version"

    # Build Image
    buildah build -f Containerfile "${BUILD_ARGS[@]}" "${LABELS[@]}" "${TAGS[@]}"

# Generate Tags
[group('Utility')]
gen-tags $fedora_version=default_version $image_name=default_image:
    #!/usr/bin/bash
    set -eoux pipefail

    declare -a _images="$(just image-name-check $fedora_version $image_name)"
    image_name="${_images[0]}"
    fedora_version="$(just fedora-version-check $fedora_version)"

    TIMESTAMP="$(date +%Y%m%d)"
    LIST_TAGS="$(skopeo list-tags docker://${IMAGE_REGISTRY}/$image_name)"
    if [[ $(jq "any(.Tags[]; contains(\"$fedora_version-$TIMESTAMP\"))" <<< "$LIST_TAGS") == "true" ]]; then
        POINT="1"
        while $(jq -e "any(.Tags[]; contains(\"$fedora_version-$TIMESTAMP.$POINT\"))" <<< "$LIST_TAGS")
        do
            (( POINT++ ))
        done
    fi

    if [[ -n "${POINT:-}" ]]; then
        TIMESTAMP="$TIMESTAMP.$POINT"
    fi

    if [[ "$fedora_version" -eq "{{ gts }}" ]]; then
        IS_LATEST_VERSION=false
        IS_STABLE_VERSION=true
        IS_GTS_VERSION=true
        IS_BETA_VERSION=false
        BUILD_TAGS=("gts")
    elif [[ "$fedora_version" -eq "{{ latest }}" ]]; then
        IS_LATEST_VERSION=true
        IS_STABLE_VERSION=true
        IS_GTS_VERSION=false
        IS_BETA_VERSION=false
        BUILD_TAGS=("latest")
    elif [[ "$fedora_version" -eq "{{ beta }}" ]]; then
        IS_LATEST_VERSION=false
        IS_STABLE_VERSION=false
        IS_GTS_VERSION=false
        IS_BETA_VERSION=true
        BUILD_TAGS=("beta")
    fi

    # Add a sha tag for tracking builds during a pull request
    SHA_SHORT="$(git rev-parse --short HEAD)"
    COMMIT_TAGS=("$SHA_SHORT-$fedora_version")

    BUILD_TAGS+=("$fedora_version")
    BUILD_TAGS+=("$fedora_version-$TIMESTAMP")
    declare -A output
    output["BUILD_TAGS"]="${BUILD_TAGS[*]}"
    output["COMMIT_TAGS"]="${COMMIT_TAGS[*]}"
    output["TIMESTAMP"]="$TIMESTAMP"
    echo "${output[@]@K}"

# Check Valid Image Name
[group('Utility')]
image-name-check $fedora_version=default_version $image_name=default_image:
    #!/usr/bin/bash
    set -eoux pipefail
    declare -A images={{ images }}
    if [[ "$image_name" =~ -main$ ]]; then
        image_name="${image_name%-main}"
    fi
    source_image_name="${images[$image_name]:-}"
    if [[ -z "$source_image_name" ]]; then
        echo "()"
        exit 1
    fi
    fedora_version="$(just fedora-version-check $fedora_version)"
    if [[ "$image_name" =~ lazurite|vauxite && "$fedora_version" -gt "41" ]]; then
        echo "()"
        exit 1
    elif [[ "$image_name" =~ sericea|vauxite && "$fedora_version" -gt "41" ]]; then
        echo "()"
        exit 1
    elif [[ "$image_name" =~ atomic && "$fedora_version" -lt "42" ]]; then
        echo "()"
        exit 1
    elif [[ "$fedora_version" -eq "40" ]]; then
        echo "($image_name-main $image_name)"
    else
        echo "($image_name-main $source_image_name)"
    fi

# Check Valid Fedora Version
[group('Utility')]
fedora-version-check $fedora_version=default_version:
    #!/usr/bin/bash
    set -eoux pipefail
    declare -A fedora_versions={{ fedora_versions }}
    if [[ -z "${fedora_versions[$fedora_version]:-}" ]]; then
        echo "Not a supported version"
        exit 1
    fi
    echo "${fedora_versions[$fedora_version]}"

# Check Secureboot
[group('Utility')]
secureboot $fedora_version=default_version $image_name=default_image:
    #!/usr/bin/env bash
    set -eoux pipefail
    declare -a _images="$(just image-name-check $fedora_version $image_name)"
    image_name="${_images[0]}"
    fedora_version="$(just fedora-version-check $fedora_version)"
    # Get the vmlinuz to check
    kernel_release=$(podman inspect "$image_name":"$fedora_version" | jq -r '.[].Config.Labels["ostree.linux"]')
    TMP=$(podman create "$image_name":"$fedora_version" bash)
    podman cp "$TMP":/usr/lib/modules/"$kernel_release"/vmlinuz /tmp/vmlinuz
    podman rm "$TMP"

    # Get the Public Certificates
    curl --retry 3 -Lo /tmp/kernel-sign.der https://github.com/ublue-os/kernel-cache/raw/main/certs/public_key.der
    curl --retry 3 -Lo /tmp/akmods.der https://github.com/ublue-os/kernel-cache/raw/main/certs/public_key_2.der
    openssl x509 -in /tmp/kernel-sign.der -out /tmp/kernel-sign.crt
    openssl x509 -in /tmp/akmods.der -out /tmp/akmods.crt

    # Make sure we have sbverify
    CMD="$(command -v sbverify)"
    if [[ -z "${CMD:-}" ]]; then
        temp_name="sbverify-${RANDOM}"
        podman run -dt \
            --entrypoint /bin/sh \
            --volume /tmp/vmlinuz:/tmp/vmlinuz:z \
            --volume /tmp/kernel-sign.crt:/tmp/kernel-sign.crt:z \
            --volume /tmp/akmods.crt:/tmp/akmods.crt:z \
            --name ${temp_name} \
            alpine:edge
        podman exec "$temp_name" apk add sbsigntool
        CMD="podman exec $temp_name /usr/bin/sbverify"
    fi

    # Confirm that Signatures Are Good
    $CMD --list /tmp/vmlinuz
    returncode=0
    if ! $CMD --cert /tmp/kernel-sign.crt /tmp/vmlinuz || ! $CMD --cert /tmp/akmods.crt /tmp/vmlinuz; then
        echo "Secureboot Signature Failed...."
        returncode=1
    fi
    if [[ -n "${temp_name:-}" ]]; then
        podman rm -f "$temp_name"
    fi
    exit "$returncode"

# Check Just Syntax
[group('Just')]
check:
    #!/usr/bin/env bash
    find . -type f -name "*.just" | while read -r file; do
        echo "Checking syntax: $file"
        just --unstable --fmt --check -f $file
    done
    echo "Checking syntax: Justfile"
    just --unstable --fmt --check -f Justfile

# Fix Just Syntax
[group('Just')]
fix:
    #!/usr/bin/env bash
    find . -type f -name "*.just" | while read -r file; do
        echo "Checking syntax: $file"
        just --unstable --fmt -f $file
    done
    echo "Checking syntax: Justfile"
    just --unstable --fmt -f Justfile || { exit 1; }
