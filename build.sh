#!/bin/bash

set -euo pipefail

DISTROS=("alpine" "debian")
NUSHELL=${1}
PLATFORM=linux/amd64,linux/arm/v7,linux/arm64
REPO=ghcr.io/bfren/nushell

for DISTRO in "${DISTROS[*]}" ; do
    docker buildx build \
        --file ${DISTRO}.Dockerfile \
        --build-arg NUSHELL=${NUSHELL} \
        --platform ${PLATFORM} \
        --push \
        --tag ${REPO}:${DISTRO} \
        --tag ${REPO}:${NUSHELL}-${DISTRO} \
        .
done
