#!/usr/bin/env bash
set -euo pipefail

# Support both root and non-root users
SUDO=""
if [[ "$EUID" -ne 0 ]]; then
    if ! command -v sudo &>/dev/null; then
        echo "Error: not running as root and sudo is not available."
        exit 1
    fi
    SUDO="sudo"
fi

echo "=============================="
echo "Updating system"
echo "=============================="

${SUDO} apt-get update
${SUDO} apt-get upgrade -y

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
    tmux

    # Shell
    zsh
)

${SUDO} apt-get install -y "${packages[@]}"

echo "=============================="
echo "Installation complete"
echo "=============================="
