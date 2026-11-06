# Nushell

[Nushell](https://nushell.sh) release binaries with my configuration, packaged so the images in my
[Docker ecosystem](https://github.com/bfren/docker) can copy Nushell in with one line.

- **Binaries:** the official release binaries from [Nushell's GitHub releases](https://github.com/nushell/nushell/releases)
  (musl for Alpine, glibc for Debian), checked against the release's `SHA256SUMS`.
- **Size:** executables are stripped with `llvm-strip` - official releases only remove debug information,
  so this saves 25-35%.
- **Plugins:** the release's `nu_plugin_*` executables are copied to the plugins directory.
- **Config:** [config.nu](config.nu), copied from the commit being built.

Each image contains:

| Path                             | Contents              |
| -------------------------------- | --------------------- |
| `/usr/bin/`                      | Nushell executables   |
| `/root/.config/nushell/`         | Nushell configuration |
| `/root/.config/nushell/plugins/` | Nushell plugins       |

## Matrix

| Nushell     | alpine  | bullseye | bookworm | trixie  |
| ----------- | :-----: | :------: | :------: | :-----: |
| **0.116.1** | &check; | &check;  | &check;  | &check; |

Every image is built for `linux/amd64`, `linux/arm64` and `linux/arm/v7`.

## Tags

Images are published to `quay.io/bfren-bin/nushell`:

| Tag                      | Example                   |
| ------------------------ | ------------------------- |
| `DISTRO`                 | `alpine`                  |
| `DISTRO-VERSION`         | `alpine-261106.2`         |
| `NUSHELL-DISTRO`         | `0.116.1-alpine`          |
| `NUSHELL-DISTRO-VERSION` | `0.116.1-alpine-261106.2` |

`VERSION` is the build date (`yymmdd`) in [VERSION](VERSION) - pin it to get exactly the same binaries and
configuration every time. Builds from any branch other than `main` add `-dev` to every tag. `DISTRO` and
`NUSHELL-DISTRO` move with each build.

## Adding a release

1. Update the `nushell` matrix in the [build workflow](.github/workflows/build.yml), the `NUSHELL_VERSION` default
   in [Dockerfile](Dockerfile) and the matrix above.
2. Set [VERSION](VERSION) to today's date (`yymmdd`, or `yymmdd.2`, `.3` and so on for another release that day).
3. Push the branch, which builds `-dev` tags to test with, then merge into `main`, which builds the release (it
   refuses to overwrite a tag that already exists).

## Usage

You can find live examples in my [Alpine](https://github.com/bfren/docker-alpine) and
[Debian](https://github.com/bfren/docker-debian) Docker images.

```Dockerfile
# load the Nushell build for your distribution
FROM quay.io/bfren-bin/nushell:0.116.1-alpine-261106.2 AS nushell

# use the same distribution
FROM alpine:3.24

# copy Nushell executables, configuration and plugins to /
COPY --from=nushell / /

# rest of Dockerfile
```

## Licence

The build scripts and configuration in this repository are released under the [MIT licence](https://mit.bfren.dev/2022).

Nushell is also licensed under the [MIT licence](https://github.com/nushell/nushell?tab=MIT-1-ov-file), which
covers the binaries in the published images.

## Copyright

> Copyright (c) 2023-2026 bfren (unless otherwise stated)
