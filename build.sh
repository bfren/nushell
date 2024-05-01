#!/bin/bash

set -euo pipefail

N=${1}                          # Nushell version
P=linux/amd64,linux/arm64       # Platforms to build
T=ghcr.io/bfren/nushell:${N}    # Tag to use

docker buildx build --build-arg NUSHELL=${N} --platform ${P} --tag ${T} --push .
