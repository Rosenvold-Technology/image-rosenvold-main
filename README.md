# NOTICE 15 October 2025: 
The deprecated sway, budgie, and cosmic images have now been removed, see [#927](https://github.com/ublue-os/main/issues/927)

# Main

[![build-latest](https://github.com/ublue-os/main/actions/workflows/build-latest.yml/badge.svg)](https://github.com/ublue-os/main/actions/workflows/build-latest.yml)

A common main image for all other uBlue images, with minimal (but important) adjustments to Fedora. <3

Deprecation Notice: Universal Blue is trimming support for intermediate images (such as those built in main) which are not used in our project's final images (Aurora, Bazzite, Bluefin).

This repo builds two core images, both based on Fedora `base-atomic`:

- **core-server** — headless base, no browser
- **core-desktop** — core-server plus the Brave browser (Firefox excluded), intended as the base for desktop images (e.g. Hyprland) layered on top

Each is built in `main` and `nvidia` variants.

# Documentation

- [Main website](https://universal-blue.org)
- [Documentation](https://universal-blue.org/documentation.html)
- [Scope document](https://universal-blue.org/mission.html)
