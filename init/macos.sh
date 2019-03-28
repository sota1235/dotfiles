#!/bin/sh

if which brew > /dev/null 2>&1 ; then
  $HOME/.dotfiles/init/macos/Brewfile.sh
fi

# Setting up system preference
$HOME/.dotfiles/init/macos/os_setup.sh
