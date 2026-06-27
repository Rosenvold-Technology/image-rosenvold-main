#!/usr/bin/bash

set -eoux pipefail

IMPORTANT_PACKAGES=(
    systemd
    pipewire
    wireplumber
)

for package in "${IMPORTANT_PACKAGES[@]}"; do
    rpm -q "$package" >/dev/null || { echo "Missing package: $package... Exiting"; exit 1 ; }
done