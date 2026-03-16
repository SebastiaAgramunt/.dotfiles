source "$HOME/.dotfiles/zsh/.zsh/sources/aliases.sh"
source "$HOME/.dotfiles/zsh/.zsh/sources/exports.sh"
source "$HOME/.dotfiles/zsh/.zsh/sources/functions.sh"
source "$HOME/.dotfiles/zsh/.zsh/sources/pyenv_conf.sh"
# source "$HOME/.dotfiles/zsh/.zsh/sources/ohmyzsh.sh"

# this is to prevent a warning if no files are found
if [ -n "$ZSH_VERSION" ]; then
  setopt local_options nullglob
fi

# source all custom configs
for f in ~/.config/sh/*.sh; do
  [ -f "$f" ] && source "$f"
done

# set vi to use in command line
set -o vi
