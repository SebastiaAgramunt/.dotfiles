#!/bin/bash

set -euo pipefail

THIS_DIR=$(dirname "$(realpath "$0")")
source $(dirname ${THIS_DIR})/utils.sh

git clone https://github.com/pyenv/pyenv.git ${INSTALL_DIR}/pyenv
