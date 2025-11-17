#!/bin/bash

set -euo pipefail

# Variables
NUSHELL_VERSION=${1}
PLATFORM=linux/amd64,linux/arm64,linux/arm/v7
DISTROS="alpine bookworm trixie"
REPO=ghcr.io/bfren/nushell
VERSION=`cat ./VERSION`

build () {

    DISTRO=${1}
    PLATFORM=${2}

    docker buildx build \
        --file ./Dockerfile \
        --build-arg DISTRO=${DISTRO} \
        --build-arg NUSHELL_VERSION=${NUSHELL_VERSION} \
        --build-arg VERSION=${VERSION} \
        --platform ${PLATFORM} \
        --push \
        --tag ${REPO}:${DISTRO} \
        --tag ${REPO}:${DISTRO}-${VERSION} \
        --tag ${REPO}:${NUSHELL_VERSION}-${DISTRO} \
        --tag ${REPO}:${NUSHELL_VERSION}-${DISTRO}-${VERSION} \
        .
}

for DISTRO in ${DISTROS} ; do
    build ${DISTRO} ${PLATFORM}
done
