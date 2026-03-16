#!/usr/bin/env bash
set -euo pipefail

THIS_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$(dirname "${THIS_DIR}")/utils.sh"

BIN_DIR="${INSTALL_DIR}/bin"

if [[ -x "${BIN_DIR}/btm" ]]; then
    echo "bottom is already installed in ${BIN_DIR}/btm, skipping..."
    exit 0
fi

REPO="ClementTsang/bottom"
REPO_URL="https://github.com/${REPO}"
API_URL="https://api.github.com/repos/${REPO}"

TAG="$(curl -fsSL "${API_URL}/releases/latest" | grep '"tag_name"' | cut -d '"' -f 4)"
FILENAME="bottom_${ARCH}-${OS}.tar.gz"
URL="${REPO_URL}/releases/download/${TAG}/${FILENAME}"
TMP_FILE="/tmp/${FILENAME}"

echo "Downloading: ${URL}"

mkdir -p "${BIN_DIR}"
curl -fsSL -o "${TMP_FILE}" "${URL}"

TOOL_PATH="$(tar -tzf "${TMP_FILE}" | grep 'btm$' | head -n 1)"
if [[ -z "${TOOL_PATH}" ]]; then
    echo "Could not find btm inside ${TMP_FILE}"
    echo "Archive contents:"
    tar -tzf "${TMP_FILE}" | head -n 50
    exit 1
fi

TMP_EXTRACT_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_EXTRACT_DIR}" "${TMP_FILE}"' EXIT

tar -xzf "${TMP_FILE}" -C "${TMP_EXTRACT_DIR}"
install -m 0755 "${TMP_EXTRACT_DIR}/${TOOL_PATH}" "${BIN_DIR}/btm"

echo "✅ bottom is now available in ${BIN_DIR}/btm"
