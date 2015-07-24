###
# ログイン時
###

# tmuxを起動する
[[ -z "$TMUX" && ! -z "$PS1" ]] && tmux

###
# プロンプト設定
###

# 色を使用できるようにする
autoload -Uz colors; colors

# もしかして機能
setopt correct

# PCRE互換の正規表現を使う
setopt re_match_pcre

# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
setopt prompt_subst

# プロンプト指定
PROMPT="
[%n] %{${fg[yellow]}%}%~%{${reset_color}%}
%(?.%{$fg[green]%}.%{$fg[blue]%})%(?!(*'-') <!(*;-;%)? <)%{${reset_color}%} "

# プロンプト指定(コマンドの続き)
PROMPT2='[%n]> '

# もしかして時のプロンプト指定
SPROMPT="%{$fg[red]%}%{$suggest%}(*'~'%)? < もしかして %B%r%b %{$fg[red]%}かな? [そう!(y), 違う!(n), a, e]:${reset_color} "

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
