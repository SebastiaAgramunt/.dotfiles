#!/bin/bash

set -euo pipefail

THIS_DIR=$(dirname "$(realpath "$0")")
source $(dirname ${THIS_DIR})/utils.sh

if [ -f "${INSTALL_DIR}/bin/csvlens" ]; then
    echo "csvlens is already installed in ${INSTALL_DIR}/bin/csvlens, skipping..."
    exit 0
fi

# Base GitHub repo URL and API
REPO="YS-L/csvlens"
REPO_URL="https://github.com/${REPO}"
API_URL="https://api.github.com/repos/${REPO}"

TAG=$(curl -s "${API_URL}/releases/latest" | grep '"tag_name"' | cut -d '"' -f 4)
FILENAME="csvlens-${ARCH}-${OS}.tar.xz"
URL="${REPO_URL}/releases/download/${TAG}/${FILENAME}"
echo "Downloading: ${URL}"

mkdir -p ${DOTFILES_CUSTOM_INSTALL_DIR}

cd /tmp && curl -sSLO "$URL"
CSVLENS_PATH=$(tar -tJf /tmp/"$FILENAME" | grep '/csvlens$')
tar -xJf /tmp/"$FILENAME" -C "$DOTFILES_CUSTOM_INSTALL_DIR" --strip-components=1 "$CSVLENS_PATH"
rm ${FILENAME}

echo "✅ csvlens is now available in ${DOTFILES_CUSTOM_INSTALL_DIR}"
