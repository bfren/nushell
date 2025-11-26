# Custom Nushell Config

Default builds of Nushell with some custom config applied.

Creates a Docker image containing:

- `/usr/bin/` -> Nushell executable
- `/root/.config/nushell/` -> Nushell configuration
- `/root/.config/nushell/plugins/` -> Nushell plugins

Which means you can do this in a Dockerfile to install Nushell:

```Dockerfile
FROM quay.io/bfren/nushell:0.108.0-alpine as nushell

FROM alpine as final
COPY --from=nushell / /
```

## Licence

> MIT

## Copyright

> Copyright (c) 2023-2025 bfren (unless otherwise stated)
