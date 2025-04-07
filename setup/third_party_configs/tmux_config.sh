#!/bin/bash

## Tmux should be installed in the machine, this script only gets the configuration
## from a repository https://github.com/gpakosz/.tmux
## Basically it consist on a .tmux.conf and a .tmux.conf.local.

set -euo pipefail

THIS_DIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
ROOT_DIR=$(dirname "${THIS_DIR}")
source ${ROOT_DIR}/utils.sh

if [ ! -d "$INSTALL_DIR/tmux" ]; then
  git clone https://github.com/gpakosz/.tmux.git "$INSTALL_DIR/tmux"
fi

# create symlinks to dotfiles in this repo, then we will stow
cp ${INSTALL_DIR}/tmux/.tmux.conf ${ROOT_DIR}/tmux/.tmux.conf
cp ${INSTALL_DIR}/tmux/.tmux.conf.local ${ROOT_DIR}/tmux/.tmux.conf.local
