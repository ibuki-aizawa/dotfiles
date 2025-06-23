#! /bin/bash

CUR=$(dirname ${0} | sed 's/\/.+$//')

setopt vi

setopt no_beep
setopt autocd
setopt share_history # ターミナル間でhistoryを共有する
setopt interactivecomments # zshでもコメントを使えるようにする

if [ -f $CUR/aliases ]; then
  source $CUR/aliases
fi

HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

LUA_PATH=~/repo/dotfiles

