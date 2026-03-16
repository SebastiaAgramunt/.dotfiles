#!/usr/bin/env bash
set -euo pipefail
set -x  # Print commands as they run

# Ensure the script is run as root
if [[ "$EUID" -ne 0 ]]; then
  echo "❌ Please run this script with sudo:"
  echo "   sudo $0"
  exit 1
fi

echo "=============================="
echo "Updating system"
echo "=============================="

apt-get update
apt-get upgrade -y

echo "=============================="
echo "Installing packages"
echo "=============================="

packages=(
    # Networking / downloads
    wget
    curl

    # Version control
    git

    # Development tools
    gcc
    make

    # Editor
    vim

    # Compression / archives
    xz-utils
    zip

    # Libraries
    libncurses-dev

    # CLI tools
    stow
    mosh
    git-delta
    bottom

    # Shell
    zsh
)

apt-get install -y "${packages[@]}"

echo "=============================="
echo "Installation complete"
echo "=============================="
