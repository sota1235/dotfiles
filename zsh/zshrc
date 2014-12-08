# 空Enterした時にls, git status -sbを順番に実行する
# Thanks for http://qiita.com/znz/items/559721cbf238d77de6bb
function my_enter {
  if [[ -n "$BUFFER" ]]; then
    builtin zle .accept-line
    return 0
  fi
  if [ "$WIDGET" != "$LASTWIDGET" ]; then
    MY_ENTER_COUNT=0
  fi
  case $[MY_ENTER_COUNT++] in
    0)
      BUFFER=" ls"
      ;;
    1)
      if [[ -d .svn ]]; then
        BUFFER=" svn status"
      elif git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        BUFFER=" git status -sb"
      fi
      ;;
    *)
      unset MY_ENTER_COUNT
      ;;
  esac
  builtin zle .accept-line
}
zle -N my_enter
bindkey '^m' my_enter
