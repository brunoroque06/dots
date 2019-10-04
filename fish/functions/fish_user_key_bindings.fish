function fish_user_key_bindings
  fzf_key_bindings
  bind -M insert \ce accept-autosuggestion
  bind -M insert \cn history-search-forward
  bind -M insert \cp history-search-backward
  bind -M insert \cf fzf-file-widget
  bind -M insert \cf fzf-file-widget
  bind -e -M insert \ct
  bind -e -M default \ct
end
