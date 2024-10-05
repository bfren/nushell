#!/bin/sh

set -eu

# create config.toml file
TARGET=$(rustc -vV | sed -n 's/host: //p')
CONFIG=.cargo/config.toml
echo "" >> ${CONFIG}
echo "[target.${TARGET}]" >> ${CONFIG}
echo "git2 = { rustc-link-lib = [\"git2\"] }" >> ${CONFIG}
echo "rusqlite = { rustc-link-lib = [\"sqlite3\"] }" >> ${CONFIG}

# build excluding unrequired features
EXCLUDE="--exclude nu-cmd-extra --exclude nu_plugin_custom_values --exclude nu_plugin_gstat --exclude nu_plugin_polars"
cargo fetch --locked
cargo build --workspace --release --frozen ${EXCLUDE}
