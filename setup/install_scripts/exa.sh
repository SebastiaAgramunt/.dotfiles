#!/bin/bash

set -euo pipefail

THIS_DIR=$(dirname "$(realpath "$0")")
source $(dirname ${THIS_DIR})/utils.sh

# Base GitHub repo URL and API
REPO="ogham/exa"
REPO_URL="https://github.com/${REPO}"
API_URL="https://api.github.com/repos/${REPO}"


# there's no gnu ripgrep in github repository yet, install musl for now
if [[ "${OS}" == "unknown-linux-gnu" ]]; then
    OS="linux"
fi

if [[ "${OS}" == "apple-darwin" ]]; then
    OS="macos"
fi

TAG=$(curl -s "${API_URL}/releases/latest" | grep '"tag_name"' | cut -d '"' -f 4)
FILENAME="exa-${OS}-${ARCH}-${TAG}.zip"
URL="${REPO_URL}/releases/download/${TAG}/${FILENAME}"
echo "Downloading: ${URL}"

mkdir -p ${DOTFILES_CUSTOM_INSTALL_DIR}
curl -L -o /tmp/${FILENAME} ${URL}
unzip -j /tmp/${FILENAME} 'bin/exa' -d ${DOTFILES_CUSTOM_INSTALL_DIR}
unzip -j  /tmp/${FILENAME} 'completions/*' -d ${DOTFILES_CUSTOM_INSTALL_DIR}/completions

echo "✅ exa is now available in ${DOTFILES_CUSTOM_INSTALL_DIR}"
