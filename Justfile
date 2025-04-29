set unstable := true

# Tags

gts := "41"
latest := "42"
[private]
beta := "43"

# Defaults

default_version := latest
default_image := "silverblue"
default_variant := "main"

# Reused Values

org := "ublue-os"
repo := "main"
IMAGE_REGISTRY := "ghcr.io" / org

# Upstream

[private]
source_org := "fedora-ostree-desktops"
source_registry := "quay.io" / source_org

# Image File

[private]
image-file := justfile_dir() / "image-versions.yaml"

# Image Names

[private]
images := '(
    ["base"]="base-atomic"
    ["silverblue"]="silverblue"
    ["kinoite"]="kinoite"
    ["sway-atomic"]="sway-atomic"
    ["budgie-atomic"]="budgie-atomic"
    ["cosmic-atomic"]="cosmic-atomic"
    ["sericea"]="sway-atomic"
    ["onyx"]="budgie-atomic"
    ["lazurite"]="lxqt-atomic"
    ["vauxite"]="xfce-atomic"
)'

# Fedora Versions

[private]
fedora_versions := '(
    ["gts"]="' + gts + '"
    ["' + gts + '"]="' + gts + '"
    ["latest"]="' + latest + '"
    ["' + latest + '"]="' + latest + '"
    ["beta"]="' + beta + '"
    ["' + beta + '"]="' + beta + '"
)'

# Variants

[private]
variants := '(
    ["main"]="main"
    ["nvidia"]="nvidia"
)'

# Sudo/Podman/Just

[private]
SUDO_DISPLAY := env("DISPLAY", "") || env("WAYLAND_DISPLAY", "")
[private]
SUDOIF := if `id -u` == "0" { "" } else if SUDO_DISPLAY != "" { which("sudo") + " --askpass" } else { which("sudo") }
[private]
just := just_executable()
[private]
PODMAN := which("podman") || require("podman-remote")

# Make things quieter by default

[private]
export SET_X := if `id -u` == "0" { "1" } else { env('SET_X', '') }

# Aliases

alias run := run-container
alias build := build-container

# Utility

[private]
default-inputs := '
: ${fedora_version:=' + default_version + '}
: ${image_name:=' + default_image + '}
: ${variant:=' + default_variant + '}
'
[private]
get-names := '
declare -a _images="$(' + just + ' image-name-check $image_name $fedora_version $variant)"
if [[ -z ${_images[0]:-} ]]; then
    exit 1
fi
image_name="${_images[0]}"
source_image_name="${_images[1]}"
fedora_version="${_images[2]}"
'
[private]
build-missing := '
cmd="' + just + ' build ${image_name%-*} $fedora_version $variant"
if ! ' + PODMAN + ' image exists "localhost/$image_name:$fedora_version"; then
    echo "' + style('warning') + 'Warning' + NORMAL +': Container Does Not Exist..." >&2
    echo "' + style('warning') + 'Will Run' + NORMAL +': ' + style('command') + '$cmd' + NORMAL +'" >&2
    seconds=5
    while [ $seconds -gt 0 ]; do
        printf "\rTime remaining: ' + style('error') + '%d' + NORMAL + ' seconds to cancel" $seconds >&2
        sleep 1
        (( seconds-- ))
    done
    echo "" >&2
    echo "'+ style('warning') +'Running'+ NORMAL+ ': '+ style('command') +'$cmd'+ NORMAL+ '" >&2
    $cmd
fi
'
[private]
pull-retry := '
function pull-retry() {
    local target="$1"
    local retries=3
    while [ $retries -gt 0 ]; do
        ' + PODMAN + ' pull $target && break
        (( retries-- ))
    done
}
'

_default:
    @{{ just }} --list

# Run a Container
[group('Container')]
run-container $image_name="" $fedora_version="" $variant="":
    #!/usr/bin/bash
    set -eou pipefail

    {{ default-inputs }}
    {{ get-names }}
    {{ build-missing }}

    echo "{{ style('warning') }}Running:{{ NORMAL }} {{ style('command') }}{{ just }} run -it --rm localhost/$image_name:$fedora_version bash {{ NORMAL }}"
    {{ PODMAN }} run -it --rm "localhost/$image_name:$fedora_version" bash || exit 0

# Build a Container
[group('Container')]
build-container $image_name="" $fedora_version="" $variant="" $github="":
    #!/usr/bin/bash
    set ${SET_X:+-x} -eou pipefail

    {{ default-inputs }}
    {{ get-names }}
    {{ pull-retry }}

    AKMODS_DIGEST="$(yq -r ".images[] | select(.name == \"akmods-${fedora_version}\") | .digest" {{ image-file }})"
    AKMODS_NVIDIA_DIGEST="$(yq -r ".images[] | select(.name == \"akmods-nvidia-open-${fedora_version}\") | .digest" {{ image-file }})"
    BASE_IMAGE_DIGEST="$(yq -r ".images[] | select(.name == \"${source_image_name}-${fedora_version}\") | .digest" {{ image-file }})"

    # Verify Source Containers
    {{ just }} verify-container "akmods@$AKMODS_DIGEST"
    {{ just }} verify-container "akmods-nvidia-open@$AKMODS_NVIDIA_DIGEST"
    if [[ "$fedora_version" -ge "41" ]]; then
        {{ just }} verify-container "$source_image_name@$BASE_IMAGE_DIGEST" "{{ source_registry }}" "https://gitlab.com/fedora/ostree/ci-test/-/raw/f$fedora_version/quay.io-fedora-ostree-desktops.pub?ref_type=heads"
    fi

    # Tags
    declare -A gen_tags="($({{ just }} gen-tags $image_name $fedora_version $variant))"
    if [[ "${github:-}" =~ pull_request ]]; then
        tags=(${gen_tags["COMMIT_TAGS"]})
    else
        tags=(${gen_tags["BUILD_TAGS"]})
    fi
    TIMESTAMP="${gen_tags["TIMESTAMP"]}"
    TAGS=()
    for tag in "${tags[@]}"; do
        TAGS+=("--tag" "localhost/${image_name}:$tag")
    done

    # Labels
    VERSION="$fedora_version.$TIMESTAMP"
    KERNEL_VERSION="$(skopeo inspect docker://{{ IMAGE_REGISTRY }}/akmods:main-$fedora_version | jq -r '.Labels["ostree.linux"]')"
    LABELS=(
        "--label" "org.opencontainers.image.title=${image_name}"
        "--label" "org.opencontainers.image.version=${VERSION}"
        "--label" "org.opencontainers.image.description=A base Universal Blue ${image_name%-*} image with batteries included"
        "--label" "ostree.linux=${KERNEL_VERSION}"
        "--label" "io.artifacthub.package.readme-url=https://raw.githubusercontent.com/{{ org }}/{{ repo }}/main/README.md"
        "--label" "io.artifacthub.package.logo-url=https://avatars.githubusercontent.com/u/120078124?s=200&v=4"
    )

    BUILD_NVIDIA="N"
    if [[ "$variant" =~ nvidia ]]; then
        BUILD_NVIDIA="Y"
    fi

    # Build Arguments
    BUILD_ARGS=(
        "--build-arg" "IMAGE_NAME=$image_name"
        "--build-arg" "SOURCE_ORG={{ source_org }}"
        "--build-arg" "SOURCE_IMAGE=${source_image_name}"
        "--build-arg" "FEDORA_MAJOR_VERSION=$fedora_version"
        "--build-arg" "IMAGE_REGISTRY={{ IMAGE_REGISTRY }}"
        "--build-arg" "KERNEL_VERSION=$KERNEL_VERSION"
        "--build-arg" "BASE_IMAGE_DIGEST=$BASE_IMAGE_DIGEST"
        "--build-arg" "AKMODS_DIGEST=$AKMODS_DIGEST"
        "--build-arg" "AKMODS_NVIDIA_DIGEST=$AKMODS_NVIDIA_DIGEST"
        "--build-arg" "BUILD_NVIDIA=$BUILD_NVIDIA"
    )

    # Pull Images with retry
    pull-retry "{{ IMAGE_REGISTRY }}/akmods:main-$fedora_version@$AKMODS_DIGEST"
    pull-retry "{{ IMAGE_REGISTRY }}/akmods-nvidia-open:main-$fedora_version@$AKMODS_NVIDIA_DIGEST"
    pull-retry "{{ source_registry }}/$source_image_name:$fedora_version@$BASE_IMAGE_DIGEST"

    # Build Image
    {{ PODMAN }} build -f Containerfile "${BUILD_ARGS[@]}" "${LABELS[@]}" "${TAGS[@]}"

    # CI Cleanup
    if [[ -n "${CI:-}" ]]; then
        {{ PODMAN }} rmi -f "{{ IMAGE_REGISTRY }}/akmods:main-$fedora_version@$AKMODS_DIGEST"
        {{ PODMAN }} rmi -f "{{ IMAGE_REGISTRY }}/akmods-nvidia-open:main-$fedora_version@$AKMODS_NVIDIA_DIGEST"
        {{ PODMAN }} rmi -f "{{ source_registry }}/$source_image_name:$fedora_version@$BASE_IMAGE_DIGEST"
    fi

# Generate Tags
[group('Utility')]
gen-tags $image_name="" $fedora_version="" $variant="":
    #!/usr/bin/bash
    set ${SET_X:+-x} -eou pipefail

    {{ default-inputs }}
    {{ get-names }}

    # Generate Timestamp with incrementing version point
    TIMESTAMP="$(date +%Y%m%d)"
    LIST_TAGS="$(mktemp)"
    while [[ ! -s "$LIST_TAGS" ]]; do
        skopeo list-tags docker://{{ IMAGE_REGISTRY }}/$image_name > "$LIST_TAGS"
    done
    if [[ $(cat "$LIST_TAGS" | jq "any(.Tags[]; contains(\"$fedora_version-$TIMESTAMP\"))") == "true" ]]; then
        POINT="1"
        while $(cat "$LIST_TAGS" | jq -e "any(.Tags[]; contains(\"$fedora_version-$TIMESTAMP.$POINT\"))")
        do
            (( POINT++ ))
        done
    fi

    if [[ -n "${POINT:-}" ]]; then
        TIMESTAMP="$TIMESTAMP.$POINT"
    fi

    # Add a sha tag for tracking builds during a pull request
    SHA_SHORT="$(git rev-parse --short HEAD)"

    # Define Versions
    if [[ "$fedora_version" -eq "{{ gts }}" ]]; then
        COMMIT_TAGS=("$SHA_SHORT-gts")
        BUILD_TAGS=("gts" "gts-$TIMESTAMP")
    elif [[ "$fedora_version" -eq "{{ latest }}" ]]; then
        COMMIT_TAGS=("$SHA_SHORT-latest")
        BUILD_TAGS=("latest" "latest-$TIMESTAMP")
    elif [[ "$fedora_version" -eq "{{ beta }}" ]]; then
        COMMIT_TAGS=("$SHA_SHORT-beta")
        BUILD_TAGS=("beta beta-$TIMESTAMP")
    fi

    COMMIT_TAGS+=("$SHA_SHORT-$fedora_version" "$fedora_version")
    BUILD_TAGS+=("$fedora_version" "$fedora_version-$TIMESTAMP")
    declare -A output
    output["BUILD_TAGS"]="${BUILD_TAGS[*]}"
    output["COMMIT_TAGS"]="${COMMIT_TAGS[*]}"
    output["TIMESTAMP"]="$TIMESTAMP"
    echo "${output[@]@K}"

# Check Valid Image Name
[group('Utility')]
image-name-check $image_name $fedora_version $variant:
    #!/usr/bin/bash
    set ${SET_X:+-x} -eou pipefail
    declare -A images={{ images }}

    if [[ "$image_name" =~ -main$|-nvidia$ ]]; then
        image_name="${image_name%-*}"
    fi

    source_image_name="${images[$image_name]:-}"
    if [[ -z "$source_image_name" ]]; then
        echo '{{ style('error') }}Invalid Image Name{{ NORMAL }}' >&2
        exit 1
    fi

    fedora_version="$({{ just }} fedora-version-check $fedora_version || exit 1)"
    variant="$({{ just }} fedora-variant-check $variant || exit 1)"

    # TODO: Remove this block when 42 becomes GTS
    if [[ "$fedora_version" -eq "40" ]]; then
        echo "($image_name-$variant $image_name $fedora_version)"
    elif [[ "$image_name" =~ lazurite|vauxite && "$fedora_version" -ge "42" ]]; then
        echo '{{ style('error') }}Invalid Image Name{{ NORMAL }}: Lazurite and Vauxite no longer supported >= F42' >&2
        exit 1
    elif [[ "$image_name" =~ sericea|onyx && "$fedora_version" -ge "42" ]]; then
        echo '{{ style('error') }}Invalid Image Name{{ NORMAL }}: Sericea and Onyx names are `-atomic` names on >= F42' >&2
        exit 1
    elif [[ "$image_name" =~ atomic && "$fedora_version" -le "41" ]]; then
        echo '{{ style('error') }}Invalid Image Name{{ NORMAL }}: {{ style('command') }}`-atomic` names only used on >= F42{{ NORMAL }}' >&2
        exit 1
    else
        echo "($image_name-$variant $source_image_name $fedora_version)"
    fi

# Check Valid Fedora Version
[group('Utility')]
fedora-version-check $fedora_version:
    #!/usr/bin/bash
    set ${SET_X:+-x} -eou pipefail
    declare -A fedora_versions={{ fedora_versions }}
    if [[ -z "${fedora_versions[$fedora_version]:-}" ]]; then
        echo "{{ style('error') }}Not a supported version{{ NORMAL }}" >&2
        exit 1
    fi
    echo "${fedora_versions[$fedora_version]}"

# Check Valid Variant
[group('Utility')]
fedora-variant-check $variant:
    #!/usr/bin/bash
    set ${SET_X:+-x} -eou pipefail
    declare -A variants={{ variants }}
    if [[ -z "${variants[$variant]:-}" ]]; then
        echo "{{ style('error') }}Not a supported variant{{ NORMAL }}" >&2
        exit 1
    fi
    echo "${variants[$variant]}"

# Check Secureboot
[group('Utility')]
secureboot $image_name $fedora_version $variant:
    #!/usr/bin/env bash
    set ${SET_X:+-x} -eou pipefail

    {{ get-names }}

    # Get the vmlinuz to check
    kernel_release=$({{ PODMAN }} inspect "$image_name":"$fedora_version" | jq -r '.[].Config.Labels["ostree.linux"]')
    TMP=$({{ PODMAN }} create "$image_name":"$fedora_version" bash)
    {{ PODMAN }} cp "$TMP":/usr/lib/modules/"$kernel_release"/vmlinuz /tmp/vmlinuz
    {{ PODMAN }} rm -f "$TMP"

    # Get the Public Certificates
    curl --retry 3 -Lo /tmp/kernel-sign.der https://github.com/ublue-os/akmods/raw/main/certs/public_key.der
    curl --retry 3 -Lo /tmp/akmods.der https://github.com/ublue-os/akmods/raw/main/certs/public_key_2.der
    openssl x509 -in /tmp/kernel-sign.der -out /tmp/kernel-sign.crt
    openssl x509 -in /tmp/akmods.der -out /tmp/akmods.crt

    # Make sure we have sbverify
    CMD="$(command -v sbverify)"
    if [[ -z "${CMD:-}" ]]; then
        temp_name="sbverify-${RANDOM}"
        {{ PODMAN }} run -dt \
            --entrypoint /bin/sh \
            --volume /tmp/vmlinuz:/tmp/vmlinuz:z \
            --volume /tmp/kernel-sign.crt:/tmp/kernel-sign.crt:z \
            --volume /tmp/akmods.crt:/tmp/akmods.crt:z \
            --name $temp_name \
            alpine:edge
        {{ PODMAN }} exec "$temp_name" apk add sbsigntool
        CMD="{{ PODMAN }} exec $temp_name /usr/bin/sbverify"
        trap "{{ PODMAN }} rm -f $temp_name; exit 1" SIGINT
    fi

    # Confirm that Signatures Are Good
    $CMD --list /tmp/vmlinuz
    returncode=0
    if ! $CMD --cert /tmp/kernel-sign.crt /tmp/vmlinuz || ! $CMD --cert /tmp/akmods.crt /tmp/vmlinuz; then
        echo '{{ style('error') }}Secureboot Signature Failed...{{ NORMAL }}' >&2
        returncode=1
    fi
    if [[ -n "${temp_name:-}" ]]; then
        {{ PODMAN }} rm -f "$temp_name"
        if [[ -n "${CI:-}" ]]; then
            {{ PODMAN }} rmi -f alpine:edge
        fi
    fi
    exit "$returncode"

# Check Just Syntax
[group('Just')]
check:
    #!/usr/bin/env bash
    find . -type f -name "*.just" | while read -r file; do
        echo "Checking syntax: $file" >&2
        {{ just }} --unstable --fmt --check -f $file
    done
    echo "Checking syntax: Justfile" >&2
    {{ just }} --unstable --fmt --check -f Justfile

# Fix Just Syntax
[group('Just')]
fix:
    #!/usr/bin/env bash
    find . -type f -name "*.just" | while read -r file; do
        echo "Checking syntax: $file" >&2
        {{ just }} --unstable --fmt -f $file
    done
    echo "Checking syntax: Justfile" >&2
    {{ just }} --unstable --fmt -f Justfile || { exit 1; }

# Verify Container with Cosign
[group('Utility')]
verify-container $container="" $registry="" $key="": install-cosign
    #!/usr/bin/env bash
    set ${SET_X:+-x} -eou pipefail

    # ublue-os Public Key for Container Verification default
    if [[ -z "${registry:-}" && -z "${key:-}"  ]]; then
        registry={{ IMAGE_REGISTRY }}
        key="https://raw.githubusercontent.com/ublue-os/main/main/cosign.pub"
    fi

    # Verify Container using cosign public key
    if ! cosign verify --key "$key" "$registry/$container" >/dev/null; then
        echo '{{ style('error') }}NOTICE: Verification failed. Please ensure your public key is correct.{{ NORMAL }}' >&2
        exit 1
    fi

# Removes all Tags of an image from container storage.
[group('Utility')]
clean $image_name $fedora_version $variant $registry="":
    #!/usr/bin/bash
    set -eoux pipefail

    : "${registry:=localhost}"
    {{ get-names }}

    declare -a CLEAN="($({{ PODMAN }} image list $registry/$image_name --noheading --format 'table {{{{ .ID }}' | uniq))"
    if [[ -n "${CLEAN[@]:-}" ]]; then
        {{ PODMAN }} rmi -f "${CLEAN[@]}"
    fi

# Get Cosign if Needed
install-cosign:
    #!/usr/bin/bash
    set ${SET_X:+-x} -eou pipefail

    {{ pull-retry }}

    if ! command -v cosign >/dev/null; then
        pull-retry "cgr.dev/chainguard/cosign:latest"
        COSIGN_CONTAINER_ID=$({{ PODMAN }} create cgr.dev/chainguard/cosign:latest bash)
        {{ PODMAN }} cp "${COSIGN_CONTAINER_ID}":/usr/bin/cosign /tmp/cosign.install
        {{ SUDOIF }} cp /tmp/cosign.install /usr/local/bin/cosign
        {{ SUDOIF }} rm -f /tmp/cosign.install
        {{ PODMAN }} rm -f "${COSIGN_CONTAINER_ID}"
        {{ PODMAN }} rmi "cgr.dev/chainguard/cosign:latest"

        if ! cosign verify --certificate-oidc-issuer=https://token.actions.githubusercontent.com --certificate-identity=https://github.com/chainguard-images/images/.github/workflows/release.yaml@refs/heads/main cgr.dev/chainguard/cosign >/dev/null; then
            echo "{{ style('error') }}NOTICE: Failed to verify cosign image signatures.{{ NORMAL }}" >&2
            exit 1
        fi

    fi

# Get Digest

# Login to GHCR
[group('CI')]
@login-to-ghcr $user $token:
    echo "$token" | {{ PODMAN }} login ghcr.io -u "$user" --password-stdin
    echo "$token" | docker login ghcr.io -u "$user" --password-stdin

# Push Images to Registry
[group('CI')]
push-to-registry $image_name $fedora_version $variant $destination="" $transport="":
    #!/usr/bin/bash
    set ${SET_X:+-x} -eou pipefail

    {{ get-names }}
    {{ build-missing }}

    : "${destination:={{ IMAGE_REGISTRY }}}"
    : "${transport:="docker://"}"

    declare -a TAGS="($({{ PODMAN }} image list localhost/$image_name:$fedora_version --noheading --format 'table {{{{ .Tag }}'))"
    for tag in "${TAGS[@]}"; do
        skopeo copy --retry-times=3 "containers-storage:localhost/$image_name:$fedora_version" "$transport$destination/$image_name:$tag" >&2
    done

# Sign Images with Cosign
[group('CI')]
cosign-sign $image_name $fedora_version $variant $destination="": install-cosign
    #!/usr/bin/bash
    set ${SET_X:+-x} -eou pipefail

    {{ get-names }}
    {{ build-missing }}

    digest="$({{ PODMAN }} inspect localhost/$image_name:$fedora_version --format '{{ ' {{ .Digest }} ' }}')"
    : "${destination:={{ IMAGE_REGISTRY }}}"
    cosign sign -y --key env://COSIGN_PRIVATE_KEY "$destination/$image_name@$digest"

# Generate SBOM
[group('CI')]
gen-sbom $image_name $fedora_version $variant:
    #!/usr/bin/bash
    set ${SET_X:+-x} -eou pipefail

    {{ get-names }}
    {{ build-missing }}
    {{ pull-retry }}

    # Get SYFT if needed
    SYFT_ID=""
    if ! command -v syft >/dev/null; then
        pull-retry "docker.io/anchore/syft:latest"
        SYFT_ID="$({{ PODMAN }} create docker.io/anchore/syft:latest)"
        {{ PODMAN }} cp "$SYFT_ID":/syft /tmp/syft.install
        {{ SUDOIF }} cp /tmp/syft.install /usr/local/bin/syft
        {{ SUDOIF }} rm -f /tmp/syft.install
        {{ PODMAN }} rm -f "$SYFT_ID" > /dev/null
        {{ PODMAN }} rmi "docker.io/anchore/syft:latest"
    fi

    # Enable Podman Socket if needed
    if [[ "$EUID" -eq "0" ]] && ! systemctl is-active -q podman.socket; then
        systemctl start podman.socket
        started_podman="true"
    elif ! systemctl is-active -q --user podman.socket; then
        systemctl start --user podman.socket
        started_podman="true"
    fi

    # Make SBOM
    OUTPUT_PATH="$(mktemp -d)/sbom.json"
    SYFT_PARALLELISM="$(( $(nproc) * 2 ))"
    syft "localhost/$image_name:$fedora_version" -o spdx-json="$OUTPUT_PATH" >&2

    # Cleanup
    if [[ "$EUID" -eq "0" && "${started_podman:-}" == "true" ]]; then
        systemctl stop podman.socket
    elif [[ "${started_podman:-}" == "true" ]]; then
        systemctl stop --user podman.socket
    fi

    # Output Path
    echo "$OUTPUT_PATH"

# Add SBOM attestation
[group('CI')]
sbom-attest $fedora_version $image_name $variant $destination="" $sbom="" $digest="": install-cosign
    #!/usr/bin/bash
    set ${SET_X:+-x} -eou pipefail

    {{ get-names }}
    {{ build-missing }}

    : "${destination:={{ IMAGE_REGISTRY }}}"
    : "${sbom:=$({{ just }} gen-sbom $fedora_version $image_name)}"
    : "${digest:=$({{ PODMAN }} inspect localhost/$image_name:$fedora_version --format '{{ ' {{ .Digest }} ' }}')}"

    # Attest with SBOM
    cd "$(dirname $sbom)" && \
    cosign attest -y \
       --predicate ./sbom.json \
       --type spdxjson \
       --key env://COSIGN_PRIVATE_KEY \
       "$destination/$image_name@$digest"
