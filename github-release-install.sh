#!/bin/bash
#
# A script to install an RPM from the latest Github release for a project.
#
# ORG_PROJ is the pair of URL components for organization/projectName in Github URL
# example: https://github.com/wez/wezterm/releases
#   ORG_PROJ would be "wez/wezterm"
#
# ARCH_FILTER is used to select the specific RPM. Typically this can just be the arch
#   such as 'x86_64' but sometimes a specific filter is required when multiple match.
# example: wezterm builds RPMs for different distros so we must be more specific.
#   ARCH_FILTER of "fedora37.x86_64" gets the x86_64 RPM build for fedora37


ORG_PROJ=${1}
ARCH_FILTER=${2}

usage() {
  echo "$0 ORG_PROJ ARCH_FILTER"
  echo "    ORG_PROJ    - organization/projectname"
  echo "    ARCH_FILTER - optional extra filter to further limit rpm selection"

}

if [ -z ${ORG_PROJ} ]; then
  usage
  exit 1
fi

if [ -z ${ARCH_FILTER} ]; then
  usage
  exit 2
fi

set -ouex pipefail

API="https://api.github.com/repos/${ORG_PROJ}/releases/latest"
RPM_URLS=$(curl --retry 3 --retry-delay 0 --retry-all-errors -sL ${API} \
  | jq \
    -r \
    --arg arch_filter "${ARCH_FILTER}" \
    '.assets | sort_by(.created_at) | reverse | .[] | select(.name|test($arch_filter)) | select (.name|test("rpm$")) | .browser_download_url')
for URL in ${RPM_URLS}; do
  # WARNING: in case of multiple matches, this only installs the first matched release
  echo "execute: rpm-ostree install \"${URL}\""
  rpm-ostree install "${URL}"
  break
done
