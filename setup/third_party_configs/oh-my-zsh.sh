#!/bin/bash

set -euo pipefail

THIS_DIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
ROOT_DIR=$(dirname "${THIS_DIR}")
source ${ROOT_DIR}/utils.sh

# install oh-my-zsh
echo "Cloning Oh My Zsh..."
if [ ! -d "$INSTALL_DIR/ohmyzsh" ]; then
  git clone https://github.com/ohmyzsh/ohmyzsh.git "$INSTALL_DIR/ohmyzsh"
fi
