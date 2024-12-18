FROM bfren/alpine AS build
ARG MINOR=0.100
ARG REVISION=0
ARG VERSION=0.100.0

# install build prerequisites
RUN apk add --no-cache \
    cargo@edgemain \
    libgit2-dev \
    openssl-dev \
    sqlite-dev

# get source
WORKDIR /tmp
ADD https://github.com/nushell/nushell/archive/${VERSION}.tar.gz .
RUN tar -xf ${VERSION}.tar.gz

# build
WORKDIR /tmp/nushell-${VERSION}
COPY ./build.sh .
RUN chmod +x build.sh && ./build.sh

# move binaries to publish directories
COPY ./move.sh .
RUN chmod +x move.sh && ./move.sh

# add configuration files for this version
ADD https://raw.githubusercontent.com/bfren/nushell/main/${MINOR}.x/${VERSION}/config.nu /nu-config/config.nu
ADD https://raw.githubusercontent.com/bfren/nushell/main/${MINOR}.x/${VERSION}/env.nu /nu-config/env.nu

# create blank image with only binaries and configuration
FROM scratch as final
COPY --from=build /nu/ /usr/bin/
COPY --from=build /nu-config/ /root/.config/nushell/
COPY --from=build /nu-plugins/ /root/.config/nushell/plugins/
