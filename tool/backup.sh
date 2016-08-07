#!/bin/sh

###
# Copy and rename the file, *.backup
###

backupDotFiles () {
  TARGET_FILE_NAME=$1

  if [ -e $HOME/$TARGET_FILE_NAME ]; then
    cp $HOME/$TARGET_FILE_NAME $HOME/$TARGET_FILE_NAME.backup
  fi

  return
}
