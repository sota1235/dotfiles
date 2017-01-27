# export envs
export LANG=ja_JP.UTF-8

# for pyenv
if [ -e $HOME/.pyenv ] ; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

# I love vim
export EDITOR=vim

# for npmrun
export DOTFILES_NPM_ERROR_LOG="$HOME/.dotfiles/dist/npm_error.log"
