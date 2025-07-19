#! /bin/bash

CUR=$(dirname ${0} | sed 's/\/.+$//')

# ビープ音を鳴らさない
setopt no_beep

# cd 省略
setopt autocd

# ターミナル間でhistoryを共有する
# setopt share_history

# zshでもコメントを使えるようにする
setopt interactivecomments

HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# setopt emacs
setopt vi

function peco_history() {
  BUFFER=`history -$HISTSIZE | sort -r | cut -d ' ' -f 4- | awk '!a[$0]++' | peco`
  zle reset-prompt
  zle accept-line
}
zle -N peco_history
bindkey "^_" peco_history

# alias l='ls -Glat'
alias l='ls -hltr --color=always'
alias la='ls -hAltr --color=always'
# alias ll='ls -GAhltr'
alias ll='ls -Ghaltr'

# editors
alias vi='nvim'
alias e='emacsclient -t'
alias ec='emacsclient -c'
alias et='emacsclient -t'
alias emacs-deamon="emacs --daemon"
alias emacs-kill="emacsclient -e '(kill-emacs)'"
alias emacs-restart="emacsclient -e '(restart-emacs)'"

# grep
alias grep='grep --color=auto'
alias grepf='grep -Rin --color=auto --exclude-dir={node_modules,.git,dist,.next,build}'
alias grepl='grep -Rinl --color=auto --exclude-dir={node_modules,.git,dist,.next,build}'

# nkf
alias url_decode='nkf -w --url-input'

#alias diff= 'diff --color=always '
alias diffy='diff --color=always --suppress-common-line -y'
alias diffu='diff --color=always -u'

# fzf
alias fzf='fzf --preview "bat --color=always --style=numbers --line-range :500 {}"'
alias vif='vi $(fzf)'

# macOS
alias clip='pbcopy'

# Git
alias g='git'

alias gs='git status'
alias gsw='git show'
alias ga='git add'
alias gc='git commit'
alias gch='git checkout'
alias gd='git diff'
alias gb='git branch'
alias gw='git switch'
alias gl='git log --graph'
alias gt='git tag'
alias gf='git fetch'

alias push='git push'
alias pull='git pull'
alias clone='git clone'

# npm
alias nr='npm run'
alias nt='npm run test'
alias dev='npm run dev'

NOTES_DIR=~/.notes
EDITOR='nvim'

# Function to create a new note
note () {
  dir=~/$NOTES_DIR/`\date +"%Y%m%d"`

  if [ $# -eq 0 ]; then
    filename=$dir/`\date +"%H%M%S.txt"`
  else
    filename=$dir/`\date +"%H%M%S_$1.txt"`
  fi

  $EDITOR $filename
}

# Function to open the notes directory
notes () {
  dir=~/$NOTES_DIR
  $EDITOR $dir
}

# l () {
#  ls -hlt --color=always $* | head -n 20
#}

#la () {
#  ls -hAlt --color=always $* | head -n 20
#}

