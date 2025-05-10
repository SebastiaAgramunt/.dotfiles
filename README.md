# Macos

```bash
git clone git@github.com:SebastiaAgramunt/.dotfiles.git
rm -rf ${HOME}/.dotfiles/build
~/.dotfiles/setup/bootstrap.sh
```

Then stow the config files you need, e.g. for bash:

```bash
# Linux
 ./build/bin/stow --adopt bash

 # Macos
 stow --adopt bash
```
