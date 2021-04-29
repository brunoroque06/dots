function fish_user_key_bindings
  fzf_key_bindings

  bind -M insert -k dc delete-char
  bind -M insert \cf fzf-file-widget
  bind -M insert \e\x7F backward-kill-word

  bind -M default -k dc forward-char
end
