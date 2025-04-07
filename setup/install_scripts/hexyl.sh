#!/bin/bash
set -euo pipefail

THIS_DIR=$(dirname "$(realpath "$0")")
source $(dirname ${THIS_DIR})/utils.sh

# Base GitHub repo URL and API
REPO="sharkdp/hexyl"
REPO_URL="https://github.com/${REPO}"
API_URL="https://api.github.com/repos/${REPO}"

TAG=$(curl -s "${API_URL}/releases/latest" | grep '"tag_name"' | cut -d '"' -f 4)
FILENAME="hexyl-${TAG}-${ARCH}-${OS}.tar.gz"
URL="${REPO_URL}/releases/download/${TAG}/${FILENAME}"
echo "Downloading: ${URL}"

mkdir -p ${DOTFILES_CUSTOM_INSTALL_DIR}
cd /tmp && curl -sSLO "$URL"
HEXYL_PATH=$(tar -tzf /tmp/"$FILENAME" | grep '/hexyl$')
tar -xzf /tmp/"$FILENAME" -C "$DOTFILES_CUSTOM_INSTALL_DIR" --strip-components=1 "$HEXYL_PATH"
rm ${FILENAME}

echo "✅ hexyl is now available in ${DOTFILES_CUSTOM_INSTALL_DIR}"
