#!/bin/bash
set -euo pipefail

THIS_DIR=$(dirname "$(realpath "$0")")
source $(dirname ${THIS_DIR})/utils.sh

if [ -f "${INSTALL_DIR}/bin/hexyl" ]; then
    echo "hexyl is already installed in ${INSTALL_DIR}/bin/hexyl, skipping..."
    exit 0
fi

# Base GitHub repo URL and API
REPO="sharkdp/hexyl"
REPO_URL="https://github.com/${REPO}"
API_URL="https://api.github.com/repos/${REPO}"

TAG="$(curl -fsSL "${API_URL}/releases/latest" | grep '"tag_name"' | cut -d '"' -f 4)"
FILENAME="hexyl-${TAG}-${ARCH}-${OS}.tar.gz"
URL="${REPO_URL}/releases/download/${TAG}/${FILENAME}"
TMP_FILE="/tmp/${FILENAME}"

echo "Downloading: ${URL}"

mkdir -p "${DOTFILES_CUSTOM_INSTALL_DIR}"
curl -fsSL -o "${TMP_FILE}" "${URL}"
HEXYL_PATH="$(tar -tzf "${TMP_FILE}" | grep '/hexyl$' | head -n 1)"
tar -xzf "${TMP_FILE}" -C "${DOTFILES_CUSTOM_INSTALL_DIR}" --strip-components=1 "${HEXYL_PATH}"
rm -f "${TMP_FILE}"

echo "✅ hexyl is now available in ${DOTFILES_CUSTOM_INSTALL_DIR}"
