#!/usr/bin/zsh

## Suffix aliases ##
alias -s py=python
alias -s rb=ruby
alias -s php=php
alias -s pl=perl
alias -s js=node
alias -s coffee=coffee
alias -s txt=vim

## Normal Alias ##
# Remote Login
alias sota="ssh sota@sota1235.net"
alias t11460ss="ssh t11460ss@ccx00.sfc.keio.ac.jp"
alias webedit="ssh t11460ss@webedit.sfc.keio.ac.jp"

# Editor
alias vi="vim"

# Development for git init
alias readmeinit="cp ~/dotfiles/static/README_template.md ./README.md"
alias licenseinit="cp ~/dotfiles/static/LICENSE.txt ./LICENSE.txt"

# Change Directory
alias sota1235="cd ~/Documents/sota1235"
alias github="cd ~/Documents/sota1235/github"
alias blog="cd ~/Documents/sota1235/Now_Running/blog"

# Middleman
alias newpost="middleman article"

# Others
alias grep="grep --color -n"
alias find_grep="find ./ -type f -print | xargs grep -n"
alias e="exit"
