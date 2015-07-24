
# 色を使用できるようにする
autoload -Uz colors
colors

###
# ログイン時
###

# tmuxを起動する
[[ -z "$TMUX" && ! -z "$PS1" ]] && tmux

###
# 補完
###

# 補完機能を有効にする
autoload -Uz compinit
compinit

# 補完で小文字/大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..

# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /user/local/sbin /usr/local/bin \
  /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

###
# オプション
###

# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# ディレクトリ名だけでcdする
setopt auto_cd

# cd したら自動的にpushdする
setopt auto_pushd
# 重複したディレクトリを追加しない
setopt pushd_ignore_dups

# 高機能なワイルドカード展開を使用する
setopt extended_glob

###
# History
###
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt extended_history
setopt share_history
setopt hist_reduce_blanks

###
# 外部ファイル読み込み
###

# read functions
source ~/.dotfiles/zsh/functions/keybind.zsh
zle -N my_enter
bindkey '^m' my_enter

# alias読み込み
source ~/.dotfiles/zsh/alias/alias.zsh
