#!/bin/bash

THIS_DIR=$(dirname "$(realpath "$0")")
ROOT_DIR=$(dirname $(dirname ${THIS_DIR}))

# # Dockerfile name
DOCKERFILE=ubuntu
# DOCKERFILE=macos

build_image(){
    docker build -f ${THIS_DIR}/Dockerfile-${DOCKERFILE} \
                --build-arg USERNAME=$(whoami) \
                --build-arg UID=$(id -u) \
                --build-arg GID=$(id -g) \
                 -t ${DOCKERFILE}-image .
}

run_image(){
    docker run \
    -e RAM_SIZE=1G \
    -v ${ROOT_DIR}:/home/$(whoami)/.dotfiles \
    -it \
    ${DOCKERFILE}-image \
     /bin/bash
}

croak(){
    echo "[ERROR] $*" > /dev/stderr
    exit 1
}

main(){
    if [[ -z "$TASK" ]]; then
        croak "No TASK specified."
    fi
    echo "[INFO] running $TASK $*"
    $TASK "$@"
}

main "$@"

# TASK=build_image ./setup/Docker/build_run.sh
# TASK=run_image ./setup/Docker/build_run.sh
# cd .dotfiles