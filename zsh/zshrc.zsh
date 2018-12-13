###
# ログイン時
###

# tmuxを起動する
if which tmux > /dev/null 2>&1 ; then
  [[ -z "$TMUX" && ! -z "$PS1" ]] && tmux -2
fi

# キーバインドをEmacs風に
bindkey -e

###
# プロンプト設定
###

# 色を使用できるようにする
autoload -Uz colors; colors

# hook関数を登録できるようにする
autoload -Uz add-zsh-hook

# バージョン判定
autoload -Uz is-at-least

### vcs_info設定 ###

# 以下の3つのメッセージをエクスポートする
#   $vcs_info_msg_0_ : 通常メッセージ(緑)
#   $vcs_info_msg_1_ : 警告メッセージ(黄)
#   $vcs_info_msg_2_ : エラーメッセージ(赤)
zstyle ':vcs_info:*' max-exports 3

# リポジトリの情報をとれるようにする
autoload -Uz vcs_info
zstyle ":vcs_info:*" enable git # gitのみ有効にする

# format
zstyle ":vcs_info:git:*" check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "✚" # %c
zstyle ':vcs_info:git:*' unstagedstr "✖"  # %u
zstyle ':vcs_info:git:*' formats "(%s):%F{blue}[%f%F{red}%b%f%F{blue}]%f %c%u"
zstyle ':vcs_info:git:*' actionformats "(%s):[%b]" "%m" "<!%a>"

if is-at-least 4.3.10; then
  # git 用のフォーマット
  # git のときはステージしているかどうかを表示
  zstyle ':vcs_info:git:*' formats '(%s):%F{blue}[%f%F{red}%b%f%F{blue}]%f' '%c%u %m'
  zstyle ':vcs_info:git:*' actionformats '(%s):[%b]' '%c%u %m' '<!%a>'
  zstyle ':vcs_info:git:*' check-for-changes true
  zstyle ':vcs_info:git:*' stagedstr "✚"    # %c で表示する文字列
  zstyle ':vcs_info:git:*' unstagedstr "✖"  # %u で表示する文字列
fi

# hooks 設定
if is-at-least 4.3.11; then
  # git のときはフック関数を設定する

  # formats '(%s)-[%b]' '%c%u %m' , actionformats '(%s)-[%b]' '%c%u %m' '<!%a>'
  # のメッセージを設定する直前のフック関数
  # 今回の設定の場合はformat の時は2つ, actionformats の時は3つメッセージがあるので
  # 各関数が最大3回呼び出される。
  zstyle ':vcs_info:git+set-message:*' hooks \
    git-hook-begin \
    git-untracked \
    git-push-status \
    git-nomerge-branch \
    git-stash-count

  # フックの最初の関数
  # git の作業コピーのあるディレクトリのみフック関数を呼び出すようにする
  # (.git ディレクトリ内にいるときは呼び出さない)
  # .git ディレクトリ内では git status --porcelain などがエラーになるため
  function +vi-git-hook-begin() {
  if [[ $(command git rev-parse --is-inside-work-tree 2> /dev/null) != 'true' ]]; then
    # 0以外を返すとそれ以降のフック関数は呼び出されない
    return 1
  fi

  return 0
}

# untracked ファイル表示
#
# untracked ファイル(バージョン管理されていないファイル)がある場合は
# unstaged (%u) に ? を表示
function +vi-git-untracked() {
# zstyle formats, actionformats の2番目のメッセージのみ対象にする
if [[ "$1" != "1" ]]; then
  return 0
fi

if command git status --porcelain 2> /dev/null \
  | awk '{print $1}' \
  | command grep -F '??' > /dev/null 2>&1 ; then

# unstaged (%u) に追加
hook_com[unstaged]+='?'
        fi
      }

      # push していないコミットの件数表示
      #
      # リモートリポジトリに push していないコミットの件数を
      # pN という形式で misc (%m) に表示する
      function +vi-git-push-status() {
      # zstyle formats, actionformats の2番目のメッセージのみ対象にする
      if [[ "$1" != "1" ]]; then
        return 0
      fi

      if [[ "${hook_com[branch]}" != "master" ]]; then
        # master ブランチでない場合は何もしない
        return 0
      fi

      # push していないコミット数を取得する
      local ahead
      ahead=$(command git rev-list origin/master..master 2>/dev/null \
        | wc -l \
        | tr -d ' ')

      if [[ "$ahead" -gt 0 ]]; then
        # misc (%m) に追加
        hook_com[misc]+="(p${ahead})"
      fi
    }

    # マージしていない件数表示
    #
    # master 以外のブランチにいる場合に、
    # 現在のブランチ上でまだ master にマージしていないコミットの件数を
    # (mN) という形式で misc (%m) に表示
    function +vi-git-nomerge-branch() {
    # zstyle formats, actionformats の2番目のメッセージのみ対象にする
    if [[ "$1" != "1" ]]; then
      return 0
    fi

    if [[ "${hook_com[branch]}" == "master" ]]; then
      # master ブランチの場合は何もしない
      return 0
    fi

    local nomerged
    nomerged=$(command git rev-list master..${hook_com[branch]} 2>/dev/null | wc -l | tr -d ' ')

    if [[ "$nomerged" -gt 0 ]] ; then
      # misc (%m) に追加
      hook_com[misc]+="(m${nomerged})"
    fi
  }


  # stash 件数表示
  #
  # stash している場合は :SN という形式で misc (%m) に表示
  function +vi-git-stash-count() {
  # zstyle formats, actionformats の2番目のメッセージのみ対象にする
  if [[ "$1" != "1" ]]; then
    return 0
  fi

  local stash
  stash=$(command git stash list 2>/dev/null | wc -l | tr -d ' ')
  if [[ "${stash}" -gt 0 ]]; then
    # misc (%m) に追加
    hook_com[misc]+=":S${stash}"
  fi
}
fi

function _update_vcs_info_msg() {
local -a messages

LANG=en_US.UTF-8 vcs_info
if [[ -z ${vcs_info_msg_0_} ]]; then
  RPROMPT=""
else
  [[ -n "$vcs_info_msg_0_" ]] && messages+=("%F{green}${vcs_info_msg_0_}%f")
  [[ -n "$vcs_info_msg_1_" ]] && messages+=("%F{yellow}${vcs_info_msg_1_}%f")
  [[ -n "$vcs_info_msg_2_" ]] && messages+=("%F{red}${vcs_info_msg_2_}%f")

  RPROMPT="${(j: :)messages}"
fi
}
add-zsh-hook precmd _update_vcs_info_msg

# もしかして機能
setopt correct

# PCRE互換の正規表現を使う
setopt re_match_pcre

# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
setopt prompt_subst

# プロンプト指定
ret_status=" \
%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[blue]%}➜ %s)\
%{${fg_bold[yellow]}%}%c%{${reset_color}%}\
%(?.%{$fg_bold[green]%}.%{$fg_bold[blue]%}) %(?!(*･-･%) <!(*;_;%)? <)%{${reset_color}%} "

PROMPT="$ret_status"
RPROMPT="${vcs_info_msg_0_}"

# プロンプト指定(コマンドの続き)
PROMPT2='[%n]> '

# もしかして時のプロンプト指定
SPROMPT="%{$fg_bold[red]%}%{$suggest%}(・´ｰ・｀%)? < もしかして %B%r%b %{$fg_bold[red]%}かな? [そう!(y), 違う!(n), a, e]:${reset_color} "

###
# 補完
###

# 補完機能を有効にする
autoload -Uz compinit
compinit

# 補完候補をハイライトする
zstyle ':completion:*:default' menu select=2

# 補完で小文字/大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..

# ディレクトリ名を補完すると、末尾がスラッシュになる
setopt auto_param_slash

# 補完候補がない時にbeep音を鳴らさない
setopt no_beep

# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /user/local/sbin /usr/local/bin \
  /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

# ファイル補完候補に色をつける
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

###
# 各種ハイライト
###
# manページに色付け
export MANPAGER='less -R'
man() {
  env \
    LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    LESS_TERMCAP_md=$(printf "\e[1;31m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;32m") \
    man "$@"
}

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
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt extended_history
setopt share_history
setopt hist_reduce_blanks

###
# 外部ファイル読み込み
###

# read functions
source $HOME/.dotfiles/zsh/functions/keybind.zsh
zle -N my_enter
bindkey '^m' my_enter

# alias読み込み
source $HOME/.dotfiles/zsh/alias/alias.zsh

# directory色付け
if [ -x "`which dircolors`" ]; then
  eval $(dircolors $HOME/.dotfiles/zsh/lib/dircolors.ansi-universal)
elif [ -x "`which gdircolors`" ]; then
  eval $(gdircolors $HOME/.dotfiles/zsh/lib/dircolors.ansi-universal)
fi

###
# Setup
###

### anyenv ###
if [ -e $HOME/.anyenv ]; then
  export PATH="$HOME/.anyenv/bin:$PATH"
  eval "$(anyenv init -)"

  # For tmux
  for D in `\ls $HOME/.anyenv/envs`
  do
    export PATH="$HOME/.anyenv/envs/$D/shims:$PATH"
  done
fi

### rbenv ###
if [ -e $HOME/.rbenv ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

### nvm ###
if [ -e $HOME/.nvm ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
fi

### peco ###
if which peco > /dev/null 2>&1 ; then
  function peco-select-history() {
  local tac
  if which tac > /dev/null; then
    tac="tac"
  else
    tac="tail -r"
  fi
  BUFFER=$(\history -n 1 | \
    eval $tac | \
    peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history
fi

### composer global commands ###
if [ -e $HOME/.composer ]; then
  PATH="$HOME/.composer/vendor/bin:$PATH"
fi

### zsh-completions ###
fpath=($HOME/.dotfiles/zsh/lib/zsh-completions/src $fpath)
compinit # fpathの後ろで宣言する必要がある

###
# PATH
###
# オリジナルコマンド
export PATH="$HOME/.dotfiles/zsh/bin:$PATH"

# Local bin files
export PATH="$HOME/.dotfiles/local:$PATH"

# 外部パスファイルの読み込み
source $HOME/.zsh_own_config
source $HOME/.zsh_alias

# http://qiita.com/kwgch/items/445a230b3ae9ec246fcb
setopt nonomatch

# For google cloud sdk
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'

# For golang
export GOPATH=$HOME/go

# nodebrew
export PATH=$HOME/.nodebrew/current/bin:$PATH
