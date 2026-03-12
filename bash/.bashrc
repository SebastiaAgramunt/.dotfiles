source "$HOME/.dotfiles/zsh/.zsh/sources/aliases.sh"
source "$HOME/.dotfiles/zsh/.zsh/sources/exports.sh"
source "$HOME/.dotfiles/zsh/.zsh/sources/functions.sh"
source "$HOME/.dotfiles/zsh/.zsh/sources/pyenv_conf.sh"
source "$HOME/.dotfiles/zsh/.zsh/sources/ohmyzsh.sh"

# source all custom configs
for f in ~/.config/sh/*.sh; do
  [ -f "$f" ] && source "$f"
done
