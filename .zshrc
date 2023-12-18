set -o vi
setopt no_beep

export ANDROID_SDK=~/Library/Android/sdk/
export ANDROID_HOME=~/Library/Android/sdk/
export PATH=$PATH:~/Library/Android/sdk/platform-tools/
export PATH="/opt/homebrew/opt/unzip/bin:$PATH"
export JAVA_HOME=$(/usr/libexec/java_home)

export N_PREFIX=$HOME/.n
export PATH=$N_PREFIX/bin:$PATH

export REACT_EDITOR=vim

alias l='ls -CF'
alias la='ls -a'
alias ll='ls -l'
alias sjis_unzip='unzip -O sjis'
alias clip='pbcopy'
alias grepl='grep -A 2 -B 2 -Rn --color=auto --exclude-dir={node_modules,.git,dist}'

# enables shell command completion for Stripe
fpath=(~/.stripe $fpath)
autoload -Uz compinit && compinit -i

