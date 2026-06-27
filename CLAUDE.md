# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A fork of [ublue-os/main](https://github.com/ublue-os/main) that builds a custom
bootc/OSTree container image (`core`, and `core-nvidia`) based on Fedora
`base-atomic`. The image is published to `ghcr.io/rosenvold-technology/image-rosenvold-main`.
It is **not** an application — there is no app to run; the "build" produces a
bootable OS container image. It is meant as the base for desktop images (e.g.
Hyprland) layered on top, and ships Brave as the browser (Firefox excluded).

Key divergences from upstream ublue-os/main worth knowing:
- Only a single `core` image (variants `main` and `nvidia`), not the full
  upstream matrix of desktop images.
- Brave replaces Firefox (see the `/usr/lib/opt` workaround in `install.sh`).
- Output registry is `ghcr.io/rosenvold-technology` (`org`/`repo` in the Justfile),
  but prebuilt akmods are still pulled from `ghcr.io/ublue-os` (`akmods_registry`).
  Removing that upstream dependency is tracked in issue #1.

## Common commands

All orchestration is in the `Justfile`. `just` requires **version 1.51.0** — just
≥ 1.52 changed semantics (`which()`/`require()`/`||` behind a setting) and breaks
this Justfile with "requires set lists". CI pins this version.

```bash
just                          # list all recipes
just build core 44 main       # build image:  <image_name> <fedora_version> <variant>
just build core 44 nvidia     # nvidia variant
just build                    # defaults: core / 44 / main
just run core 44 main         # run the built image interactively (builds if missing)
just check                    # check Justfile syntax (just --fmt --check)
just fix                      # auto-format the Justfile
```

`build-container` is the heart of it: it reads pinned digests from
`image-versions.yaml`, **verifies** the upstream akmods + base images with cosign,
generates tags, pulls the inputs, then runs `podman build` against `Containerfile`.

There is no test suite. Build-time validation happens via `build_files/check-build.sh`
(asserts systemd/pipewire/wireplumber present) and `bootc container lint` at the end
of the Containerfile. `just secureboot` verifies the kernel signature of a built image.

## Architecture and build flow

The build is a single `RUN` in `Containerfile` that bind-mounts the build context
and executes the `build_files/` scripts in order. Understanding the sequence
matters because each script assumes state set up by the previous one:

1. **`install.sh`** — the bulk of the work, runs always:
   - rsyncs `sys_files/` onto root (systemd units, tmpfiles, dracut config).
   - Enables ublue COPRs + negativo17 `fedora-multimedia` repo (priority 90).
   - Replaces the stock Fedora kernel with the **signed akmods kernel** (erases
     `kernel*`, installs from `/tmp/kernel-rpms`, then `versionlock`s it). Note
     the kernel-install shims (`05-rpmostree.install`/`50-dracut.install` swapped
     for no-ops) that work around a dracut failure during kernel install.
   - `distro-sync` overrides mesa/intel media stack from negativo17, versionlocked.
   - Installs Brave via the `/usr/lib/opt` relocation hack (atomic images symlink
     `/opt` → `/var/opt`, which isn't in the image; payload is moved to
     `/usr/lib/opt/brave.com` and recreated at boot via tmpfiles).
   - Calls `packages.sh`, then installs cosign from GitHub releases.
2. **`nvidia-install.sh`** — only when `BUILD_NVIDIA=Y` (variant `nvidia`).
   Installs negativo17 nvidia driver + kmod matching the akmods kernel, forces
   driver load in dracut, enables CDI. **32-bit (.i686) nvidia libs are
   intentionally omitted** due to upstream version skew (see the comment there).
3. **`initramfs.sh`** — regenerates the initramfs with dracut (`--add ostree`).
4. **`post-install.sh`** — enables update timers, font fixes, removes COPRs,
   cleans `/var`, `/boot`, `/usr/etc`, runs `check-build.sh`, then
   `ostree container commit`.

`packages.sh` installs/removes packages declared in **`packages.json`**. That JSON
is keyed by `all` / `<IMAGE_NAME>` / `<FEDORA_MAJOR_VERSION>` with `include` and
`exclude` sections — edit `packages.json` to change shipped packages, not the
shell scripts.

### Pinned inputs — `image-versions.yaml`

The base image, akmods, and akmods-nvidia-open are pinned by **digest** here. This
file is the single source of truth for upstream versions and is what
[Renovate](.github/renovate.json5) updates via PRs. The Justfile reads these
digests with `yq` and passes them as `--build-arg`s; CI's `check-build-required`
job compares old vs. new digests to decide whether a rebuild is needed.

When bumping Fedora versions or upstream images, update `image-versions.yaml`
(and the `KERNEL_VERSION`/`FEDORA_MAJOR_VERSION` defaults in `Containerfile` and
the `latest`/`beta` tags in `Justfile`) together.

### CI

- `.github/workflows/build-latest.yml` / `build-beta.yml` — entry points, matrix
  over `core` × {`main`, `nvidia`}, call the reusable workflow.
- `.github/workflows/reusable-build.yml` — `check-build-required` (digest diff
  gate) → `build_ublue` (just build → secureboot check → push to GHCR → cosign
  sign). SBOM generation steps exist but are currently disabled (`if: false`).
- PRs build but do not push/sign (`github.event_name != 'pull_request'` guards).
- `release-please.yml` handles releases; commits follow Conventional Commits
  (`feat:`, `fix:`, `ci:` …) — `.github/semantic.yml` enforces PR titles.

### Signing

`cosign.pub`/`cosign.key` are this fork's signing keypair (the private key is
gitignored except the committed `cosign.key` placeholder — real key is the
`SIGNING_SECRET` CI secret). `verify-container` in the Justfile verifies
**upstream** inputs against ublue-os's public key; `cosign-sign` signs **this
fork's** output image.

## Conventions

- Build logic goes in `build_files/*.sh` (all `set -ouex pipefail`); package
  changes go in `packages.json`; system files to ship go in `sys_files/`
  (mirrors the target filesystem layout, rsynced to `/`).
- The repo is meant to track upstream ublue-os/main; prefer minimal, well-commented
  divergences (existing comments explain *why* for each fork-specific hack — keep
  that pattern).
