# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

set -o vi
setopt no_beep
tput smam

# Java dev
export JAVA_HOME=`/usr/libexec/java_home -v 11.0.23`

# Android dev
export ANDROID_SDK=~/Library/Android/sdk/
export ANDROID_HOME=~/Library/Android/sdk/
export PATH=$PATH:$ANDROID_HOME/platform-tools
# avdmanager
export PATH=$PATH:~/Library/Android/sdk/cmdline-tools/latest/bin/
# emulator
export PATH=$PATH:~/Library/Android/sdk/emulator/

# unzip command
export PATH="/opt/homebrew/opt/unzip/bin:$PATH"

# Keycloak Admin CLI
# export KEYCLOAK_HOME=~/repos/keycloak/integration/client-cli/admin-cli/src/main
# export PATH=$PATH:~/$KEYCLOAK_HOME/bin/

# n command
export N_PREFIX=$HOME/.n
export PATH=$N_PREFIX/bin:$PATH

export REACT_EDITOR=vim

# aliases
# alias rm='rm -i'
alias l='ls -GAhltr'
alias la='ls -a'
alias ll='ls -l'
alias sjis_unzip='unzip -O sjis'
alias clip='pbcopy'
alias grep='grep --color=auto'
alias grepf='grep -A 2 -B 2 -Rn --color=auto --exclude-dir={node_modules,.git,dist}'
alias grepl='grep -A 2 -B 2 -n --color=auto'
#alias diff= 'diff --color=always '
alias diffy='diff --color=always --suppress-common-line -y'
alias diffu='diff --color=always -u'

alias jwt='python3.11 ~/repos/jwt_tool/jwt_tool.py'
alias glog='git log --graph'

# enables shell command completion for Stripe
fpath=(~/.stripe $fpath)
autoload -Uz compinit && compinit -i

## terminal
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# zshでもコメントを使えるようにする
setopt interactivecomments

# pyenv の設定
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
