#!/usr/bin/env bash
set -euo pipefail

THIS_DIR="$(dirname "$(realpath "$0")")"
source "$(dirname "${THIS_DIR}")/utils.sh"

BIN_DIR="${INSTALL_DIR}/bin"

if [[ -f "${BIN_DIR}/rg" ]]; then
    echo "ripgrep is already installed in ${BIN_DIR}/rg, skipping..."
    exit 0
fi

REPO="BurntSushi/ripgrep"
REPO_URL="https://github.com/${REPO}"
API_URL="https://api.github.com/repos/${REPO}"

TAG="$(curl -fsSL "${API_URL}/releases/latest" | grep '"tag_name"' | cut -d '"' -f 4)"

# Keep the detected OS by default.
RIPGREP_OS="${OS}"

# Only override when you know that exact asset exists.
# For ripgrep 15.1.0:
# - aarch64 uses unknown-linux-gnu
# - x86_64 has unknown-linux-musl available
if [[ "${ARCH}" == "x86_64" && "${OS}" == "unknown-linux-gnu" ]]; then
    RIPGREP_OS="unknown-linux-musl"
fi

FILENAME="ripgrep-${TAG}-${ARCH}-${RIPGREP_OS}.tar.gz"
URL="${REPO_URL}/releases/download/${TAG}/${FILENAME}"
TMP_FILE="/tmp/${FILENAME}"

echo "Downloading: ${URL}"

mkdir -p "${BIN_DIR}"
curl -fsSL -o "${TMP_FILE}" "${URL}"

TOOL_PATH="$(tar -tzf "${TMP_FILE}" | grep '/rg$' | head -n 1)"

if [[ -z "${TOOL_PATH}" ]]; then
    echo "Could not find rg inside ${TMP_FILE}"
    exit 1
fi

tar -xzf "${TMP_FILE}" \
    -C "${BIN_DIR}" \
    --strip-components=1 \
    "${TOOL_PATH}"

rm -f "${TMP_FILE}"

echo "✅ ripgrep is now available in ${BIN_DIR}/rg"
