#!/bin/sh

N=0.86.0                                # Nushell version
P=linux/amd64,linux/arm/v7,linux/arm64  # Platforms to build
T=ghcr.io/bfren/nushell:${N}-alpine     # Tag to use

docker buildx build --build-arg NUSHELL=${N} --platform ${P} --tag ${T} --push .
