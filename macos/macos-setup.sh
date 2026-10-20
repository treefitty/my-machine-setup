#!/usr/bin/env bash
# macOS (Apple Silicon) setup, mirrors my current mac: brew bundle, dotfiles, zsh + oh-my-zsh + p10k, tmux, micro, nvm, pyenv, rbenv...
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

# ----
# dotfiles (zshrc, gitconfig, tmux, micro, p10k...) + micro plugins
micro -plugin install filemanager lsp editorconfig monokai-dark || true
"$HERE/../dotfiles/install.sh"


# ----
# tmux (+ tpm and plugins)
[ -d ~/.tmux/plugins/tpm ] || git clone --depth 1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins || true


echo "Done. Open a new terminal (set its font to MesloLGS Nerd Font), sign in to 1Password/OrbStack."
