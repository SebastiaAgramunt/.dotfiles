#!/bin/bash

set -euo pipefail

THIS_DIR=$(dirname "$(realpath "$0")")
source $(dirname ${THIS_DIR})/utils.sh

VERSION=2.4.1
if [[ "${OS}" == "unknown-linux-gnu" ]]; then
    # make build temporary directory
    BUILD_DIR=$INSTALL_DIR
    mkdir -p ${BUILD_DIR}/stow
    mkdir -p ${BUILD_DIR}/bin
    cd "$BUILD_DIR"/stow

    # Download and extract Stow in temporary directory
    curl -LO https://ftp.gnu.org/gnu/stow/stow-${VERSION}.tar.gz
    tar -xzf stow-${VERSION}.tar.gz
    cd stow-${VERSION}

    # configure and install
    ./configure --prefix=$BUILD_DIR/stow
    make
    make install

    rm -rf stow-${VERSION}.tar.gz

    ln -s ${BUILD_DIR}/stow/bin/stow ${BUILD_DIR}/bin/stow
    ln -s ${BUILD_DIR}/stow/bin/chkstow ${BUILD_DIR}/bin/chkstow

elif [[ "${OS}" == "apple-darwin" ]]; then
    brew install stow
fi
