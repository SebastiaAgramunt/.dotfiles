# Macos

```bash
git clone git@github.com:SebastiaAgramunt/.dotfiles.git
rm -rf ${HOME}/.dotfiles/build
~/.dotfiles/setup/bootstrap.sh
```

Then stow the files:

```bash
cd ~/.dotfiles
stow --adopt zsh
stow --adopt vim
stow --adopt git
```

Finally source `~/.zshrc` to apply the changes

```bash
source ~/.zshrc
```
In current version you will be prompted by `p10k` to configure your shell UI.

# Un-stow

```bash
cd ~/.dotfiles
stow -D zsh
stow -D vim
stow -D git
```
