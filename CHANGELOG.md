# Changelog

## 1.0.0 (2026-06-27)


### Features

* single core image (core / core-nvidia); fix nvidia i686 conflict ([19225e9](https://github.com/Rosenvold-Technology/image-rosenvold-main/commit/19225e9e1b7faae64257e4510a380955d7f65871))
* split base into core-server and core-desktop images ([55c5229](https://github.com/Rosenvold-Technology/image-rosenvold-main/commit/55c5229ca3d52dceba663b41053dd1213776c04e))


### Bug Fixes

* Correct missed mention of old email ([#2077](https://github.com/Rosenvold-Technology/image-rosenvold-main/issues/2077)) ([86caf6a](https://github.com/Rosenvold-Technology/image-rosenvold-main/commit/86caf6a48991843b9b697b169bef1438013b104c))
* **Justfile:** revert verify-container default key to ublue-os ([54679ed](https://github.com/Rosenvold-Technology/image-rosenvold-main/commit/54679edc6736ec762b998aecc5f371cc4da061f6))
* **Justfile:** separate output registry from upstream akmods registry ([fbc1e7f](https://github.com/Rosenvold-Technology/image-rosenvold-main/commit/fbc1e7fbb5df720ebe5bb9bb05336fa62fc3b4ad))
* **Justfile:** use if/else instead of || expression operator ([718a007](https://github.com/Rosenvold-Technology/image-rosenvold-main/commit/718a007f8f1426b843d8ea66927ee512f136970a))
* Name the repo we're actually using for Nvidia drivers in 2026 ([#2078](https://github.com/Rosenvold-Technology/image-rosenvold-main/issues/2078)) ([a62c988](https://github.com/Rosenvold-Technology/image-rosenvold-main/commit/a62c9881869ade5820710f3bd077528aad2442aa))
* pin rpm-ostree to 2025.12-1 ([#2171](https://github.com/Rosenvold-Technology/image-rosenvold-main/issues/2171)) ([72abdb5](https://github.com/Rosenvold-Technology/image-rosenvold-main/commit/72abdb5157d90b84c3c2c157e37e6defdb90a5ea))
* ship Brave via /usr/lib/opt for atomic; drop deprecated release-please input ([5dca7b0](https://github.com/Rosenvold-Technology/image-rosenvold-main/commit/5dca7b0af9c7be93ecddbfafb8c1f72e812a2240))
