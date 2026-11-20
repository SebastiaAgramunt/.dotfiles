# dotfiles

Personal shell configs and tooling setup for macOS and Linux.

## Structure

The repo only holds configuration. Tools and third-party frameworks are installed
outside it, following the XDG layout:

| What | Where |
| --- | --- |
| CLI binaries (Linux) | `~/.local/bin` |
| CLI binaries (macOS) | Homebrew |
| oh-my-zsh, powerlevel10k, pyenv, awesome-vim, Oh my tmux! | `~/.local/share/<name>` |

```text
.dotfiles/
├── bash/          # bash config (stowable)
├── git/           # git config (stowable)
├── p10k/          # powerlevel10k config (stowable)
├── tmux/          # .tmux.conf.local, your Oh my tmux! overrides (stowable)
├── vim/           # .vimrc: loads awesome-vim + your customizations (stowable)
├── zsh/           # zsh config (stowable)
└── setup/
    ├── bootstrap.sh                 # main entry point
    ├── utils.sh                     # shared helpers (OS/arch detection, install dirs)
    ├── Brewfile                     # macOS packages and CLI tools
    ├── tools.sh                     # Linux: CLI tools from GitHub releases → ~/.local/bin
    ├── clones.sh                    # third-party frameworks → ~/.local/share
    └── install_prerequisites/
        ├── linux.sh                 # apt packages (uses sudo)
        └── macos.sh                 # homebrew + brew bundle
```

## Install

### 1. Clone

```bash
git clone git@github.com:SebastiaAgramunt/.dotfiles.git ~/.dotfiles
```

### 2. Bootstrap

Installs system packages and CLI tools, and clones the third-party frameworks.
Works on macOS and Linux (Linux needs sudo for apt packages):

```bash
~/.dotfiles/setup/bootstrap.sh
```

Re-running it is safe: tools already in `~/.local/bin` are skipped and clones are updated with `git pull`.

To reinstall (upgrade) specific tools on Linux:

```bash
~/.dotfiles/setup/tools.sh rg fd
```

### 3. Stow configs

Stow creates symlinks from `~` into this repo. Run from the repo root:

```bash
cd ~/.dotfiles
stow --adopt zsh vim git tmux p10k
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

### CLI tools

Installed with Homebrew on macOS (`setup/Brewfile`) and from GitHub releases into `~/.local/bin` on Linux (`setup/tools.sh`). To add a tool, add a line to both.

| Tool | Binary | Description |
| --- | --- | --- |
| [bat](https://github.com/sharkdp/bat) | `bat` | `cat` with syntax highlighting |
| [bottom](https://github.com/ClementTsang/bottom) | `btm` | system monitor |
| [csvlens](https://github.com/YS-L/csvlens) | `csvlens` | interactive CSV viewer |
| [duf](https://github.com/muesli/duf) | `duf` | disk usage utility |
| [eza](https://github.com/eza-community/eza) | `eza` | modern `ls` |
| [fd](https://github.com/sharkdp/fd) | `fd` | fast `find` alternative |
| [hexyl](https://github.com/sharkdp/hexyl) | `hexyl` | hex viewer |
| [hyperfine](https://github.com/sharkdp/hyperfine) | `hyperfine` | benchmarking tool |
| [lsd](https://github.com/lsd-rs/lsd) | `lsd` | `ls` with icons |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | `rg` | fast grep |
| [uv](https://github.com/astral-sh/uv) | `uv` | fast Python package manager |

### Third-party frameworks (cloned to `~/.local/share`)

- [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh) + [powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [pyenv](https://github.com/pyenv/pyenv) — Python versions live in `~/.local/share/pyenv/versions`
- [awesome-vim](https://github.com/amix/vimrc) — add your vim settings at the bottom of `vim/.vimrc`
- [Oh my tmux!](https://github.com/gpakosz/.tmux) — `~/.tmux.conf` is symlinked to it; customize `tmux/.tmux.conf.local`

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
