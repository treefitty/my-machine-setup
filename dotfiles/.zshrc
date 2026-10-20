
DEBUG_STARTUP="DEBUG"

function log() {
  [[ ${DEBUG_STARTUP} -eq "DEBUG" ]] && echo $1
}

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ $OSTYPE == darwin* ]]; then
  PATH="/usr/local/bin:~/:$(getconf PATH)"
  CLIP=pbcopy
else
  PATH="$PATH:/snap/bin:$HOME/go/bin"
  CLIP="xclip -selection clipboard"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to disable colors in ls.
DISABLE_LS_COLORS="true"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-syntax-highlighting
  docker
  asdf
)

source $ZSH/oh-my-zsh.sh

# ------------------
# Find in current directory and sub-directories
function fcd() {
  local dir
  dir=$(find * -type d -maxdepth 0 2> /dev/null | 
  zz) && cd "$dir"
}

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

function tmux_attach() {
  tmux a -t "$1"
}

function tmux_new() {
  tmux new -s "$1"
}

export LS_COLORS="${LS_COLORS}:ow=34;40"

# -----------------
# AWS aliases
alias aws-sandbox="aws --profile sandbox"
alias aws-production="aws --profile production"
alias aws-sandbox-login="aws-sandbox sso login"
alias aws-production-login="aws-production sso login"

alias tf-sandbox="AWS_PROFILE=sandbox terraform"
alias tf-production="AWS_PROFILE=production terraform"


# -----------------
# Machine-specific (ssh aliases etc), not in git
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local


# -----------------
# General utility aliases
alias size='du -c -h -d 1 | sort -h'
alias rgp="paged_grep"
alias jstime="node -e 'console.log(Date.now())' | ${CLIP}"
[[ $OSTYPE == darwin* ]] && alias rand='(npx ulid generate | tr "[:upper:]" "[:lower:]" | pbcopy && echo "Random value copied to clipboard: $(pbpaste)")'
alias pnpm-update="curl -fsSL https://get.pnpm.io/install.sh | sh -"
alias pnpm-fix="rimraf $PNPM_HOME"

# -----------------
# Docker aliases
alias dkps="docker ps | less -S"

# -----------------
# Git aliases
alias git-latest="git describe --abbrev=0"
alias git-log-search="git rev-list --all | xargs git grep -iF '$1'"
alias gbv='git branch -vv'
alias git-stash-staged='git stash -- $(git diff --staged --name-only)'
alias git-prune-tags='git fetch --prune --prune-tags'

alias gall='gita ll'
alias gallc='clear && gita ll'
alias gapl='gita pull'

alias yd="ydiff -s -w0"
alias ydc="ydiff -s -w0 --cached"

# -----------------
# 
alias nxc="pnpm nx clear-cache"

# -----------------
# tmux aliases
alias tma="tmux_attach"
alias tmc="tmux_new"
alias tml="tmux ls"

# -----------------
# ENV setup
export PATH="/usr/local/sbin:$PATH"
export MC_SKIN=blue
export BAT_THEME="Nord"

# -----------------
# Utilities
alias pnpm_update="curl -fsSL https://get.pnpm.io/install.sh | sh - "
alias dozzle_up="docker run --detach --volume=/var/run/docker.sock:/var/run/docker.sock -p 8080:8080 --name dozzle --restart unless-stopped amir20/dozzle"
[[ $OSTYPE == darwin* ]] && alias restart_taskbar="killall -KILL Dock"

alias lsa="ls -lah"
alias pmi="pnpm i"
alias pmid="pnpm i -D"

if [[ $OSTYPE == darwin* ]]; then
  alias upup="brew update && brew upgrade"
else
  alias upup="sudo apt update && sudo apt upgrade -y"
fi

alias -g H='| head'
alias -g L='| less'
alias -g G='| grep'
alias -g W='| wc -l'
alias -g J='| jq .'
alias -g T="| tr -d '\n' "
alias -g C="| ${CLIP}"

# -----
# FZF
export FZF_DEFAULT_OPTS="--extended"
export FZF_DEFAULT_COMMAND="rg --files --hidden"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_COMPLETION_TRIGGER='~~'

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/__tabtab.zsh ]] && . ~/.config/tabtab/__tabtab.zsh || true

#autoload -U +X bashcompinit && bashcompinit
#complete -o nospace -C /usr/local/bin/terraform terraform

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="/usr/local/opt/ruby/bin:$PATH"

alias python3=python

# OrbStack (docker): command-line tools and integration
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# pnpm
if [[ $OSTYPE == darwin* ]]; then export PNPM_HOME="$HOME/Library/pnpm"; else export PNPM_HOME="$HOME/.local/share/pnpm"; fi
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$("$HOME/miniconda3/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export PATH="$PATH:$HOME/.platformio/penv/bin"

# Homebrew environment init
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

export PATH="$HOME/.local/bin:$PATH"
source <(fzf --zsh)

command -v rbenv >/dev/null && eval "$(rbenv init - zsh)"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv >/dev/null && eval "$(pyenv init -)"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# ---
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
  # ubuntu: nvm installed straight into ~/.nvm
  if (( ! $+functions[nvm] )) && [ -s "$NVM_DIR/nvm.sh" ]; then . "$NVM_DIR/nvm.sh"; fi

# place this after nvm initialization!
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
if (( $+functions[nvm] )); then
  add-zsh-hook chpwd load-nvmrc
  load-nvmrc
fi

