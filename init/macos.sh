#!/bin/sh

# Installing Homebrew
if ! which brew > /dev/null 2>&1 ; then
  printf "${BOLD}${BLUE}Installing Homebrew${NORMAL}\n"

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  exec $SHELL -l
  $HOME/.dotfiles/init/macos/Brewfile.sh

  # https://github.com/Homebrew/homebrew-autoupdate
  brew tap homebrew/autoupdate
  brew autoupdate start
fi

# Setting up system preference
printf "${BOLD}${BLUE}Update settings of macOS${NORMAL}\n"
$HOME/.dotfiles/init/macos/os_setup.sh

# Install nodebrew
if ! which nodebrew > /dev/null 2>&1 ; then
  printf "${BOLD}${BLUE}Install nodebrew${NORMAL}\n"
  curl -L git.io/nodebrew | perl - setup
fi

# Install anyenv-update
printf "${BOLD}${BLUE}Install anyenv-update${NORMAL}\n"
mkdir -p $(anyenv root)/plugins
git clone https://github.com/znz/anyenv-update.git $(anyenv root)/plugins/anyenv-update
