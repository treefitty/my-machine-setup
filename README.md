# Overview
Scripts to set up a new machine the way I like it: zsh/oh-my-zsh/p10k, tmux, micro, nvm, pyenv, docker...

| | Script | Notes |
|---|---|---|
| macOS (Apple Silicon) | `macos/macos-setup.sh` | Installs Homebrew, then everything in `macos/Brewfile` |
| Ubuntu 24.04 | `ubuntu/ubuntu-setup.sh` | Headless / server |
| Ubuntu 24.04 desktop | `ubuntu/ubuntu-setup.sh desktop` | Plus GUI apps (x86_64 only: chrome, steam) |

    git clone git@github.com:treefitty/my-machine-setup.git
    cd my-machine-setup
    macos/macos-setup.sh      # or ubuntu/ubuntu-setup.sh [desktop]

Both scripts finish by running `dotfiles/install.sh`, which symlinks everything in `dotfiles/` into `~` (an existing real file is moved to `<name>.bak`). Edit a dotfile in `~` and you're editing the repo. Scripts are safe to re-run.

    dotfiles/   # .zshrc .zshenv .gitconfig .tmux.conf .vimrc .p10k.zsh .config/micro, shared by both setups
    macos/      # macos-setup.sh, Brewfile
    ubuntu/     # ubuntu-setup.sh

`dotfiles/.zshrc` branches on `$OSTYPE` for the few OS differences (clipboard, `upup`, PATH) and sources an untracked `~/.zshrc.local` for machine-specific bits like SSH aliases.

## What you get
- **Shell**
  - zsh, oh-my-zsh, powerlevel10k, zsh-syntax-highlighting
  - fzf (`~~` completion, `rg` as the file source), ripgrep, bat (Nord), fd, tree, jq
  - my aliases and functions, and `.p10k.zsh`, via `dotfiles/`
- **Languages**
  - node LTS via nvm (auto-switches on `.nvmrc`), with pnpm and bun
  - Python 3.14 via pyenv
  - Ubuntu: ydiff via pip
- **Git**
  - `dotfiles/.gitconfig`: name/email, `micro` as editor, `main` as default branch, `pull.rebase`, `pull.ff only`, colours, `opendiff` as diff/merge tool
  - gh, lazygit
- **Terminal tools**
  - tmux with tpm and plugins: tmux-sensible, vim-tmux-navigator, catppuccin, tmux-yank
  - micro with its lsp, filemanager, editorconfig and monokai-dark plugins, plus settings and keybindings from `dotfiles/`
  - vim config
  - httpie, glances, wget
- **Containers and cloud**
  - docker: OrbStack on macOS, docker-ce + buildx + compose plugin on Ubuntu
  - go, aws-cli, kubectl (Ubuntu)
- **macOS only** (`macos/Brewfile`)
  - formulae: act, awscli, caddy, cloudflared, ffmpeg, gita, glow, pipenv, tilt, watch, ydiff, yt-dlp
  - personal taps: getvect, shepherd
  - casks: 1Password (+ CLI), Elasticvue, Ghostty, GitHub Desktop, Google Chrome, OrbStack, Slack, Stats, Zed
  - MesloLGS Nerd Font for the prompt
- **Ubuntu only**
  - base: build-essential, curl, unzip, openssh-server, nmap, net-tools, traceroute, yamllint, xclip, pyenv build deps
  - `desktop`: GIMP, Steam, Guake, Slack, Zed, Chrome, NVIDIA drivers

## After running
- Open a new terminal. On macOS set its font to MesloLGS Nerd Font, and sign in to 1Password and OrbStack
- Ubuntu: log out and back in for the zsh login shell and docker group
- Put machine-specific shell bits (SSH aliases etc) in `~/.zshrc.local`, which isn't tracked
- Edit `macos/Brewfile` to add or drop packages, then `brew bundle --file=macos/Brewfile`


Take/use at will
