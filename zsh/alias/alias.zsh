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
alias -s png="open"
alias -s jpg="open"
alias -s jpeg="open"
alias -s gif="open"

# others
alias -s txt=vim
alias -s md="open -a Mou"
alias -s markdown="open -a Mou"
alias -s pdf="open"

## Global aliases ##
alias -g @g='| grep'
alias -g @l='| less -R'

## Normal Alias ##
# Remote Login
alias sota="ssh sota@sota1235.net"
alias t11460ss="ssh t11460ss@ccx00.sfc.keio.ac.jp"
alias webedit="ssh t11460ss@webedit.sfc.keio.ac.jp"

# Super user
alias _="sudo"
alias please="sudo"

# Basic directory operations
alias ...="cd ../.."

# List derectory contents
alias ls='ls -GF --color'
alias lsa='ls -lah'
alias l='ls -lh'
alias ll='ls -lh'
alias la='ls -lAh'

# Editor
alias vi="vim"

# Development for git init
alias readmeinit="cp $HOME/.dotfiles/template/README_template.md ./README.md"
alias licenseinit="cp $HOME/.dotfiles/template/LICENSE.txt ./LICENSE.txt"

# Change Directory
alias sota1235="cd $HOME/Documents/sota1235"
alias github="cd $HOME/Documents/sota1235/github"
alias blog="cd $HOME/Documents/sota1235/Now_Running/blog"

# Middleman
alias newpost="middleman article"

# Others
alias grep="grep --color -n"
alias sgrep="sjis_grep"
alias find_grep="find ./ -type f -print | xargs grep -n"

alias e="exit"
alias g="git"
alias b="brew"
alias c="clear"
