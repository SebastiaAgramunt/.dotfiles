THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
ROOT_DIR=$(dirname $(dirname "${THIS_DIR}"))

OHMYZSH_PATH=${ROOT_DIR}/build/ohmyzsh

export ZSH="$OHMYZSH_PATH"
export ZSH_THEME="powerlevel10k/powerlevel10k"

# this activates the oh-my-zsh plugin
source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
