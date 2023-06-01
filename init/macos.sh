#!/bin/sh

# Installing Homebrew
if ! which brew > /dev/null 2>&1 ; then
  printf "${BOLD}${BLUE}Installing Homebrew${NORMAL}\n"

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  exec $SHELL -l

  (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zsh_own_config

  # https://github.com/Homebrew/homebrew-autoupdate
  brew tap homebrew/autoupdate
  brew autoupdate start
fi

# Installing apps via HomeBrew
$HOME/.dotfiles/init/macos/Brewfile.sh

# Setting up system preference
printf "${BOLD}${BLUE}Update settings of macOS${NORMAL}\n"
$HOME/.dotfiles/init/macos/os_setup.sh

# Install nodebrew
if ! which nodebrew > /dev/null 2>&1 ; then
  printf "${BOLD}${BLUE}Install nodebrew${NORMAL}\n"
  curl -L git.io/nodebrew | perl - setup
fi
