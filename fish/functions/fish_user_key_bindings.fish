function fish_user_key_bindings
  fzf_key_bindings

  bind -M insert -k dc delete-char
  bind -M insert \ce accept-autosuggestion
  bind -M insert \cf fzf-file-widget
  bind -M insert \cn history-search-forward
  bind -M insert \cp history-search-backward
  bind -M insert \e\x7f backward-kill-word
  bind -e -M insert \ct

  bind -M default -k dc forward-char
  bind -e -M default \ct
end
