THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
ROOT_DIR=$(dirname $(dirname "${THIS_DIR}"))

# Set up pyenv from dotfiles
export PYENV_ROOT=${ROOT_DIR}/build/pyenv
export PATH=$PYENV_ROOT/bin:$PATH

# Initialize pyenv if available
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi
