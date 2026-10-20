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

Both scripts are safe to re-run: existing config files are left alone and the `~/.zshrc` block is only appended once.

## What you get
- **Shell**
  - zsh, oh-my-zsh, powerlevel10k, zsh-syntax-highlighting
  - fzf (`~~` completion, `rg` as the file source), ripgrep, bat (Nord), fd, tree, jq
  - my aliases and functions, appended to `~/.zshrc` between `# >>> macos-setup` / `# >>> ubuntu-setup` markers
  - macOS: `macos/p10k.zsh` copied to `~/.p10k.zsh`
- **Languages**
  - node LTS via nvm (auto-switches on `.nvmrc`), with pnpm and bun
  - Python 3.14 via pyenv
  - macOS: Ruby 3.2.8 via rbenv; Ubuntu: ydiff via pip
- **Git**
  - name/email, `micro` as editor, `main` as default branch, `pull.rebase`, `pull.ff only`, no branch pager
  - macOS: `opendiff` as diff/merge tool
  - gh, lazygit
- **Terminal tools**
  - tmux with tpm and plugins: tmux-sensible, vim-tmux-navigator, catppuccin, tmux-yank
  - micro (2-space tabs, no EOF newline)
  - httpie, glances, wget
- **Containers and cloud**
  - docker: OrbStack on macOS, docker-ce + buildx + compose plugin on Ubuntu; lazydocker
  - go, aws-cli, kubectl (Ubuntu), yq
- **macOS only** (`macos/Brewfile`)
  - formulae: act, awscli, caddy, cloudflared, dive, doctl, ffmpeg, gita, glow, granted, humanlog, k3d, k9s, kind, mkcert, notify, nvtop, pipenv, tilt, watch, watchman, xcodegen, ydiff, yt-dlp
  - personal taps: getvect, shepherd
  - casks: 1Password (+ CLI), Elasticvue, Ghostty, GitHub Desktop, Google Chrome, OrbStack, Slack, Stats, Zed
  - MesloLGS Nerd Font for the prompt
- **Ubuntu only**
  - base: build-essential, curl, unzip, openssh-server, nmap, net-tools, traceroute, yamllint, xclip, pyenv build deps
  - `desktop`: GIMP, Steam, Guake, nvtop, Slack, Zed, Chrome, NVIDIA drivers

## After running
- Open a new terminal. On macOS set its font to MesloLGS Nerd Font, and sign in to 1Password and OrbStack
- Ubuntu: log out and back in for the zsh login shell and docker group, then run `p10k configure`
- Edit `macos/Brewfile` to add or drop packages, then `brew bundle --file=macos/Brewfile`

The two scripts are deliberately self-contained, so the shared bits (zshrc block, tmux, micro) are duplicated between them.

Take/use at will
