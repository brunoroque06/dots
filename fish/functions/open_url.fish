function open_url
  set -l IFS
  set -l screen (tmux capture-pane -J -p)
  set -l urls (printf "$screen" | grep -oE '\\w+(?:\\.\\w+)+' | sed 's/[^ ]* */https:\/\/&/g' | tr ' ' '\n' | sort)
  if test -z "$urls"
    printf "No identitied urls"
  else
    printf "$urls" | fzf | xargs open
  end
end
