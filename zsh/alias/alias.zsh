#!/usr/bin/zsh

# include functions
source $HOME/.dotfiles/zsh/alias/functions.zsh

## Suffix aliases ##
# script language
alias -s py=python
alias -s rb=ruby
alias -s php=php
alias -s pl=perl
alias -s js=node
alias -s coffee=coffee
# image file
if which open > /dev/null 2>&1 ; then
  alias -s png="open"
  alias -s jpg="open"
  alias -s jpeg="open"
  alias -s gif="open"
fi

# others
alias -s txt=vim
if which open > /dev/null 2>&1 ; then
  alias -s md="open -a Mou"
  alias -s markdown="open -a Mou"
  alias -s pdf="open"
fi

## Global aliases ##
alias -g @g='| grep'
alias -g @l='| less -R'
alias -g @le='|& less -R'

# Super user
alias _="sudo"

# Basic directory operations
alias ...="cd ../.."
alias ....="cd ../../.."

# List derectory contents
if which gls > /dev/null 2>&1 ; then
  alias ls='gls -GF --color' # On OS X
else
  alias ls='ls -GF --color' # On Linux
fi
alias lsa='ls -lah'
alias l='ls -lh'
alias ll='ls -lh'
alias la='ls -lAh'

# Editor
alias vi="vim"

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

# Development for git init
alias readmeinit="cp $HOME/.dotfiles/template/README_template.md ./README.md"
alias licenseinit="cat $HOME/.dotfiles/template/LICENSE.txt | sed -e s/YEAR_POSITION/\`date +\"%Y\"\`/ >> ./LICENSE.txt"

# Middleman
alias newpost="middleman article"

# Others
alias grep="grep --color -n"
if which nkf > /dev/null 2>&1 ; then
  alias sgrep="sjis_grep"
fi
alias find_grep="find ./ -type f -print | xargs grep -n"
alias todo="find ./ -type f -print | xargs grep -n --color TODO"
alias history="history -i"

alias e="exit"
alias g="git"
alias b="brew"
