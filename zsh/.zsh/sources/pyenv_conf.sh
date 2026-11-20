# Set up pyenv, cloned by setup/clones.sh
export PYENV_ROOT="${XDG_DATA_HOME:-$HOME/.local/share}/pyenv"
export PATH=$PYENV_ROOT/bin:$PATH

# Initialize pyenv if available
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi
