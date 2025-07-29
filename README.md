# Macos

```bash
git clone git@github.com:SebastiaAgramunt/.dotfiles.git
rm -rf ${HOME}/.dotfiles/build
~/.dotfiles/setup/bootstrap.sh
```

Then stow the config files you need, e.g. for zsh:

```bash
# Linux
 cd ~/.dotfiles && ./build/bin/stow --adopt zsh

 # Macos
 cd ~/.dotfiles && stow --adopt zsh
```

Finally source `~/.zshrc`

```bash
cd $HOME && source ~/.zshrc
```