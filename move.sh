#!/bin/sh

set -eu

# move nu executables
mkdir -p /nu 
mv nu* /nu/ 

# strip symbols from executables - official releases only remove debug info, so this saves 25-35%
# (llvm-strip works with binaries for any architecture, as this stage runs on the build platform)
# using + rather than \; so the build fails if llvm-strip fails
find /nu \
    -maxdepth 1 \
    -type f \
    -name "nu*" \
    -exec llvm-strip '{}' +

# move nu plugins
mkdir -p /nu-plugins
find /nu \
    -maxdepth 1 \
    -executable \
    -type f \
    -name "nu_plugin*" \
    -exec install -Dm755 '{}' -t /nu-plugins/ \;
