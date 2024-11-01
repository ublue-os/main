#!/bin/sh

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

# Helper function to parse packages
get_packages() {
  local type="$1"
  jq -r "[(.all.${type} | (.all, select(.\"$IMAGE_NAME\" != null).\"$IMAGE_NAME\")[]), \
           (select(.\"$FEDORA_MAJOR_VERSION\" != null).\"$FEDORA_MAJOR_VERSION\".${type} | (.all, select(.\"$IMAGE_NAME\" != null).\"$IMAGE_NAME\")[])] \
           | sort | unique[]" /ctx/packages.json
}

# Get package lists
INCLUDED_PACKAGES=($(get_packages "include"))
EXCLUDED_PACKAGES=($(get_packages "exclude"))

# Filter out only installed packages from the exclusion list
if [[ "${#EXCLUDED_PACKAGES[@]}" -gt 0 ]]; then
    EXCLUDED_PACKAGES=($(rpm -qa --queryformat='%{NAME} ' ${EXCLUDED_PACKAGES[@]}))
fi

# Run rpm-ostree with necessary installs and removals
if [[ "${#INCLUDED_PACKAGES[@]}" -gt 0 || "${#EXCLUDED_PACKAGES[@]}" -gt 0 ]]; then
    rpm-ostree override remove \
        ${EXCLUDED_PACKAGES[@]} \
        $(printf -- "--install=%s " ${INCLUDED_PACKAGES[@]})
else
    echo "No packages to install or remove."
fi

# Check if excluded packages are still present due to dependencies
EXCLUDED_PACKAGES=($(get_packages "exclude"))
if [[ "${#EXCLUDED_PACKAGES[@]}" -gt 0 ]]; then
    EXCLUDED_PACKAGES=($(rpm -qa --queryformat='%{NAME} ' ${EXCLUDED_PACKAGES[@]}))
fi

# Remove any remaining excluded packages
if [[ "${#EXCLUDED_PACKAGES[@]}" -gt 0 ]]; then
    rpm-ostree override remove \
        ${EXCLUDED_PACKAGES[@]}
fi
