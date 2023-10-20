# use target Alpine version as host
FROM alpine AS build
ARG NUSHELL=0.86.0

# install prerequisites
RUN apk add --no-cache \
    bash \
    cargo \
    libgit2-dev \
    openssl-dev \
    sqlite-dev

# download nushell source
WORKDIR /tmp
RUN wget https://github.com/nushell/nushell/archive/${NUSHELL}.tar.gz && \
    tar -xf ${NUSHELL}.tar.gz

# build and test nushell
WORKDIR /tmp/nushell-${NUSHELL}

RUN TARGET=$(rustc -vV | sed -n 's/host: //p') && \
    CONFIG=.cargo/config.toml && \
    echo "" >> ${CONFIG} && \
    echo "[target.${TARGET}]" >> ${CONFIG} && \
    echo "git2 = { rustc-link-lib = [\"git2\"] }" >> ${CONFIG} && \
    echo "rusqlite = { rustc-link-lib = [\"sqlite3\"] }" >> ${CONFIG}

RUN EXCLUDE="--exclude nu-cmd-dataframe" && \
    cargo fetch --locked && \
    cargo build --workspace --release --frozen ${EXCLUDE}

# move nushell binaries to publish directory
RUN mkdir -p /nu && \
    find target/release \
      -maxdepth 1 \
      -executable \
      -type f \
      -name "nu*" \
      -exec install -Dm755 '{}' -t /nu/ \;

ADD https://raw.githubusercontent.com/bfren/nushell/main/${NUSHELL}/config.nu /nu-config/config.nu
ADD https://raw.githubusercontent.com/bfren/nushell/main/${NUSHELL}/env.nu /nu-config/env.nu

# create blank image with only nushell binaries and configuration
FROM scratch as final
COPY --from=build /nu/ /usr/bin/
COPY --from=build /nu-config/ /root/.config/nushell/
