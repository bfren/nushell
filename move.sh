#!/bin/sh

set -eu

# move nu executable
mkdir -p /nu 
mv target/release/nu /nu/ 

# move nu plugins
mkdir -p /nu-plugins
find target/release \
    -maxdepth 1 \
    -executable \
    -type f \
    -name "nu_plugin*" \
    -exec install -Dm755 '{}' -t /nu-plugins/ \;
