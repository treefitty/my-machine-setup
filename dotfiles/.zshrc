# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

PATH="/usr/local/bin:$(getconf PATH)"

export NVM_DIR=~/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

if [ "$OS" = 'OSX' ]; then
  [[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh
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

function node_search() {
    grep -n -i -r --color \
        --exclude-dir=node_modules \
        --exclude-dir=dist \
        --exclude-dir=static \
        --exclude-dir=.serverless \
        --exclude-dir=coverage \
        --exclude-dir=apps/web-app/src/assets/webviewer \
        --exclude=yarn.lock \
        --exclude=yarn-error.log \
        --exclude=webviewer-ui.min.js \
        --exclude-dir=build \
        $1 * .[^.]* | more
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

function filter_file() {
    cat $1 | grep -i $2 | less
}

alias ssh-office="ssh paul@192.168.1.4"
alias ssh-wd="ssh sshd@nas-wd"
alias ssh-seagate="ssh paul@seagate-d2.localdomain"
alias ssh-unifi="ssh pi@unifi-controller"

alias grepnode="node_search $1"
alias gn="grepnode"

alias jstime="node -e 'console.log(Date.now())' | pbcopy"

alias git-latest="git describe --abbrev=0"
alias git-ammend="git commit --amend --no-edit"
alias git-log-search="git rev-list --all | xargs git grep -iF '$1'"
alias git-log-detail="git log -p"
alias git-cull-branches='git_cull_branches'
alias git-child-statuses='git_child_statuses'

alias yd="ydiff -s -w0"
alias ydc="ydiff -s -w0 --cached"

alias k="kubectl"

alias filter="filter_file $1 $2"

export PATH="/usr/local/sbin:$PATH"
export MC_SKIN=blue
export BAT_THEME="Nord"

alias python="$(pyenv which python)"
alias pip="$(pyenv which pip)"
alias awslocal="$(pyenv which awslocal)"


if [[ "$OSTYPE" == "darwin"* ]]; then
  export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"

  alias upup="brew update && brew upgrade"

  . $HOME/.asdf/asdf.sh

  # Added by Amplify CLI binary installer
  export PATH="$HOME/.amplify/bin:$PATH"

  # opam configuration
  test -r /Users/paulcarroll/.opam/opam-init/init.zsh && . /Users/paulcarroll/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

  # profile.d z.sh
  . /usr/local/etc/profile.d/z.sh
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  alias upup="sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS="--extended"
export FZF_DEFAULT_COMMAND="rg --files --hidden"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/__tabtab.zsh ]] && . ~/.config/tabtab/__tabtab.zsh || true

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="/usr/local/opt/ruby/bin:$PATH"

# Load ATIUN cli history replacement
#ATUIN_NOBIND="true"
#eval "$(atuin init zsh)"
