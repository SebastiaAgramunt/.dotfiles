#!/usr/bin/env bash
# Clones third-party frameworks into ~/.local/share. Your own overrides for them
# live in this repo (vim/.vimrc, tmux/.tmux.conf.local, p10k/.p10k.zsh) and are stowed.
#
# Re-running pulls the latest version of each clone.
set -euo pipefail

THIS_DIR="$(dirname "$(realpath "$0")")"
source "${THIS_DIR}/utils.sh"

clone_or_pull() {
    local url="$1" dest="$2"
    if [[ -d "${dest}/.git" ]]; then
        echo "Updating ${dest}..."
        git -C "${dest}" pull --ff-only --quiet
    else
        echo "Cloning ${url} into ${dest}..."
        git clone --depth=1 "${url}" "${dest}"
    fi
}

mkdir -p "${DATA_DIR}"

# oh-my-zsh + powerlevel10k theme (loaded from zsh/.zsh/sources/ohmyzsh.sh)
clone_or_pull https://github.com/ohmyzsh/ohmyzsh.git "${DATA_DIR}/ohmyzsh"
clone_or_pull https://github.com/romkatv/powerlevel10k.git "${DATA_DIR}/ohmyzsh/custom/themes/powerlevel10k"

# pyenv (loaded from zsh/.zsh/sources/pyenv_conf.sh). Python versions are installed
# under ${DATA_DIR}/pyenv/versions, so don't delete this directory lightly.
clone_or_pull https://github.com/pyenv/pyenv.git "${DATA_DIR}/pyenv"

# awesome-vim (sourced from vim/.vimrc)
clone_or_pull https://github.com/amix/vimrc.git "${DATA_DIR}/awesome-vim"

# Oh my tmux! Upstream's install is a symlink ~/.tmux.conf -> its .tmux.conf, which
# then reads ~/.tmux.conf.local (stowed from tmux/).
clone_or_pull https://github.com/gpakosz/.tmux.git "${DATA_DIR}/tmux"
if [[ -e "${HOME}/.tmux.conf" && ! -L "${HOME}/.tmux.conf" ]]; then
    echo "⚠️  ${HOME}/.tmux.conf is a regular file, not replacing it with the Oh my tmux! symlink"
else
    ln -sfn "${DATA_DIR}/tmux/.tmux.conf" "${HOME}/.tmux.conf"
fi
