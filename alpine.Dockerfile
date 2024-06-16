FROM alpine AS build
ARG NUSHELL=0.94.2

# install build prerequisites
RUN apk add --no-cache \
    bash \
    cargo \
    libgit2-dev \
    openssl-dev \
    sqlite-dev

# get source
WORKDIR /tmp
RUN wget https://github.com/nushell/nushell/archive/${NUSHELL}.tar.gz && \
    tar -xf ${NUSHELL}.tar.gz

# build
WORKDIR /tmp/nushell-${NUSHELL}
RUN TARGET=$(rustc -vV | sed -n 's/host: //p') && \
    CONFIG=.cargo/config.toml && \
    echo "" >> ${CONFIG} && \
    echo "[target.${TARGET}]" >> ${CONFIG} && \
    echo "git2 = { rustc-link-lib = [\"git2\"] }" >> ${CONFIG} && \
    echo "rusqlite = { rustc-link-lib = [\"sqlite3\"] }" >> ${CONFIG}
RUN EXCLUDE="--exclude nu-cmd-extra --exclude nu_plugin_gstat --exclude nu_plugin_polars" && \
    cargo fetch --locked && \
    cargo build --workspace --release --frozen ${EXCLUDE}

# move binaries to publish directories
RUN mkdir -p /nu && \
    cp target/release/nu /nu/ && \
    mkdir -p /nu-plugins && \
    find target/release \
      -maxdepth 1 \
      -executable \
      -type f \
      -name "nu_plugin*" \
      -exec install -Dm755 '{}' -t /nu-plugins/ \;

# add configuration files for this version
ADD https://raw.githubusercontent.com/bfren/nushell/main/${NUSHELL}/config.nu /nu-config/config.nu
ADD https://raw.githubusercontent.com/bfren/nushell/main/${NUSHELL}/env.nu /nu-config/env.nu

# create blank image with only binaries and configuration
FROM scratch as final
COPY --from=build /nu/ /usr/bin/
COPY --from=build /nu-config/ /root/.config/nushell/
COPY --from=build /nu-plugins/ /root/.config/nushell/plugins/
