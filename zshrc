#! /bin/bash

CUR=$(dirname ${0} | sed 's/\/.+$//')

# setopt vi
setopt emacs

setopt no_beep
setopt autocd
setopt share_history # ターミナル間でhistoryを共有する
setopt interactivecomments # zshでもコメントを使えるようにする

HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

LUA_PATH=~/repo/dotfiles

# aliases
[[ -f $CUR/aliases ]] && source $CUR/aliases

# functions
[[ -f $CUR/functions ]] && source $CUR/functions
