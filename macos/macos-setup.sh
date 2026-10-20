#!/usr/bin/env bash
# macOS (Apple Silicon) setup, mirrors my current mac: brew bundle, zsh + oh-my-zsh + p10k, tmux, micro, nvm, pyenv, rbenv...
# Usage: macos-setup.sh
set -eo pipefail

HERE=$(cd "$(dirname "$0")" && pwd)


# ----
# homebrew + everything in the Brewfile
if ! [ -x /opt/homebrew/bin/brew ]; then
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"
brew bundle --file="$HERE/Brewfile"


# ----
# nvm, node, pnpm, bun (shell init lives in the zshrc block below)
export NVM_DIR="$HOME/.nvm"
mkdir -p "$NVM_DIR"
. "$(brew --prefix nvm)/nvm.sh"
nvm install --lts
npm install -g pnpm bun


# ----
# pyenv + rbenv
eval "$(pyenv init -)"
pyenv install -s 3.14
pyenv global 3.14

eval "$(rbenv init - bash)"
rbenv install -s 3.2.8
rbenv global 3.2.8


# ----
# oh-my-zsh + powerlevel10k + syntax highlighting
[ -d ~/.oh-my-zsh ] || RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
[ -d "$ZSH_CUSTOM/themes/powerlevel10k" ] || git clone --depth 1 https://github.com/romkatv/powerlevel10k "$ZSH_CUSTOM/themes/powerlevel10k"
[ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] || git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

sed -i '' 's|^ZSH_THEME=.*|ZSH_THEME="powerlevel10k/powerlevel10k"|; s|^plugins=(git)|plugins=(git zsh-syntax-highlighting docker)|' ~/.zshrc

[ -f ~/.p10k.zsh ] || cp "$HERE/p10k.zsh" ~/.p10k.zsh

grep -q '# >>> macos-setup' ~/.zshrc || cat >> ~/.zshrc <<'EOF'

# >>> macos-setup >>>
eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="$HOME/.local/bin:$PATH"
export BAT_THEME="Nord"
export FZF_DEFAULT_OPTS="--extended"
export FZF_DEFAULT_COMMAND="rg --files --hidden"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_COMPLETION_TRIGGER='~~'
source <(fzf --zsh)

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh   # run `p10k configure` to change

# OrbStack (docker)
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# pyenv, rbenv
eval "$(pyenv init -)"
eval "$(rbenv init - zsh)"

# nvm, switching node per .nvmrc
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

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
alias upup="brew update && brew upgrade"
alias pmi="pnpm i"
alias pmid="pnpm i -D"
alias dkps="docker ps | less -S"
alias jstime="node -e 'console.log(Date.now())' | pbcopy"
alias restart_taskbar="killall -KILL Dock"

alias gbv='git branch -vv'
alias git-latest="git describe --abbrev=0"
alias git-stash-staged='git stash -- $(git diff --staged --name-only)'
alias git-prune-tags='git fetch --prune --prune-tags'
alias gall='gita ll'
alias gallc='clear && gita ll'
alias gapl='gita pull'
alias yd="ydiff -s -w0"
alias ydc="ydiff -s -w0 --cached"
alias nxc="pnpm nx clear-cache"

alias tma="tmux_attach"
alias tmc="tmux_new"
alias tml="tmux ls"

alias -g H='| head'
alias -g L='| less'
alias -g G='| grep'
alias -g W='| wc -l'
alias -g J='| jq .'
alias -g T="| tr -d '\n' "
alias -g C="| pbcopy"
# <<< macos-setup <<<
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
git config --global merge.tool opendiff
git config --global diff.tool opendiff


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

echo "Done. Open a new terminal (set its font to MesloLGS Nerd Font), sign in to 1Password/OrbStack."
