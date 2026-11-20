# === bash/exports.sh ===
export EDITOR=nvim
export PATH="$HOME/bin:$PATH"
# tools installed by setup/tools.sh (Linux) and other user-level installers
export PATH="${XDG_BIN_HOME:-$HOME/.local/bin}:$PATH"
