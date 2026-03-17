# My Dotfiles

A collection of tools and dotfile configurations for my day to day work / personal projects.


# Install

```bash
git clone git@github.com:SebastiaAgramunt/.dotfiles.git
rm -rf ${HOME}/.dotfiles/build
```

## MacOS

```bash
~/.dotfiles/setup/bootstrap.sh
```

Then stow the files:

```bash
cd ~/.dotfiles
stow --adopt zsh
stow --adopt vim
stow --adopt git
stow --adopt tmux
```

Finally source `~/.zshrc` to apply the changes

```bash
source ~/.zshrc
```

In current version you will be prompted by `p10k` to configure your shell UI.

## Linux

Need to be a sudoer to run the script

```bash
~/.dotfiles/setup/bootstrap.sh
```

if not, ask your system administrator to install the tools listed. Stowing works the same in Linux.

```bash
cd ~/.dotfiles
STOW_EXE=~/.dotfiles/build/bin/stow
$STOW_EXE --adopt bash

# if you have installed the following, also stow the configs
$STOW_EXE --adopt vim
$STOW_EXE --adopt git
$STOW_EXE --adopt tmux
```

## Un-stow

```bash
cd ~/.dotfiles
stow -D zsh
stow -D bash
stow -D vim
stow -D git
stow -D tmux
```
