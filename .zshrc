# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#! /bin/bash

# CUR=$(dirname ${0} | sed 's/\/.+$//')

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
# bindkey "^_" peco_history
bindkey "^y" peco_history

alias nop=':'

# alias l='ls -Glat'
alias l='ls -hltr --color=always'
alias la='ls -hAltr --color=always'
# alias ll='ls -GAhltr'
alias ll='ls -Ghaltr'

# editors
alias vi='nvim'
alias e='emacsclient -c'
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
alias vif='vi $(fzf --walker-skip=.git,node_modules,dist,.next,build)'

alias fcat='cat $(fzf --walker-skip=.git,node_modules,dist,.next,build)'

# ファイルを開く際の便利関数
# - 引数がなければ、gitで変更されたファイル一覧を表示して選択して開く
# - 引数があれば、その文字列でファイル名を検索して選択して開く
v() {
  local search="$1"
  local file list

  if [ -z "$search" ]; then
    # 引数なし：修正中のファイルを表示
    # list=$(git ls-files -m)
    list=$(git ls-files -m -o --exclude-standard)

    if [ -z "$list" ]; then
      # 修正中がなければ普通にエディタを起動
      $EDITOR
      return 0
    fi
  else
    # 引数あり：ファイルが存在すれば即座に開く
    if [ -f "$search" ]; then
      $EDITOR "$search"
      return 0
    fi

    # ファイル検索（fd を使用、.git は除外）
    # -H は隠しファイル、-E は除外
    list=$(fd -H -E ".git" --type f "$search" 2> /dev/null)

    if [ -z "$list" ]; then
      echo "No matching files found."
      return 1
    fi
  fi

  # 1件なら即起動、複数あれば選択
  if [ $(echo "$list" | wc -l) -eq 1 ]; then
    file="$list"
  else
    # fzf を使っているなら fzf に、peco が良ければ peco に
    file=$(echo "$list" | fzf --query "$search" --select-1 --exit-0)
  fi

  # 選択されたら開く
  [ -n "$file" ] && $EDITOR "$file"
}

# bat
if [[ "$OSTYPE" == "linux"* ]]; then
  # linux の場合は、batcat になっている
  alias bat='batcat'
fi

# macOS
alias clip='pbcopy'

# Git
alias g='git'

alias gs='git status'
alias gsw='git show'
alias ga='git add'
alias gc='git commit'
alias gm='git commit'
alias gch='git checkout'
alias gd='git diff'
alias gb='git branch'
alias gw='git switch'
alias gl='git log --graph'
alias gt='git tag'
alias gf='git fetch'

alias clone='git clone'
alias fetch='git fetch'
alias pull='git pull'
alias push='git push'
alias stash='git stash'

alias gdf='git ls-files -m | fzf -m | xargs -r git diff'
alias gaf='git ls-files -m -o --exclude-standard | fzf -m | xargs -r git add'
# alias gwf='git branch | grep -v "^*" | fzf | xargs -r git checkout'
alias gsw='git branch --all | grep -v "^*" | fzf | sed "s/.* //" | xargs -r git switch'
alias grs='git ls-files -m | fzf -m | xargs -r git restore'

# npm
alias nr='npm run'
alias nt='npm run test'
alias dev='npm run dev'

NOTES_DIR=~/.notes
EDITOR='nvim'
CAT='bat'
# GREP='grep -Rin --color=auto --exclude-dir={node_modules,.git,dist,.next,build}'
GREP='rg'

# Function to create a new note
note() {
  if [ ! -d $NOTES_DIR ]; then
    mkdir -p $NOTES_DIR
  fi

  # dir=~/$NOTES_DIR/`\date +"%Y%m%d"`
  # dir=$NOTES_DIR

  if [ ! -d $NOTES_DIR ]; then
    mkdir -p $NOTES_DIR
  fi

  if [ $# -eq 0 ]; then
    filename=$NOTES_DIR/`\date +"%Y%m%d.txt"`
  else
    filename=$NOTES_DIR/`\date +"%Y%m%d_$1.txt"`
  fi

  # ファイルがなければ、前回のノートの内容をコピーする
  # 前回のノートもなければ、新規作成
  # $1 が指定されていれば、新規作成
  if [ ! -f $filename ]; then
    touch $filename

    # last_note=$(ls -t $NOTES_DIR | head -n 1)
    # echo $last_note
    # if [ -n "$last_note" ] && [ $# -eq 0 ]; then
    #   echo 'Copying from last note: '$last_note > $filename
    #   cat $NOTES_DIR/$last_note >> $filename
    # fi
  fi

  $EDITOR $filename
}

notecat() {
  if [ $# -eq 0 ]; then
    filename=$NOTES_DIR/`\date +"%Y%m%d.txt"`
  else
    filename=$NOTES_DIR/`\date +"%Y%m%d_$1.txt"`
  fi

  $CAT $filename
}

# Function to search notes
notegrep() {
  if [ ! -d $NOTES_DIR ]; then
    echo "Notes directory does not exist."
    return 1
  fi

  if [ $# -eq 0 ]; then
    echo "Please provide a search term."
    return 1
  fi

  term=$1
  # grep -Rin --color=auto --exclude-dir={node_modules,.git,dist,.next,build} "$term" $NOTES_DIR
  $GREP --no-line-number "$term" $NOTES_DIR
}

# Function to open the notes directory
notes() {
  $EDITOR $NOTES_DIR
}

notetail() {
  filename=$NOTES_DIR/`\date +"%Y%m%d.txt"`

  if [ $# -eq 1 ]; then
    n=$1
  else
    n=20
  fi

  tail -n $n $filename
}

notehead() {
  filename=$NOTES_DIR/`\date +"%Y%m%d.txt"`

  if [ $# -eq 1 ]; then
    n=$1
  else
    n=20
  fi

  head -n $n $filename
}

# l () {
#  ls -hlt --color=always $* | head -n 20
#}

#la () {
#  ls -hAlt --color=always $* | head -n 20
#}

if [[ -f "$HOME/.cargo/env" ]]; then
  . "$HOME/.cargo/env"
fi

export PATH="/usr/local/Python27/bin/:$PATH"

if [[ "$OSTYPE" == "linux"* ]]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
elif [[ "$OSTYPE" == "darwin"* ]]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" # This loads nvm
  [ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion
fi

# export JAVA_HOME=`/usr/libexec/java_home -v 11.0.23`

# Android dev
export ANDROID_SDK=~/Library/Android/sdk/
export ANDROID_HOME=~/Library/Android/sdk/
export PATH=$PATH:$ANDROID_HOME/platform-tools
# avdmanager
export PATH=$PATH:~/Library/Android/sdk/cmdline-tools/latest/bin/
# emulator
export PATH=$PATH:~/Library/Android/sdk/emulator/
alias pixel='emulator -avd Pixel_8_API_35'

[[ -f ~/repo/z/z.sh ]] && source ~/repo/z/z.sh

# source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
source ~/repo/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[[ -f ~/.zsh_profile ]] && source ~/.zsh_profile

# postgresql
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"

# fzf で fd を使う
# export FZF_DEFAULT_COMMAND='fd -H --type f'
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
