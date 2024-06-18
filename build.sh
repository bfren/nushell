#!/bin/bash

set -euo pipefail

DISTROS="alpine bullseye bookworm"
NUSHELL=${1}
PLATFORM=linux/amd64,linux/arm64
REPO=ghcr.io/bfren/nushell

for DISTRO in ${DISTROS} ; do

    # get correct Dockerfile
    DOCKERFILE=${DISTRO}.Dockerfile
    if [ ! -f ${DOCKERFILE} ] ; then DOCKERFILE=debian.Dockerfile ; fi

    # build and push image
    docker buildx build \
        --file ${DOCKERFILE} \
        --build-arg DISTRO=${DISTRO} \
        --build-arg NUSHELL=${NUSHELL} \
        --platform ${PLATFORM} \
        --push \
        --tag ${REPO}:${DISTRO} \
        --tag ${REPO}:${NUSHELL}-${DISTRO} \
        .

done
