#!/bin/bash

set -e

THIS_DIR=$(dirname "$(realpath "$0")")

if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew update && brew upgrade && brew cleanup

brew install git \
             zsh \
             neovim \
             tmux \
             mosh \
             htop \
             stow

# for python version management
brew install openssl@3 \
             readline \
             xz \
             sqlite3
