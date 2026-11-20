# oh-my-zsh and powerlevel10k, cloned by setup/clones.sh
export ZSH="${XDG_DATA_HOME:-$HOME/.local/share}/ohmyzsh"
export ZSH_THEME="powerlevel10k/powerlevel10k"

# this activates the oh-my-zsh plugin
source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
