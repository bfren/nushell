#!/bin/bash

set -euo pipefail

# Variables
NUSHELL_VERSION=${1}.${2}
ALPINE_PLATFORM=linux/amd64,linux/arm64,linux/arm/v7
DEBIAN="bullseye bookworm"
DEBIAN_PLATFORM=linux/amd64,linux/arm64
REPO=ghcr.io/bfren/nushell
VERSION=`cat ./VERSION`

build () {

    DOCKERFILE=${1}
    DISTRO=${2}
    PLATFORM=${3}

    docker buildx build \
        --file ${DOCKERFILE} \
        --build-arg DISTRO=${DISTRO} \
        --build-arg VERSION=${VERSION} \
        --platform ${PLATFORM} \
        --push \
        --tag ${REPO}:${DISTRO} \
        --tag ${REPO}:${DISTRO}-${VERSION} \
        --tag ${REPO}:${NUSHELL_VERSION}-${DISTRO} \
        --tag ${REPO}:${NUSHELL_VERSION}-${DISTRO}-${VERSION} \
        .
}

# Alpine
build "alpine.Dockerfile" "alpine" ${ALPINE_PLATFORM}

# Debian
for DISTRO in ${DEBIAN} ; do
    build "debian.Dockerfile" ${DISTRO} ${DEBIAN_PLATFORM}
done
