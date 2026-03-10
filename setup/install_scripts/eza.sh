#!/bin/bash

set -euo pipefail

THIS_DIR=$(dirname "$(realpath "$0")")
source $(dirname ${THIS_DIR})/utils.sh

if [ -f "${INSTALL_DIR}/bin/eza" ]; then
    echo "eza is already installed in ${INSTALL_DIR}/bin/eza, skipping..."
    exit 0
fi

# Base GitHub repo URL and API
REPO="eza-community/eza"
REPO_URL="https://github.com/${REPO}"
API_URL="https://api.github.com/repos/${REPO}"

# Placeholder for the latest release tag for eza