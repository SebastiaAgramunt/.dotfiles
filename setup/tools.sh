#!/usr/bin/env bash
# Installs CLI tools from GitHub releases into ~/.local/bin (Linux).
# On macOS the same tools come from setup/Brewfile instead.
#
# Usage: tools.sh            install every tool missing from ~/.local/bin
#        tools.sh rg fd      install only these (by binary name), even if present
set -euo pipefail

THIS_DIR="$(dirname "$(realpath "$0")")"
source "${THIS_DIR}/utils.sh"

# repo | asset name template | binaries to install (comma separated)
#
# Template placeholders:
#   {tag}       release tag, e.g. v10.2.0
#   {version}   tag without the leading "v"
#   {arch}      x86_64 | aarch64
#   {os}        unknown-linux-gnu | unknown-linux-musl | apple-darwin
#   {static_os} like {os}, but prefers the static musl build on x86_64 Linux
#   {goarch}    amd64 | arm64 (Go-style naming)
#   {goos}      linux | darwin
TOOLS=(
    "sharkdp/bat|bat-{tag}-{arch}-{os}.tar.gz|bat"
    "ClementTsang/bottom|bottom_{arch}-{os}.tar.gz|btm"
    "YS-L/csvlens|csvlens-{arch}-{os}.tar.xz|csvlens"
    "muesli/duf|duf_{version}_{goos}_{goarch}.tar.gz|duf"
    "eza-community/eza|eza_{arch}-{os}.tar.gz|eza"
    "sharkdp/fd|fd-{tag}-{arch}-{static_os}.tar.gz|fd"
    "sharkdp/hexyl|hexyl-{tag}-{arch}-{os}.tar.gz|hexyl"
    "sharkdp/hyperfine|hyperfine-{tag}-{arch}-{os}.tar.gz|hyperfine"
    "lsd-rs/lsd|lsd-{tag}-{arch}-{os}.tar.gz|lsd"
    "BurntSushi/ripgrep|ripgrep-{tag}-{arch}-{static_os}.tar.gz|rg"
    "astral-sh/uv|uv-{arch}-{os}.tar.gz|uv,uvx"
)

STATIC_OS="${OS}"
if [[ "${ARCH}" == "x86_64" && "${OS}" == "unknown-linux-gnu" ]]; then
    STATIC_OS="unknown-linux-musl"
fi

case "${ARCH}" in
    x86_64) GOARCH="amd64" ;;
    aarch64) GOARCH="arm64" ;;
esac

case "${OS}" in
    apple-darwin) GOOS="darwin" ;;
    *) GOOS="linux" ;;
esac

latest_tag() {
    curl -fsSL "https://api.github.com/repos/$1/releases/latest" | grep '"tag_name"' | cut -d '"' -f 4
}

install_tool() {
    local repo="$1" template="$2" binaries="$3"

    local tag version asset
    tag="$(latest_tag "${repo}")"
    version="${tag#v}"

    asset="${template//\{tag\}/${tag}}"
    asset="${asset//\{version\}/${version}}"
    asset="${asset//\{arch\}/${ARCH}}"
    asset="${asset//\{static_os\}/${STATIC_OS}}"
    asset="${asset//\{os\}/${OS}}"
    asset="${asset//\{goarch\}/${GOARCH}}"
    asset="${asset//\{goos\}/${GOOS}}"

    local url="https://github.com/${repo}/releases/download/${tag}/${asset}"
    local tmp
    tmp="$(mktemp -d)"

    echo "Downloading: ${url}"
    curl -fsSL -o "${tmp}/${asset}" "${url}"
    mkdir -p "${tmp}/extract" "${BIN_DIR}"
    tar -xf "${tmp}/${asset}" -C "${tmp}/extract"

    local bin path
    for bin in ${binaries//,/ }; do
        path="$(find "${tmp}/extract" -type f -name "${bin}" | head -n 1)"
        if [[ -z "${path}" ]]; then
            echo "Could not find ${bin} inside ${asset}" >&2
            return 1
        fi
        install -m 0755 "${path}" "${BIN_DIR}/${bin}"
        echo "✅ ${bin} ${tag} installed in ${BIN_DIR}/${bin}"
    done

    rm -rf "${tmp}"
}

main() {
    local entry repo template binaries first
    for entry in "${TOOLS[@]}"; do
        IFS='|' read -r repo template binaries <<< "${entry}"
        first="${binaries%%,*}"

        if [[ $# -gt 0 ]]; then
            [[ " $* " == *" ${first} "* ]] || continue
        elif [[ -x "${BIN_DIR}/${first}" ]]; then
            echo "${first} is already installed in ${BIN_DIR}, skipping..."
            continue
        fi

        install_tool "${repo}" "${template}" "${binaries}"
    done
}

main "$@"
