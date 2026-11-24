#!/bin/bash

set -euo pipefail

# Variables
NUSHELL_VERSION=${1}
PLATFORM=linux/amd64,linux/arm64,linux/arm/v7
# keep tags and distros in step with .github/workflows/build.yml
DISTROS="alpine bookworm trixie"
REPO=quay.io/bfren-bin/nushell
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
        --tag ${REPO}:${NUSHELL_VERSION}-${DISTRO} \
        --tag ${REPO}:${NUSHELL_VERSION}-${DISTRO}-${VERSION} \
        .
}

for DISTRO in ${DISTROS} ; do
    build ${DISTRO} ${PLATFORM}
done
