#!/bin/bash
#
# A script to install an RPM from the latest Github release for a project.
#
# ORG_PROJ is the pair of URL components for organization/projectName in Github URL
# example: https://github.com/wez/wezterm/releases
#   ORG_PROJ would be "wez/wezterm"
#
# FILTER is used if there are more than one RPMs which match our arch/noarch.rpm pattern
# example: wezterm builds a lot of rpms, but they are labeled by distro so we can filter
#   FILTER would be "fedora36" to get the RPM build for fedora36 OR "fedora" should get
#          the RPM build for fedora37 (or newest fedora build) due to a reverse sort

ORG_PROJ=${1}
SUFFIX=${2}
FILTER=${3}

usage() {
  echo "$0 ORG_PROJ SUFFIX [FILTER]"
  echo "    ORG_PROJ - organization/projectname"
  echo "    SUFFIX   - trailing part of rpm name: eg, x86_64rpm or noarch.rpm"
  echo "    FILTER   - optional extra filter to further limit rpm selection"

}

if [ -z ${ORG_PROJ} ]; then
  usage
  exit 1
fi

if [ -z ${SUFFIX} ]; then
  usage
  exit 2
fi

API="https://api.github.com/repos/${ORG_PROJ}/releases/latest"
RPM_URLS=$(curl -sL ${API} | jq -r '.assets[].browser_download_url' | grep -E "${SUFFIX}$" | grep "${FILTER}" |sort -r)
for URL in ${RPM_URLS}; do
  # WARNING: in case of multiple matches, this only installs the first (hopefully the newest, given the reverse sort)
  echo "execute: rpm-ostree install \"${URL}\""
  rpm-ostree install "${URL}"
  break
done
