# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# vi モードを有効
setopt vi

# beepを無効
setopt no_beep

# タブ補完を有効
setopt complete_in_word

# タブ補完の履歴を有効
setopt hist_verify

# cdの補完を有効
setopt autocd

# ターミナル間でhistoryを共有する
# setopt share_history

# zshでもコメントを使えるようにする
setopt INTERACTIVE_COMMENTS
#setopt interactivecomments

export N_PREFIX=$HOME/.n
export PATH=$N_PREFIX/bin:$PATH

export REACT_EDITOR=vim

alias zip_help='echo "Usage: 7z <command> [<switches>...] <archive_name> [<file_names>...] \n7z a -tzip -scsWIN -p{PASSWORD}"'

# aliases
alias ...='cd ../../'
alias l='ls -Gl'
alias ll='ls -GAhltr'
alias la='ls -Ga'
alias tree='find'
alias clip='pbcopy'
alias grep='grep -n --color=auto'
alias grepf='grep -Rn --color=auto --exclude-dir={node_modules,.git,dist,.next,build}'
#alias diff= 'diff --color=always '
alias diffy='diff --color=always --suppress-common-line -y'
alias diffu='diff --color=always -u'
alias jwt='python3.11 ~/repo/jwt_tool/jwt_tool.py'
alias note='zed ~/.notes/`\date +"%Y%m%d_%H%M%S.txt"`'
alias date='\date -Iseconds'

# adb
alias logcat='adb logcat'

# Git
alias g='git'

alias gs='git status'
alias ga='git add'
alias co='git commit'
alias gm='git commit'
alias gf='git diff'
alias gb='git branch'
alias gw='git switch'
alias gc='git switch -c'
alias gl='git log --graph'
alias gt='git tag'

alias main='git switch main'
alias add='git add'
alias commit='git commit'
alias push='git push'
alias pull='git pull'
alias fetch='git fetch'

# npm
alias nr='npm run'
alias dev='npm run dev'
alias debug='npm run debug'

# enables shell command completion for Stripe
fpath=(~/.stripe $fpath)
autoload -Uz compinit && compinit -i

source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# ruby
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# java
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

# android studio
export ANDROID_SDK=~/Library/Android/sdk/
export ANDROID_HOME=~/Library/Android/sdk/
export PATH=$PATH:~/Library/Android/sdk/platform-tools/

# avdmanager
export PATH=$PATH:~/Library/Android/sdk/cmdline-tools/latest/bin/

# emulator
export PATH=$PATH:~/Library/Android/sdk/emulator/
alias pixel='emulator -avd Pixel_8_API_35'

# aws
export AWS_DEFAULT_PROFILE=

# mini
alias mini='~/repos/mini-moulinette/mini-moul.sh'

# nim
export PATH="$HOME/.nimble/bin:$PATH"
export PATH="$HOME/.nimble/pkgs2:$PATH"
