#!/usr/bin/env bash
set -euo pipefail

THIS_DIR="$(dirname "$(realpath "$0")")"
source "$(dirname "${THIS_DIR}")/utils.sh"

BIN_DIR="${INSTALL_DIR}/bin"

if [[ -f "${BIN_DIR}/duf" ]]; then
    echo "duf is already installed in ${BIN_DIR}/duf, skipping..."
    exit 0
fi

REPO="muesli/duf"
REPO_URL="https://github.com/${REPO}"
API_URL="https://api.github.com/repos/${REPO}"

TAG="$(curl -fsSL "${API_URL}/releases/latest" | grep '"tag_name"' | cut -d '"' -f 4)"
VERSION="${TAG#v}"

# Map architecture to duf naming
case "${ARCH}" in
    x86_64)
        DUF_ARCH="amd64"
        ;;
    aarch64|arm64)
        DUF_ARCH="arm64"
        ;;
    *)
        echo "Unsupported architecture for duf: ${ARCH}"
        exit 1
        ;;
esac

# Map OS to duf naming
case "${OS}" in
    unknown-linux-gnu|unknown-linux-musl)
        DUF_OS="linux"
        ;;
    apple-darwin)
        DUF_OS="darwin"
        ;;
    *)
        echo "Unsupported OS for duf: ${OS}"
        exit 1
        ;;
esac

FILENAME="duf_${VERSION}_${DUF_OS}_${DUF_ARCH}.tar.gz"
URL="${REPO_URL}/releases/download/${TAG}/${FILENAME}"
TMP_FILE="/tmp/${FILENAME}"

echo "Downloading: ${URL}"

mkdir -p "${BIN_DIR}"
curl -fsSL -o "${TMP_FILE}" "${URL}"

TOOL_PATH="$(tar -tzf "${TMP_FILE}" | awk -F/ '$NF=="duf" {print; exit}')"
tar -xzf "${TMP_FILE}" -C "${BIN_DIR}" "${TOOL_PATH}"
rm -f "${TMP_FILE}"

echo "✅ duf is now available in ${BIN_DIR}/duf"
