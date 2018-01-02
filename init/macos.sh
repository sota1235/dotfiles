#!/bin/sh

if which brew > /dev/null 2>&1 ; then
  $HOME/.dotfiles/init/macos/Brewfile.sh
fi
