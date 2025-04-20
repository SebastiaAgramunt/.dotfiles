#!/bin/bash

set -e

THIS_DIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
ROOT_DIR=$(dirname "${THIS_DIR}")
source ${THIS_DIR}/utils.sh

# # install packages system-wide (if you are root)
# if [[ "${OS}" == "unknown-linux-gnu" ]]; then
#     ${THIS_DIR}/install_prerequisites/linux.sh
# fi

# for this one let's assume you are root
if [[ "${OS}" == "apple-darwin" ]]; then
    ${THIS_DIR}/install_prerequisites/macos.sh
fi

# install all the tools in build/bin
echo $DOTFILES_CUSTOM_INSTALL_DIR
for script in ${THIS_DIR}/install_scripts/*.sh; do
  if [ -x "$script" ]; then
    echo "Running $script ..."
    "$script"
  fi
done

# clone repositories for tmux config and copy default config to tmux dir
${THIS_DIR}/third_party_configs/tmux_config.sh

# clone oh-my-zsh repository and power10k repository we will apply config in zsh
${THIS_DIR}/third_party_configs/oh-my-zsh.sh

# clone powerlevel10k in oh-my-zsh custom directory
# to configure after this run:
# p10k config
# alternatively stow p10k to apply my custom changes
${THIS_DIR}/third_party_configs/powerlevel10k.sh