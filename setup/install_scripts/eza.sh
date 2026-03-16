#!/usr/bin/env bash
set -euo pipefail

THIS_DIR="$(dirname "$(realpath "$0")")"
source "$(dirname "${THIS_DIR}")/utils.sh"

BIN_DIR="${INSTALL_DIR}/bin"

if [[ -f "${BIN_DIR}/eza" ]]; then
    echo "eza is already installed in ${BIN_DIR}/eza, skipping..."
    exit 0
fi

REPO="eza-community/eza"
REPO_URL="https://github.com/${REPO}"
API_URL="https://api.github.com/repos/${REPO}"

TAG="$(curl -fsSL "${API_URL}/releases/latest" | grep '"tag_name"' | cut -d '"' -f 4)"

EZA_OS="${OS}"
FILENAME="eza_${ARCH}-${EZA_OS}.tar.gz"
URL="${REPO_URL}/releases/download/${TAG}/${FILENAME}"
TMP_FILE="/tmp/${FILENAME}"

# binaries not available on MacOS, skipping this part...
if [[ "${OS}" == "apple-darwin" ]]; then
    echo "macOS detected (${ARCH}-${OS})."
    echo "Skipping eza GitHub tarball install because no apple-darwin release asset is published."
    echo "Install with: brew install eza"
    exit 0
fi
echo "Downloading: ${URL}"

mkdir -p "${BIN_DIR}"
curl -fsSL -o "${TMP_FILE}" "${URL}"

TOOL_PATH="$(tar -tzf "${TMP_FILE}" | grep '/eza$' | head -n 1)"

if [[ -z "${TOOL_PATH}" ]]; then
    echo "Could not find eza inside ${TMP_FILE}"
    exit 1
fi

tar -xzf "${TMP_FILE}" \
    -C "${BIN_DIR}" \
    --strip-components=1 \
    "${TOOL_PATH}"

rm -f "${TMP_FILE}"

echo "✅ eza is now available in ${BIN_DIR}/eza"
