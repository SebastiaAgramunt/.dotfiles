DOCKER_DIR   := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
DOTFILES_DIR := $(abspath $(DOCKER_DIR)/../..)

USERNAME ?= $(shell whoami)
UID      ?= $(shell id -u)
GID      ?= $(shell id -g)

IMAGE_UBUNTU := dotfiles-ubuntu
IMAGE_MACOS  := dotfiles-macos

.PHONY: all build-ubuntu run-ubuntu build-macos run-macos clean help

all: help

help:
	@echo "Usage: make <target>"
	@echo ""
	@echo "  build-ubuntu   Build the Ubuntu test image"
	@echo "  run-ubuntu     Drop into a shell; dotfiles mounted, run bootstrap.sh to test"
	@echo "  build-macos    Build the Homebrew (macOS-equivalent) test image"
	@echo "  run-macos      Drop into a shell; run install_prerequisites/macos.sh to test"
	@echo "  clean          Remove both images"

build-ubuntu:
	docker build \
		--build-arg USERNAME=$(USERNAME) \
		--build-arg UID=$(UID) \
		--build-arg GID=$(GID) \
		-f $(DOCKER_DIR)Dockerfile.ubuntu \
		-t $(IMAGE_UBUNTU) \
		$(DOCKER_DIR)

run-ubuntu: build-ubuntu
	docker run --rm -it \
		-v $(DOTFILES_DIR):/home/$(USERNAME)/.dotfiles \
		$(IMAGE_UBUNTU)

build-macos:
	docker build \
		-f $(DOCKER_DIR)Dockerfile.macos \
		-t $(IMAGE_MACOS) \
		$(DOCKER_DIR)

run-macos: build-macos
	docker run --rm -it \
		-v $(DOTFILES_DIR):/home/linuxbrew/.dotfiles \
		$(IMAGE_MACOS)

clean:
	docker rmi -f $(IMAGE_UBUNTU) $(IMAGE_MACOS) 2>/dev/null || true
