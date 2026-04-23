# dotfiles

Personal shell configs and tooling setup for macOS and Linux.

## Structure

```text
.dotfiles/
├── bash/          # bash config (stowable)
├── git/           # git config (stowable)
├── p10k/          # powerlevel10k config (stowable)
├── tmux/          # tmux config (stowable)
├── vim/           # vim config (stowable)
├── zsh/           # zsh config (stowable)
├── build/         # install destination — binaries land in build/bin/
└── setup/
    ├── bootstrap.sh                 # main entry point
    ├── utils.sh                     # shared helpers (OS/arch detection)
    ├── install_prerequisites/
    │   ├── linux.sh                 # apt packages (uses sudo)
    │   └── macos.sh                 # homebrew packages
    ├── install_scripts/             # per-tool installers → build/bin/
    │   ├── bat.sh, bottom.sh, csvlens.sh, duf.sh, eza.sh
    │   ├── fd.sh, hexyl.sh, hyperfine.sh, lsd.sh
    │   ├── pyenv.sh, ripgrep.sh, stow.sh, uv.sh
    └── third_party_configs/
        ├── oh-my-zsh.sh
        ├── powerlevel10k.sh
        ├── tmux_config.sh
        └── awesome-vim.sh
```

## Install

### 1. Clone

```bash
git clone git@github.com:SebastiaAgramunt/.dotfiles.git ~/.dotfiles
```

### 2. Bootstrap

Installs system packages and downloads tool binaries into `build/bin/`.

**macOS:**

```bash
~/.dotfiles/setup/bootstrap.sh
```

**Linux** (requires sudo for apt packages):

```bash
~/.dotfiles/setup/bootstrap.sh
```

> `build/` is not tracked in git. Safe to delete and re-run bootstrap at any time.

### 3. Stow configs

Stow creates symlinks from `~` into this repo. Run from the repo root.

**macOS** (system `stow` installed by homebrew):

```bash
cd ~/.dotfiles
stow --adopt zsh
stow --adopt vim
stow --adopt git
stow --adopt tmux
stow --adopt p10k
```

**Linux** (stow binary installed into `build/bin/`):

```bash
cd ~/.dotfiles
STOW=~/.dotfiles/build/bin/stow
$STOW --adopt zsh
$STOW --adopt vim
$STOW --adopt git
$STOW --adopt tmux
```

### 4. Apply shell config

```bash
source ~/.zshrc
```

On first run, `p10k` will prompt you to configure the shell prompt. To reconfigure later:

```bash
p10k configure
```

---

## What gets installed

### System packages (via apt / brew)

| Package | Purpose |
| --- | --- |
| `git`, `curl`, `wget` | basics |
| `zsh` | shell |
| `tmux` | terminal multiplexer |
| `mosh` | mobile shell |
| `stow` | symlink manager |
| `git-delta` | better git diffs |
| `gcc`, `make` | build tools |
| `vim` | editor |

### Tool binaries (downloaded to `build/bin/`)

| Tool | Binary | Description |
| --- | --- | --- |
| [bat](https://github.com/sharkdp/bat) | `bat` | `cat` with syntax highlighting |
| [bottom](https://github.com/ClementTsang/bottom) | `btm` | system monitor |
| [csvlens](https://github.com/YS-L/csvlens) | `csvlens` | interactive CSV viewer |
| [duf](https://github.com/muesli/duf) | `duf` | disk usage utility |
| [eza](https://github.com/eza-community/eza) | `eza` | modern `ls` (Linux only; macOS uses brew) |
| [fd](https://github.com/sharkdp/fd) | `fd` | fast `find` alternative |
| [hexyl](https://github.com/sharkdp/hexyl) | `hexyl` | hex viewer |
| [hyperfine](https://github.com/sharkdp/hyperfine) | `hyperfine` | benchmarking tool |
| [lsd](https://github.com/lsd-rs/lsd) | `lsd` | `ls` with icons |
| [pyenv](https://github.com/pyenv/pyenv) | `pyenv` | Python version manager |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | `rg` | fast grep |
| [uv](https://github.com/astral-sh/uv) | `uv` | fast Python package manager |

### Third-party configs (cloned to `build/`)

- [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)
- [powerlevel10k](https://github.com/romkatv/powerlevel10k)
- tmux plugin manager
- [awesome-vim](https://github.com/amix/vimrc)

---

## Testing with Docker

Two images are available — Ubuntu (for the Linux path) and a Homebrew image (for the macOS path).

```bash
# Ubuntu — test the full bootstrap
make -C setup/Docker run-ubuntu
~/.dotfiles/setup/bootstrap.sh

# macOS/Homebrew — test brew-based installs only
# (bootstrap.sh detects Linux inside Docker; run macos.sh directly)
make -C setup/Docker run-macos
~/.dotfiles/setup/install_prerequisites/macos.sh
```

The dotfiles repo is mounted at `~/.dotfiles` inside both containers. Images are built with your current user and UID so file permissions match. Run `make -C setup/Docker help` for all targets.

---

## Un-stow

To remove all symlinks:

```bash
cd ~/.dotfiles
stow -D zsh bash vim git tmux p10k
```
