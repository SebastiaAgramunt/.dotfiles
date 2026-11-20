#!/bin/bash

set -e

THIS_DIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
ROOT_DIR=$(dirname "${THIS_DIR}")
source "${THIS_DIR}/utils.sh"

# install system packages (uses sudo internally if not root).
# On macOS this also installs the CLI tools from the Brewfile.
if [[ "${OS}" == *"linux"* ]]; then
    "${THIS_DIR}/install_prerequisites/linux.sh"

    # CLI tools from GitHub releases into ~/.local/bin
    "${THIS_DIR}/tools.sh"
fi

if [[ "${OS}" == "apple-darwin" ]]; then
    "${THIS_DIR}/install_prerequisites/macos.sh"
fi

# oh-my-zsh, powerlevel10k, awesome-vim and Oh my tmux! into ~/.local/share
"${THIS_DIR}/clones.sh"

# create ~/.config/sh where you should place all private stuff.
mkdir -p ~/.config/sh

# useful for private ssh aliases, not tracked in git.
touch ~/.config/sh/servers.sh
