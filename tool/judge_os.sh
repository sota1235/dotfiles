#!/bin/sh

##
# Judging OS and return it
##
judge_os () {
  if [ "$(uname)" == 'Darwin' ]; then
    echo 'Mac'
    return
  elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    echo 'Linux'
    return
  elif [ "$(expr substr $(uname -s) 1 10)" == 'MINGW32_NT' ]; then
    echo 'Cygwin'
    return
  fi

  echo "Your platform ($(uname -a)) is not supported."
  exit 1
}
