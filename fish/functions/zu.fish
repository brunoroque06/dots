function zu
  set -l panes (tmux list-panes -s -F '#{pane_id}')
  set -l content
  for pane in $panes
    set -a content (tmux capture-pane -J -p -t $pane | tr '%' ' ')
  end
  set -l IFS
  set -l urls (printf "$content" | rg -o -e 'https?://[\w\-\.:]+' | tr ' ' '\n' | sort --unique)
  if test -z "$urls"
    printf "No urls identitied\n"
  else
    printf "$urls" | fzf-tmux | xargs -t open
  end
end
