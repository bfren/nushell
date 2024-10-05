FROM bfren/alpine AS build
ARG NUSHELL=0.98.0

# install build prerequisites
RUN apk add --no-cache \
    cargo@edgemain \
    libgit2-dev \
    openssl-dev \
    sqlite-dev

# get source
WORKDIR /tmp
ADD https://github.com/nushell/nushell/archive/${NUSHELL}.tar.gz .
RUN tar -xf ${NUSHELL}.tar.gz

# build
WORKDIR /tmp/nushell-${NUSHELL}
COPY ./build.sh .
RUN chmod +x build.sh && ./build.sh

# move binaries to publish directories
COPY ./move.sh .
RUN chmod +x move.sh && ./move.sh

# add configuration files for this version
ADD https://raw.githubusercontent.com/bfren/nushell/main/${NUSHELL}/config.nu /nu-config/config.nu
ADD https://raw.githubusercontent.com/bfren/nushell/main/${NUSHELL}/env.nu /nu-config/env.nu

# create blank image with only binaries and configuration
FROM scratch as final
COPY --from=build /nu/ /usr/bin/
COPY --from=build /nu-config/ /root/.config/nushell/
COPY --from=build /nu-plugins/ /root/.config/nushell/plugins/
