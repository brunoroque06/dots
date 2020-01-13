function open_url
  set -l IFS
  set -l screen (tmux capture-pane -J -p)
  set -l urls (printf "$screen" | grep -oE '[[:alnum:]-]+(?:[:\.][[:alnum:]-]+)+' | sed 's/[^ ]* */https:\/\/&/g' | tr ' ' '\n' | sort --unique)
  if test -z "$urls"
    printf "No identitied urls"
  else
    printf "$urls" | fzf | xargs open
  end
end
