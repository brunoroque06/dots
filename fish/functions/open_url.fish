function open_url
  set -l panes (tmux list-panes -s -F '#{pane_id}')
  set -l content
  for pane in $panes
    set -a content (tmux capture-pane -J -p -t $pane | tr '%' ' ') 
  end
  set -l IFS
  set -l urls (printf "$content" | grep -oE '[[:alnum:]-]+(?:[:\.][[:alnum:]-]+)+' | sort --unique | sed 's/^/http:\/\//' | tr ' ' '\n')
  if test -z "$urls"
    printf "No identitied urls"
  else
    printf "$urls" | fzf | xargs open
  end
end
