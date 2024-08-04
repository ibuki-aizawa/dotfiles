set -o vi
setopt no_beep

# no wrapping
tput smam

# zshでもコメントを使えるようにする
setopt interactivecomments

export REACT_EDITOR=vim

# aliases
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
alias glog='git log --graph'
alias jwt='python3.11 ~/repos/jwt_tool/jwt_tool.py'
