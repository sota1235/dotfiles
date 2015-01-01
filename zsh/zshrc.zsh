###
#
# History
#
###
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt extended_history
setopt share_history
setopt hist_reduce_blanks

# read functions
source ~/.dotfiles/zsh/functions/keybind.zsh
zle -N my_enter
bindkey '^m' my_enter

source ~/.dotfiles/zsh/alias/alias.zsh
