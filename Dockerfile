FROM --platform=${BUILDPLATFORM} alpine AS build
ARG TARGETPLATFORM
ARG DISTRO=alpine
ARG NUSHELL_VERSION=0.112.1
ARG VERSION=260421

WORKDIR /tmp

# download binaries
COPY ./download.sh .
RUN chmod +x download.sh && ./download.sh

# move binaries to publish directories
COPY ./move.sh .
RUN chmod +x move.sh && ./move.sh

# add configuration file for this version
ADD https://raw.githubusercontent.com/bfren/nushell/refs/tags/v${VERSION}/config.nu /nu-config/config.nu

# create blank image with only binaries and configuration
FROM scratch AS final
COPY --from=build /nu/ /usr/bin/
COPY --from=build /nu-config/ /root/.config/nushell/
COPY --from=build /nu-plugins/ /root/.config/nushell/plugins/

LABEL org.opencontainers.image.description="Nushell with custom configuration."
LABEL org.opencontainers.image.source="https://github.com/nushell/nushell"
