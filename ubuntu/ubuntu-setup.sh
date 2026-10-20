#!/usr/bin/env bash
# Ubuntu 24.04 setup, mirrors my macOS setup (zsh + oh-my-zsh + p10k, tmux, micro, nvm, pyenv...)
# Usage: ubuntu-setup.sh [desktop]   (desktop adds GUI apps)
set -eo pipefail

HERE=$(cd "$(dirname "$0")" && pwd)

mkdir -p ~/.local/bin ~/.config
export PATH="$HOME/.local/bin:$PATH"
CODENAME=$(. /etc/os-release && echo "$VERSION_CODENAME")
ARCH=$(dpkg --print-architecture)


# ----
# base packages
sudo apt-get update -y
sudo apt-get install -y \
  ca-certificates curl wget gnupg unzip git build-essential \
  zsh tmux micro tree jq ripgrep fd-find bat glances httpie yamllint xclip \
  openssh-server nmap net-tools traceroute \
  libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libncurses-dev \
  xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev  # pyenv build deps

# Ubuntu renames these binaries
ln -sf "$(command -v fdfind)" ~/.local/bin/fd
ln -sf "$(command -v batcat)" ~/.local/bin/bat

# apt's fzf is too old for `fzf --zsh`
[ -d ~/.fzf ] || git clone --depth 1 https://github.com/junegunn/fzf ~/.fzf
~/.fzf/install --bin
ln -sf ~/.fzf/bin/fzf ~/.local/bin/fzf

sudo snap install go --classic
sudo snap install aws-cli --classic
sudo snap install kubectl --classic
sudo snap install yq


# ----
# gh
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg -o /etc/apt/keyrings/github-cli.gpg
echo "deb [arch=$ARCH signed-by=/etc/apt/keyrings/github-cli.gpg] https://cli.github.com/packages stable main" |
  sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null


# ----
# docker (compose is the `docker compose` plugin now)
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
echo "deb [arch=$ARCH signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $CODENAME stable" |
  sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

sudo apt-get update -y
sudo apt-get install -y gh docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker "$USER"  # takes effect on next login


# ----
# lazygit + lazydocker
LG=$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep -Po '"tag_name": *"v\K[^"]*')
curl -fsSL "https://github.com/jesseduffield/lazygit/releases/download/v${LG}/lazygit_${LG}_Linux_$(uname -m | sed 's/aarch64/arm64/').tar.gz" |
  sudo tar -xz -C /usr/local/bin lazygit
curl -fsSL https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash


# ----
# nvm, node, pnpm, bun (shell init lives in the zshrc block below, hence PROFILE=/dev/null)
curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | PROFILE=/dev/null bash
export NVM_DIR="$HOME/.nvm"
. "$NVM_DIR/nvm.sh"
nvm install --lts
npm install -g pnpm bun


# ----
# pyenv (python 3.14 to match the mac)
[ -d ~/.pyenv ] || curl -fsSL https://pyenv.run | bash
export PATH="$HOME/.pyenv/bin:$PATH"
pyenv install -s 3.14
pyenv global 3.14
"$(pyenv root)/shims/pip" install ydiff


# ----
# oh-my-zsh + powerlevel10k + syntax highlighting
[ -d ~/.oh-my-zsh ] || RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
[ -d "$ZSH_CUSTOM/themes/powerlevel10k" ] || git clone --depth 1 https://github.com/romkatv/powerlevel10k "$ZSH_CUSTOM/themes/powerlevel10k"
[ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] || git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

sudo chsh -s "$(command -v zsh)" "$USER"

# ----
# dotfiles (zshrc, gitconfig, tmux, micro, p10k...) + micro plugins
micro -plugin install filemanager lsp editorconfig monokai-dark || true
"$HERE/../dotfiles/install.sh"


# ----
# tmux (+ tpm and plugins)
[ -d ~/.tmux/plugins/tpm ] || git clone --depth 1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins || true


[ "$1" = desktop ] || { echo "Done (headless). Log out and back in for zsh + docker group."; exit 0; }

# ----
# desktop apps (x86_64 only: chrome, steam)
sudo add-apt-repository -y multiverse
sudo apt-get update -y
sudo apt-get install -y gimp steam-installer guake nvtop

sudo snap install slack

curl -fsSL https://zed.dev/install.sh | sh

# chrome
curl -fsSLo /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt-get install -y /tmp/chrome.deb
rm /tmp/chrome.deb

# nvidia
sudo ubuntu-drivers install

echo "Done (desktop). Log out and back in for zsh + docker group."
