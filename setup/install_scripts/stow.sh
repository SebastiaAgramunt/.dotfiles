#!/bin/bash

#!/usr/bin/env bash
set -euo pipefail

THIS_DIR=$(dirname "$(realpath "$0")")
source $(dirname ${THIS_DIR})/utils.sh

if [[ "${OS}" == "unknown-linux-gnu" ]]; then
    # make build temporary directory
    BUILD_DIR="$(mktemp -d)"
    echo $BUILD_DIR
    cd "$BUILD_DIR"

    # Download and extract Stow in temporary directory
    curl -LO https://ftp.gnu.org/gnu/stow/stow-2.3.1.tar.gz
    tar -xzf stow-2.3.1.tar.gz
    cd stow-2.3.1

    # configure and install
    ./configure --prefix=$BUILD_DIR
    make
    make install

    # copy just the binary
    cp $BUILD_DIR/bin/stow ${DOTFILES_CUSTOM_INSTALL_DIR}

    # Clean up
    rm -rf "$BUILD_DIR"
elif [[ "${OS}" == "apple-darwin" ]]; then
    brew install stow
fi

# Confirm installation
echo "✅ Installed GNU Stow to: $DOTFILES_CUSTOM_INSTALL_DIR"
