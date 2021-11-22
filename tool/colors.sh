#!/bin/bash

load_colors() {
  # Use colors, but only if connected to a terminal, and that terminal
  # supports them.
  # thanks for oh-my-zsh - https://github.com/robbyrussell/oh-my-zsh
  tput=$(which tput)
  if [ -n "$tput" ]; then
      ncolors=$($tput colors)
  fi
  if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    BOLD="$(tput bold)"
    NORMAL="$(tput sgr0)"
  else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    BOLD=""
    NORMAL=""
  fi
}
