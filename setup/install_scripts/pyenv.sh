#!/bin/bash

set -euo pipefail

THIS_DIR=$(dirname "$(realpath "$0")")
source $(dirname ${THIS_DIR})/utils.sh

# if pyenv is already installed, skip
if [ -d "${INSTALL_DIR}/pyenv" ]; then
    echo "pyenv is already installed in ${INSTALL_DIR}/pyenv, skipping..."
    exit 0
fi
git clone https://github.com/pyenv/pyenv.git "${INSTALL_DIR}/pyenv"

mkdir -p "${INSTALL_DIR}/bin"
ln -sf "${INSTALL_DIR}/pyenv/bin/pyenv" "${INSTALL_DIR}/bin/pyenv"
