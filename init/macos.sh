#!/bin/sh

# Installing Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
exec $SHELL -l

if which brew > /dev/null 2>&1 ; then
  $HOME/.dotfiles/init/macos/Brewfile.sh
fi

# Setting up system preference
$HOME/.dotfiles/init/macos/os_setup.sh

# Install nodebrew
curl -L git.io/nodebrew | perl - setup

# Install anyenv-update
mkdir -p $(anyenv root)/plugins
git clone https://github.com/znz/anyenv-update.git $(anyenv root)/plugins/anyenv-update
