#!/bin/bash

set -e

THIS_DIR=$(dirname "$(realpath "$0")")

if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew update && brew upgrade && brew cleanup

# the very basics
brew install git \
             zsh \
             tmux \
             mosh

# some utils that I wish I had binaries for, need to
# install using brew on macOS.
brew install htop \
             eza \
             git-delta \
             stow
