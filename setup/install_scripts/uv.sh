#!/bin/bash
set -euo pipefail

THIS_DIR=$(dirname "$(realpath "$0")")
source $(dirname ${THIS_DIR})/utils.sh

if [ -f "${INSTALL_DIR}/bin/uv" ]; then
    echo "uv is already installed in ${INSTALL_DIR}/bin/uv, skipping..."
    exit 0
fi

# Base GitHub repo URL and API
REPO="astral-sh/uv"
REPO_URL="https://github.com/${REPO}"
API_URL="https://api.github.com/repos/${REPO}"

TAG="$(curl -fsSL "${API_URL}/releases/latest" | grep '"tag_name"' | cut -d '"' -f 4)"
FILENAME="uv-${ARCH}-${OS}.tar.gz"
URL="${REPO_URL}/releases/download/${TAG}/${FILENAME}"
TMP_FILE="/tmp/${FILENAME}"

echo "Downloading: ${URL}"

mkdir -p "${DOTFILES_CUSTOM_INSTALL_DIR}"
curl -fsSL -o "${TMP_FILE}" "${URL}"
tar -xzf "${TMP_FILE}" --strip-components=1 -C "${DOTFILES_CUSTOM_INSTALL_DIR}"
rm -f "${TMP_FILE}"

echo "✅ uv is now available in ${DOTFILES_CUSTOM_INSTALL_DIR}"
