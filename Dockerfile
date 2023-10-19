ARG ALPINE=3.18

# use target Alpine version as host
FROM alpine:${ALPINE} AS build

ARG NUSHELL=0.86.0
ARG PUBLISH=/nu

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
RUN TARGET=$(rustc -vV | sed -n 's/host: //p') && 
    EXCLUDE="--exclude nu-cmd-dataframe" && \
    cat >> .cargo/config.toml <<EOF
        [target.${TARGET}]
        git2 = { rustc-link-lib = ["git2"] }
        rusqlite = { rustc-link-lib = ["sqlite3"] }
    EOF && \
    cargo fetch --locked && \
    cargo build --workspace --release --frozen ${EXCLUDE} && \
    cargo test --workspace --frozen ${EXCLUDE}

# move nushell binaries to publish directory
RUN mkdir -p ${INSTALL} && \
    find target/release \
      -maxdepth 1 \
      -executable \
      -type f \
      -name "nu*" \
      -exec install -Dm755 '{}' -t ${PUBLISH}/ \;

# create blank image with only nushell binaries
FROM scratch as final
COPY --from=build ${PUBLISH} /usr/bin
