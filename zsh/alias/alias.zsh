#!/usr/bin/zsh

# include functions
source $HOME/.dotfiles/zsh/alias/functions.zsh

###
# Checking OS
###
if [[ $OSTYPE = "darwin"* ]]; then
  IS_MACOS="true"
else
  IS_MACOS="false"
fi

## Suffix aliases ##
# script language
alias -s py=python
alias -s rb=ruby
alias -s php=php
alias -s pl=perl
alias -s js=node

if which open > /dev/null 2>&1 ; then
  # image file
  alias -s png="open"
  alias -s jpg="open"
  alias -s jpeg="open"
  alias -s gif="open"
  # others
  alias -s pdf="open"
fi

alias -s txt=vim

## Global aliases ##
alias -g @g='| grep'
alias -g @l='| less -R'
alias -g @le='|& less -R'
alias -g @cb='| pbcopy'

# Super user
alias _="sudo"

# Basic directory operations
alias ...="cd ../.."
alias ....="cd ../../.."

# List directory contents
if [[ ${IS_MACOS} = "true" ]]; then
  # macOS
  if which gls > /dev/null 2>&1 ; then
    alias ls='gls -GF --color'
  fi
else
  # Linux
  alias ls='ls -GF --color'
fi
alias lsa='ls -lah'
alias l='ls -lh'
alias ll='ls -lh'
alias la='ls -lAh'

# Default mv option
alias mv='mv -i'

# Editor
alias vi="vim"
alias v="vim"

# Start tmux with using 256 color mode
alias tmux="tmux -2"

# Git
alias gst="git status"
alias gl="git log"
alias gl1="git log --oneline"
alias gfp="git fetch --prune"
alias gci="git commit"
alias gco="git checkout"
alias wip="git commit --allow-empty -m wip"
alias gb="git branch"
alias cdgr='cd $(git rev-parse --show-toplevel)'

# Development for git init
alias readmeinit="cp $HOME/.dotfiles/template/README_template.md ./README.md"
alias licenseinit="cat $HOME/.dotfiles/template/LICENSE.txt | sed -e s/YEAR_POSITION/\`date +\"%Y\"\`/ >> ./LICENSE.txt"

# Docker
alias docker-ps-name="docker ps | awk '{print \$NF}'"

# Others
alias grep="grep --color -n"
if which nkf > /dev/null 2>&1 ; then
  alias sgrep="sjis_grep"
fi
alias find_grep="find ./ -type f -print | xargs grep -n"
alias todo="find ./ -type f -print | xargs grep -n --color TODO"
alias history="history -i"
alias keynotesyntax="highlight -O rtf -s earendel -K 27 -k 'Courier'"
alias keynotesyntaxwhite="highlight -O rtf -s andes -K 27 -k 'Courier'"
alias unixtime="date +%s"

alias e="exit"
alias g="git"


# macOS
if [[ ${IS_MACOS} = "true" ]]; then
  # Homebrew
  alias b="brew"
  alias brews='brew update && brew upgrade && brew cleanup; brew cask cleanup; brew doctor'

  alias open='reattach-to-user-namespace open'
  alias rm='trash'
fi
