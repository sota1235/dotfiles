#!/bin/zsh

###
# grep sjis
###

function sjis_grep() {
  grep `echo $1 | nkf -s` $2 | nkf -w
}

###
# add new alias
###

# TODO: 引数の個数等、エラー処理
function aliasadd() {
  echo "alias $1=\"$2\"" >> ~/.dotfiles/zsh/alias/addalias.zsh
}
