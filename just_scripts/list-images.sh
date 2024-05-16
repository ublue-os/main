#!/usr/bin/bash
set -euo pipefail
container_mgr=(
    docker
    podman
    podman-remote
)
git_branches=($(git branch --format="%(refname:short)"))
for i in "${container_mgr[@]}"; do
    if [[ $(command -v "$i") ]]; then
        echo "Container Manager: ${i}"
        for j in "${git_branches[@]}"; do 
            ID=$(${i} images --filter "reference=localhost/*-build:${gts}-${j}" --filter "reference=localhost/*-build:${latest}-${j}" --format "{{.ID}}")
            if [[ -n "$ID" ]]; then
                ${i} images --filter "reference=localhost/*-build:${gts}-${j}" --filter "reference=localhost/*-build:${latest}-${j}"
            fi
        done
    fi
done
