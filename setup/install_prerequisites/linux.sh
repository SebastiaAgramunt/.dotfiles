#!/usr/bin/env bash

set -euo pipefail
set -x  # Print commands as they run

echo "Updating..."
apt-get update
apt-get upgrade -y

echo "Installing Packages..."
# wget: download files
apt-get install -y wget

# git: version control
apt-get install -y git

# curl: HTTP client
apt-get install -y curl

# vim: file editing
apt-get install -y vim

# gcc: C compiler
apt-get install -y gcc

# make: build tool
apt-get install -y make

# xz-utils: for .tar.xz extraction
apt-get install -y xz-utils

# libncurses-dev: required for zsh
apt-get install -y libncurses-dev

# zip: compression tool
apt-get install -y zip

# stow: dotfile manager
apt-get install -y stow

# zsh
apt-get install -y zsh