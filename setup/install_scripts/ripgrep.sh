#!/bin/bash
set -euo pipefail

THIS_DIR=$(dirname "$(realpath "$0")")
source $(dirname ${THIS_DIR})/utils.sh

# Base GitHub repo URL and API
REPO="BurntSushi/ripgrep"
REPO_URL="https://github.com/${REPO}"
API_URL="https://api.github.com/repos/${REPO}"


# there's no gnu ripgrep in github repository yet, install musl for now
if [[ "${OS}" == "unknown-linux-gnu" ]]; then
    OS="unknown-linux-musl"
fi

TAG=$(curl -s "${API_URL}/releases/latest" | grep '"tag_name"' | cut -d '"' -f 4)
FILENAME="ripgrep-${TAG}-${ARCH}-${OS}.tar.gz"
URL="${REPO_URL}/releases/download/${TAG}/${FILENAME}"
echo "Downloading: ${URL}"

mkdir -p ${DOTFILES_CUSTOM_INSTALL_DIR}
cd /tmp && curl -sSLO "$URL"
TOOL_PATH=$(tar -tzf /tmp/"$FILENAME" | grep '/rg$')
tar -xzf /tmp/"$FILENAME" -C "$DOTFILES_CUSTOM_INSTALL_DIR" --strip-components=1 "$TOOL_PATH"
rm ${FILENAME}

echo "✅ ripgrep is now available in ${DOTFILES_CUSTOM_INSTALL_DIR}"
