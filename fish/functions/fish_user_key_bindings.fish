function fish_user_key_bindings
  fzf_key_bindings

  bind -M insert -k dc delete-char
  bind -M insert \ca fzf-history-widget
  bind -M insert \ce accept-autosuggestion
  bind -M insert \cf fzf-file-widget
  bind -M insert \cn history-prefix-search-forward
  bind -M insert \cp history-prefix-search-backward
  bind -M insert \e\x7F backward-kill-word

  bind -M default -k dc forward-char
end
