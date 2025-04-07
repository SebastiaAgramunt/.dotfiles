 #!/bin/bash
# set -euo pipefail
set -vex

THIS_DIR=$(dirname "$(realpath "$0")")
source $(dirname ${THIS_DIR})/utils.sh

# Base GitHub repo URL and API
REPO="sharkdp/bat"
REPO_URL="https://github.com/${REPO}"
API_URL="https://api.github.com/repos/${REPO}"

# Get the latest release tag
TAG=$(curl -s "${API_URL}/releases/latest" | grep '"tag_name"' | cut -d '"' -f 4)
FILENAME="bat-${TAG}-${ARCH}-${OS}.tar.gz"
URL="${REPO_URL}/releases/download/${TAG}/${FILENAME}"
echo "Downloading: ${URL}"

# Create install directory
mkdir -p "${DOTFILES_CUSTOM_INSTALL_DIR}"

# Download and install
cd /tmp && curl -sSLO "$URL"
BAT_PATH=$(tar -tzf /tmp/"$FILENAME" | grep '/bat$')
tar -xzf /tmp/"$FILENAME" -C "$DOTFILES_CUSTOM_INSTALL_DIR" --strip-components=1 "$BAT_PATH"


rm "${FILENAME}"
chmod +x "${DOTFILES_CUSTOM_INSTALL_DIR}/bat"

echo "✅ bat is now available in ${DOTFILES_CUSTOM_INSTALL_DIR}"