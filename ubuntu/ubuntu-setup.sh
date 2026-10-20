#!/usr/bin/env bash
# Ubuntu 24.04 setup, mirrors my macOS setup (zsh + oh-my-zsh + p10k, tmux, micro, nvm, pyenv...)
# Usage: ubuntu-setup.sh [desktop]   (desktop adds GUI apps)
set -eo pipefail

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

sed -i 's|^ZSH_THEME=.*|ZSH_THEME="powerlevel10k/powerlevel10k"|; s|^plugins=(git)|plugins=(git zsh-syntax-highlighting docker)|' ~/.zshrc

sudo chsh -s "$(command -v zsh)" "$USER"

grep -q '# >>> ubuntu-setup' ~/.zshrc || cat >> ~/.zshrc <<'EOF'

# >>> ubuntu-setup >>>
export PATH="$HOME/.local/bin:$HOME/go/bin:$PATH"
export BAT_THEME="Nord"
export FZF_DEFAULT_OPTS="--extended"
export FZF_DEFAULT_COMMAND="rg --files --hidden"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_COMPLETION_TRIGGER='~~'
source <(fzf --zsh)

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh   # run `p10k configure` on first login

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# nvm, switching node per .nvmrc
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

function paged_grep() {
  rg -S --line-number --no-heading --color=always $1 | less -r
}

function git_cull_branches() {
  git fetch -p

  for branch in $(git for-each-ref --format '%(refname) %(upstream:track)' refs/heads | awk '$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}'); do
    git branch -D $branch;
  done;
}

function git_child_statuses() {
  find . -maxdepth 1 -mindepth 1 -type d -exec sh -c '(echo {} && cd {} && git status -s && echo)' \;
}

function tmux_attach() { tmux a -t "$1" }
function tmux_new() { tmux new -s "$1" }

alias size='du -c -h -d 1 | sort -h'
alias rgp="paged_grep"
alias lsa="ls -lah"
alias upup="sudo apt update && sudo apt upgrade -y"
alias pmi="pnpm i"
alias pmid="pnpm i -D"
alias dkps="docker ps | less -S"

alias gbv='git branch -vv'
alias git-latest="git describe --abbrev=0"
alias git-stash-staged='git stash -- $(git diff --staged --name-only)'
alias git-prune-tags='git fetch --prune --prune-tags'
alias yd="ydiff -s -w0"
alias ydc="ydiff -s -w0 --cached"

alias tma="tmux_attach"
alias tmc="tmux_new"
alias tml="tmux ls"

alias -g H='| head'
alias -g L='| less'
alias -g G='| grep'
alias -g W='| wc -l'
alias -g J='| jq .'
alias -g T="| tr -d '\n' "
alias -g C="| xclip -selection clipboard"
# <<< ubuntu-setup <<<
EOF


# ----
# git
git config --global user.name "Paul Carroll"
git config --global user.email "paul.carroll@gmail.com"
git config --global core.editor micro
git config --global init.defaultBranch main
git config --global pull.ff only
git config --global pull.rebase true
git config --global pager.branch false


# ----
# tmux (+ tpm and plugins)
[ -f ~/.tmux.conf ] || cat > ~/.tmux.conf <<'EOF'
set-option -sa terminal-overrides ",xterm*:Tc"

set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'christoomey/vim-tmux-navigator'
set -g @plugin 'catppuccin/tmux'
set -g @plugin 'tmux-plugins/tmux-yank'

set -g mouse on
set -g set-clipboard off
set -g base-index 1
set -g pane-base-index 1
set-window-option -g pane-base-index 1
set-option -g renumber-windows on

bind r source-file ~/.tmux.conf\; display-message "Reloaded config"
bind | split-window -h -c "#{pane_current_path}"
bind _ split-window -v -c "#{pane_current_path}"
bind -n M-H previous-window
bind -n M-L next-window

set-option -g default-shell /bin/zsh

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'
EOF

[ -d ~/.tmux/plugins/tpm ] || git clone --depth 1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins || true


# ----
# micro
mkdir -p ~/.config/micro
[ -f ~/.config/micro/settings.json ] || cat > ~/.config/micro/settings.json <<'EOF'
{
    "autosu": true,
    "eofnewline": false,
    "fastdirty": true,
    "tabsize": 2,
    "tabstospaces": true,
    "termtitle": false
}
EOF


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
