source "$HOME/.dotfiles/zsh/sources/aliases.sh"
source "$HOME/.dotfiles/zsh/sources/exports.sh"
source "$HOME/.dotfiles/zsh/sources/functions.sh"
source "$HOME/.dotfiles/zsh/sources/pyenv_conf.sh"
source "$HOME/.dotfiles/zsh/sources/ohmyzsh.sh"

# place in ~/.config/sh bash scripts that you want to source
# but may contain private info like aliases to ssh machines
mkdir -p ~/.config/sh

# this is to prevent a warning if no files are found
if [ -n "$ZSH_VERSION" ]; then
  setopt local_options nullglob
fi

# source all custom configs
for f in ~/.config/sh/*.sh; do
  [ -f "$f" ] && source "$f"
done