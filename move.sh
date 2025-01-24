#!/bin/sh

set -eu

# move nu executables
mkdir -p /nu 
mv nu* /nu/ 

# move nu plugins
mkdir -p /nu-plugins
find /nu \
    -maxdepth 1 \
    -executable \
    -type f \
    -name "nu_plugin*" \
    -exec install -Dm755 '{}' -t /nu-plugins/ \;
