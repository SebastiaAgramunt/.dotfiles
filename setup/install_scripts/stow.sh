#!/bin/bash

set -euo pipefail

THIS_DIR=$(dirname "$(realpath "$0")")
source "$(dirname "${THIS_DIR}")/utils.sh"

VERSION=2.4.1

if [[ "${OS}" == *"linux"* ]]; then
    if [[ -f "${INSTALL_DIR}/bin/stow" ]]; then
        echo "stow is already installed in ${INSTALL_DIR}/bin/stow, skipping..."
        exit 0
    fi

    BUILD_DIR="${INSTALL_DIR}"
    mkdir -p "${BUILD_DIR}/stow" "${BUILD_DIR}/bin"

    STOW_SRC="/tmp/stow-${VERSION}"
    curl -fsSL "https://ftp.gnu.org/gnu/stow/stow-${VERSION}.tar.gz" -o "${STOW_SRC}.tar.gz"
    tar -xzf "${STOW_SRC}.tar.gz" -C /tmp
    rm -f "${STOW_SRC}.tar.gz"

    (
        cd "${STOW_SRC}"
        ./configure --prefix="${BUILD_DIR}/stow"
        make
        make install
    )

    rm -rf "${STOW_SRC}"

    ln -sf "${BUILD_DIR}/stow/bin/stow" "${BUILD_DIR}/bin/stow"
    ln -sf "${BUILD_DIR}/stow/bin/chkstow" "${BUILD_DIR}/bin/chkstow"

    echo "✅ stow is now available in ${BUILD_DIR}/bin/stow"
fi
