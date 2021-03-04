function fish_user_key_bindings
  fzf_key_bindings

  bind -M insert -k dc delete-char
  bind -M insert \ca fzf-history-widget
  bind -M insert \cf fzf-file-widget
  bind -M insert \cj history-search-forward
  bind -M insert \ck history-search-backward
  bind -M insert \cl accept-autosuggestion
  bind -M insert \cw backward-kill-word
  bind -M insert \e\x7F backward-kill-word
  bind -M insert \cx fzf-cd-widget

  bind -M default -k dc forward-char
end
