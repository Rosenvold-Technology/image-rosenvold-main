# image-rosenvold-main

[![ublue latest](https://github.com/rosenvold-technology/image-rosenvold-main/actions/workflows/build-latest.yml/badge.svg)](https://github.com/rosenvold-technology/image-rosenvold-main/actions/workflows/build-latest.yml)

A custom [bootc](https://bootc-dev.github.io/bootc/) / OSTree base image built on
Fedora `base-atomic`, derived from [Universal Blue's `main`](https://github.com/ublue-os/main).
It ships sensible multimedia, hardware, and tooling defaults with **Brave** as the
browser (Firefox is excluded), and is intended as the foundation for desktop
images (e.g. Hyprland) layered on top.

Images are published to `ghcr.io/rosenvold-technology/image-rosenvold-main` and
signed with [cosign](https://github.com/sigstore/cosign).

## Variants

| Image         | Description                                  |
| ------------- | -------------------------------------------- |
| `core`        | Standard build                               |
| `core-nvidia` | Adds the open NVIDIA drivers (akmods + kmod) |

## What's included

- Signed Universal Blue kernel + akmods (kernel modules), version-locked.
- negativo17 multimedia stack (mesa, Intel media drivers, ffmpeg, libheif…) at
  higher priority than stock Fedora, for fuller codec support.
- Brave browser (auto-updates with the system via its RPM repo).
- Flathub configured out of the box (Fedora's Flatpak remote removed).
- Hardware/CLI tooling: distrobox, htop, nvtop, tmux, vim, fzf, wireguard-tools,
  smartmontools, nvme-cli, YubiKey/U2F support, and more (see `packages.json`).
- Automatic staged updates (`rpm-ostreed-automatic`, Flatpak update timers).

## Usage

### Rebase an existing atomic Fedora system

> ⚠️ Rebasing replaces your OS image. Read it through first.

```bash
# Rebase to the unsigned image to fetch the signing keys, then reboot
sudo bootc switch --enforce-container-sigpolicy \
  ghcr.io/rosenvold-technology/core:latest
systemctl reboot
```

For the NVIDIA variant, use `core-nvidia:latest`.

### Verify image signatures

```bash
cosign verify --key cosign.pub \
  ghcr.io/rosenvold-technology/core:latest
```

## Building locally

Builds are orchestrated with [`just`](https://github.com/casey/just) and
[`podman`](https://podman.io/). **`just` must be version 1.51.0** — newer releases
break this Justfile.

```bash
just                       # list all recipes
just build core 44 main    # build:  <image_name> <fedora_version> <variant>
just build core 44 nvidia  # nvidia variant
just run core 44 main      # run the built image in an interactive shell
```

The build pulls and cosign-verifies pinned upstream inputs (base image + akmods)
from the digests in [`image-versions.yaml`](image-versions.yaml), then builds
[`Containerfile`](Containerfile), which runs the scripts in
[`build_files/`](build_files/).

## Repository layout

| Path                   | Purpose                                                      |
| ---------------------- | ----------------------------------------------------------- |
| `Containerfile`        | Image definition; runs the build scripts in order           |
| `Justfile`             | Build/run/sign/push orchestration                           |
| `build_files/`         | Shell scripts executed during the build                     |
| `packages.json`        | Declarative package include/exclude lists                   |
| `sys_files/`           | Files copied onto the image root (systemd units, tmpfiles…) |
| `image-versions.yaml`  | Pinned upstream image digests (managed by Renovate)         |
| `cosign.pub`           | Public key for verifying this image's signatures            |

See [`CLAUDE.md`](CLAUDE.md) for a detailed walkthrough of the build flow.

## Acknowledgements

Built on the excellent work of [Universal Blue](https://universal-blue.org). See
their [documentation](https://universal-blue.org/documentation.html) and
[mission](https://universal-blue.org/mission.html).

## License

[Apache-2.0](LICENSE)
