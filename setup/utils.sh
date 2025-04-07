#!/bin/bash
set -euo pipefail

THIS_DIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
ROOT_DIR=$(dirname "${THIS_DIR}")

DOTFILES_CUSTOM_INSTALL_DIR="${ROOT_DIR}/build/bin"
INSTALL_DIR="${ROOT_DIR}/build"

# Detect platform architecture
ARCH=$(uname -m)
OS_NAME=$(uname -s | tr '[:upper:]' '[:lower:]')

case "$ARCH" in
    x86_64) ARCH="x86_64" ;;
    aarch64 | arm64) ARCH="aarch64" ;;
    *) echo "Unsupported architecture: $ARCH" && exit 1 ;;
esac

# Detect libc (musl or glibc)
detect_libc() {
    if ldd --version 2>&1 | grep -qi musl; then
        echo "musl"
    else
        echo "gnu"
    fi
}

case "$OS_NAME" in
    linux)
        LIBC=$(detect_libc)
        OS="unknown-linux-${LIBC}"
        ;;
    darwin)
        OS="apple-darwin"
        ;;
    *)
        echo "Unsupported OS: $OS_NAME" && exit 1
        ;;
esac