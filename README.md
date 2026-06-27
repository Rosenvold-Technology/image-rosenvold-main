# NOTICE 15 October 2025: 
The deprecated sway, budgie, and cosmic images have now been removed, see [#927](https://github.com/ublue-os/main/issues/927)

# Main

[![build-latest](https://github.com/ublue-os/main/actions/workflows/build-latest.yml/badge.svg)](https://github.com/ublue-os/main/actions/workflows/build-latest.yml)

A common main image for all other uBlue images, with minimal (but important) adjustments to Fedora. <3

Deprecation Notice: Universal Blue is trimming support for intermediate images (such as those built in main) which are not used in our project's final images (Aurora, Bazzite, Bluefin).

This repo builds a `core` image based on Fedora `base-atomic`, with Brave as
the browser (Firefox excluded), in two variants:

- **core** — standard build
- **core-nvidia** — adds the open nvidia drivers

It is intended as the base for desktop images (e.g. Hyprland) layered on top.

# Documentation

- [Main website](https://universal-blue.org)
- [Documentation](https://universal-blue.org/documentation.html)
- [Scope document](https://universal-blue.org/mission.html)
