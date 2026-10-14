# Custom Nushell Config

Default builds of [Nushell](https://nushell.sh) with some custom config applied.

Creates a Docker image containing:

- `/usr/bin/` -> Nushell executable
- `/root/.config/nushell/` -> Nushell configuration
- `/root/.config/nushell/plugins/` -> Nushell plugins

Which means you can do this in a Dockerfile to install Nushell:

```Dockerfile
FROM quay.io/bfren/nushell:0.116.1-alpine AS nushell

FROM alpine AS final
COPY --from=nushell / /
```

## Licence

The build scripts in this repository are released under the [MIT licence](https://mit.bfren.dev/2022).

Nushell is also licensed under the [MIT LIence](https://github.com/nushell/nushell?tab=MIT-1-ov-file).

## Copyright

> Copyright (c) 2023-2026 bfren (unless otherwise stated)
