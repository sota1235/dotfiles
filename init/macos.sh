#!/bin/sh

# Installing Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

if which brew > /dev/null 2>&1 ; then
  $HOME/.dotfiles/init/macos/Brewfile.sh
fi

# Setting up system preference
$HOME/.dotfiles/init/macos/os_setup.sh

# Create custom apps
$HOME/.dotfiles/init/macos/nativefier.sh

# Install nodebrew
curl -L git.io/nodebrew | perl - setup
