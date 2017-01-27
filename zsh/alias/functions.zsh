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
function aliasadd() {
  # 引数個数チェック
  if ! test $# -eq 2 ; then
    echo "Error: Invalid Arguments"
    exit 1
  fi

  # 既存のコマンドの場合、警告を表示"
  if which $1 > /dev/null 2>&1 ; then
    echo -n "Warning: The command is already exists. Will you overwrite the command? [n/Y] "
    ANSWER=""
    read ANSWER
    if [ $ANSWER != "Y" ]; then
      echo "aliasadd failed"
      exit 1
    fi
  fi

  # ~/.zsh_aliasに書き込み
  echo "alias $1=\"$2\"" >> $HOME/.zsh_alias
  echo "Your own alias is added! Run the 'exec zsh'"
}

###
# npm run with slim
###
function npmrun() {
  npm run $1 2>$DOTFILES_NPM_ERROR_LOG

  if [ ! $? -eq 0 ]; then
    echo "npm error log recorded at $DOTFILES_NPM_ERROR_LOG"
    return 1
  fi
}
