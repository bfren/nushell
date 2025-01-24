#!/bin/sh

set -eu

# build download URL
case "${DISTRO}" in
    alpine) LIBC="musl" ;;
    *) LIBC="gnu" ;;
esac
case "${TARGETPLATFORM}" in
    linux/amd64) ARCH="x86_64" ;;
    linux/arm/v7) ARCH="armv7" ; LIBC="${LIBC}eabihf" ;;
    linux/arm64) ARCH="aarch64" ;;
    *) echo "Unsupported target platform: ${TARGETPLATFORM}." && exit 1 ;;
esac

printf "%s" "${ARCH}" > ARCH
BASE=https://github.com/nushell/nushell/releases/download/0.101.0
FILE=nu-0.101.0-${ARCH}-unknown-linux-${LIBC}

# download and verify binary
wget ${BASE}/${FILE}.tar.gz
wget ${BASE}/SHA256SUMS
[ `sha256sum -c ./SHA256SUMS 2> /dev/null | grep "${FILE}.tar.gz" | tail -c 3` = "OK" ] || exit 1

# extract files and move to working directory
tar -xf ${FILE}.tar.gz
mv ${FILE}/* .

# cleanup
rm -rf ${FILE}*
