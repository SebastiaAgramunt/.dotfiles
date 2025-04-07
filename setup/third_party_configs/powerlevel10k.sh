
set -euo pipefail

THIS_DIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
ROOT_DIR=$(dirname "${THIS_DIR}")
source ${ROOT_DIR}/utils.sh

# install powerlevel10k
echo "Cloning Powerlevel10k..."
if [ ! -d "$INSTALL_DIR/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$INSTALL_DIR/ohmyzsh/custom/themes/powerlevel10k"
fi
