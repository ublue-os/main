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
export SUDO_DISPLAY := if `if [ -n "${DISPLAY:-}" ] || [ -n "${WAYLAND_DISPLAY:-}" ]; then echo true; fi` == "true" { "true" } else { "false" }
export SUDOIF := if `id -u` == "0" { "" } else if SUDO_DISPLAY == "true" { "sudo --askpass" } else { "sudo" }
export SET_X := if `id -u` == "0" { "1" } else { env('SET_X', '') }

_default:
    @just --list

alias run := run-container
alias build := build-container

# Run a Container
[group('Container')]
run-container $fedora_version=default_version $image_name=default_image:
    #!/usr/bin/bash
    set -eou pipefail

    declare -a _images="$(just image-name-check $fedora_version $image_name)"
    if [[ -z ${_images[0]:-} ]]; then
       exit 1
    fi
    image_name="${_images[0]}"
    fedora_version="${_images[2]}"

    if ! podman image exists "localhost/$image_name:$fedora_version"; then
        echo "{{ style('warning') }}Container Does Not Exist{{ NORMAL }}"
        echo "{{ style('warning') }}Will Run:{{ NORMAL }} {{ style('command') }}just build $fedora_version $image_name{{ NORMAL }}"
        seconds=5
        while [ $seconds -gt 0 ]; do
            printf "\rTime remaining: {{ style('error') }}%d{{ NORMAL }} seconds to cancel" $seconds
            sleep 1
            (( seconds-- ))
        done
        printf "\n{{ style('warning') }}Running:{{ NORMAL }} just build %s %s" "$fedora_version" "$image_name"
        just build "$fedora_version" "$image_name"
    fi
    echo "{{ style('warning') }}Running:{{ NORMAL }} {{ style('command') }}just build $fedora_version $image_name{{ NORMAL }}"
    sleep 1
    podman run -it --rm "localhost/$image_name:$fedora_version" bash || exit 0

# Build a Container
[group('Container')]
build-container $fedora_version=default_version $image_name=default_image $github="":
    #!/usr/bin/bash
    set -eoux pipefail

    declare -a _images="$(just image-name-check $fedora_version $image_name)"
    if [[ -z ${_images[0]:-} ]]; then
       exit 1
    fi
    image_name="${_images[0]}"
    source_image_name="${_images[1]}"
    fedora_version="${_images[2]}"

    # Verify Source Containers
    just verify-container "akmods:main-$fedora_version"
    if [[ "$fedora_version" -ge "41" ]]; then
        just verify-container "$source_image_name:$fedora_version" "quay.io/$source_org" "https://gitlab.com/fedora/ostree/ci-test/-/raw/f$fedora_version/quay.io-fedora-ostree-desktops.pub?ref_type=heads"
    fi

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
    set ${SET_X:+-x} -eou pipefail

    declare -a _images="$(just image-name-check $fedora_version $image_name)"
    if [[ -z ${_images[0]:-} ]]; then
       exit 1
    fi
    image_name="${_images[0]}"
    fedora_version="${_images[2]}"

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
    set ${SET_X:+-x} -eou pipefail
    declare -A images={{ images }}
    if [[ "$image_name" =~ -main$ ]]; then
        image_name="${image_name%-main}"
    fi
    source_image_name="${images[$image_name]:-}"
    if [[ -z "$source_image_name" ]]; then
        echo "()"
        echo "Invalid Image Name" >&2
        exit 1
    fi
    fedora_version="$(just fedora-version-check $fedora_version)"
    if [[ -z "$fedora_version" ]]; then
        exit 1
    fi
    if [[ "$image_name" =~ lazurite|vauxite && "$fedora_version" -ge "42" ]]; then
        echo "()"
        echo "{{ style('error') }}Invalid Image Name. Lazurite and Vauxite no longer supported >= F42{{ NORMAL }}" >&2
        exit 1
    elif [[ "$image_name" =~ sericea|onyx && "$fedora_version" -ge "42" ]]; then
        echo "()"
        echo "{{ style('error') }}Invalid Image Name. Sericea and Onyx names are -atomic names on >= F42{{ NORMAL }}" >&2
        exit 1
    elif [[ "$image_name" =~ atomic && "$fedora_version" -le "41" ]]; then
        echo "()"
        echo "{{ style('error') }}Invalid Image Name. -atomic names only used on >= F42{{ NORMAL }}" >&2
        exit 1
    elif [[ "$fedora_version" -eq "40" ]]; then
        echo "($image_name-main $image_name $fedora_version)"
    else
        echo "($image_name-main $source_image_name $fedora_version)"
    fi

# Check Valid Fedora Version
[group('Utility')]
fedora-version-check $fedora_version=default_version:
    #!/usr/bin/bash
    set ${SET_X:+-x} -eou pipefail
    declare -A fedora_versions={{ fedora_versions }}
    if [[ -z "${fedora_versions[$fedora_version]:-}" ]]; then
        echo ''
        echo "{{ style('error') }}Not a supported version{{ NORMAL }}" >&2
        exit 1
    fi
    echo "${fedora_versions[$fedora_version]}"

# Check Secureboot
[group('Utility')]
secureboot $fedora_version=default_version $image_name=default_image:
    #!/usr/bin/env bash
    set ${SET_X:+-x} -eou pipefail
    declare -a _images="$(just image-name-check $fedora_version $image_name)"
    if [[ -z ${_images[0]:-} ]]; then
       exit 1
    fi
    image_name="${_images[0]}"
    fedora_version="${_images[2]}"
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

# Verify Container with Cosign
[group('Utility')]
verify-container $container="" $registry="ghcr.io/ublue-os" $key="":
    #!/usr/bin/env bash
    set ${SET_X:+-x} -eou pipefail
    # Get Cosign if Needed
    if [[ ! $(command -v cosign) ]]; then
        COSIGN_CONTAINER_ID=$({{ SUDOIF }} podman create cgr.dev/chainguard/cosign:latest bash)
        {{ SUDOIF }} podman cp "${COSIGN_CONTAINER_ID}":/usr/bin/cosign /usr/local/bin/cosign
        {{ SUDOIF }} podman rm -f "${COSIGN_CONTAINER_ID}"
    fi

    # Verify Cosign Image Signatures if needed
    if [[ -n "${COSIGN_CONTAINER_ID:-}" ]]; then
        if ! cosign verify --certificate-oidc-issuer=https://token.actions.githubusercontent.com --certificate-identity=https://github.com/chainguard-images/images/.github/workflows/release.yaml@refs/heads/main cgr.dev/chainguard/cosign >/dev/null; then
            echo "NOTICE: Failed to verify cosign image signatures."
            exit 1
        fi
    fi

    # Public Key for Container Verification
    if [[ -z "${key:-}" && "$registry" == "ghcr.io/ublue-os" ]]; then
        key="https://raw.githubusercontent.com/ublue-os/main/main/cosign.pub"
    fi

    # Verify Container using cosign public key
    if ! cosign verify --key "$key" "$registry/$container" >/dev/null; then
        echo "{{ style('error') }}NOTICE: Verification failed. Please ensure your public key is correct.{{ NORMAL }}"
        exit 1
    fi

# Removes all Tags of an image from container storage.
[group('Utility')]
clean $image_name $registry="localhost":
    #!/usr/bin/bash
    set -eoux pipefail
    if [[ "$registry" == "localhost" ]]; then
        declare -A images={{ images }}
        image_name="${image_name%-main}"
        if [[ -z "${images[$image_name]:-}" ]]; then
            echo "{{ style('error') }}Invalid Image name...{{ NORMAL }}" >&2
            exit 1
        fi
            image_name="$image_name-main"
    fi
    declare -a CLEAN="($(podman image list $registry/$image_name --noheading --format 'table {{{{ .ID }}' | uniq))"
    if [[ -n "${CLEAN[@]:-}" ]]; then
        podman rmi -f "${CLEAN[@]}"
    fi
