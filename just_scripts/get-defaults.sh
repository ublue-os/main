#!/usr/bin/bash
if [[ -z "${image}" ]]; then
    image=${default_image}
fi

if [[ -z "${version}" ]]; then
    version=${latest}
elif [[ ${version} == "latest" ]]; then
    version=${latest}
elif [[ ${version} == "gts" ]]; then
    version=${gts}
fi

valid_images=(
    silverblue
    kinoite
    sericea
    onyx
    base
    lazurite
    vauxite
)
image=${image,,}
if [[ ${image} == "mate" ]]; then
    echo "Mate not supported..."
    exit 1
elif [[ ! ${valid_images[*]} =~ ${image} ]]; then
    echo "Invalid image..."
    exit 1
fi