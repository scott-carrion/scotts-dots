#!/usr/bin/env bash
set -euo pipefail

if [[ "$EUID" -ne 0 ]]; then
    echo "[$0] This script must be run as root" 2>&1
    exit 1
fi

echo "[$0] Installing required host packages"
DEBIAN_FRONTEND=noninteractive apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y \
    podman \
    distrobox \
    crun \
    flatpak

echo "[$0] Pre-creating sdbox home directory"
mkdir -p /home/sdbox
chown -R $(id -u):$(id -g) /home/sdbox
