#!/bin/zsh

###
# grep sjis
###
function sjis_grep() {
  grep `echo $1 | nkf -s` $2 | nkf -w
}
