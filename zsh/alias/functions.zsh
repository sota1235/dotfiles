#!/bin/zsh

# move files to ~/.Trash
function rmf() {
  for file in $*
  do
    mv $file ~/.Trash
  done
}

function _rmf(){
  _arguments \
    '*: :_files'
}
