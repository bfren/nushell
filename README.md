# Custom Nushell Builds

Build for Alpine, with (slightly) modified configuration based on default [config.nu](https://raw.githubusercontent.com/nushell/nushell/main/crates/nu-utils/src/sample_config/default_config.nu) and [env.nu](https://raw.githubusercontent.com/nushell/nushell/main/crates/nu-utils/src/sample_config/default_env.nu).

Creates a Docker image containing:

- `/usr/bin/` -> Nushell executable
- `/root/.config/nushell/` -> Nushell configuration
- `/root/.config/nushell/plugins/` -> Nushell plugins

Which means you can do this in a Dockerfile to install Nushell:

```Dockerfile
FROM ghcr.io/bfren/nushell:0.90.1 as nushell

FROM alpine as final
COPY --from=nushell / /
```
