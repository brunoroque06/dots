# Vim
fish_vi_key_bindings

# Binds
bind -M insert \ce accept-autosuggestion
bind -M insert \cn history-search-forward
bind -M insert \cp history-search-backward

# Commands
set -U fish_color_command green
set -U fish_color_param normal
set -U fish_color_quote yellow

# set PATH /usr/local/bin /usr/sbin $PATH

# Prompt
set -U pure_symbol_prompt \$
set -U pure_symbol_git_unpulled_commits ▼
set -U pure_symbol_git_unpushed_commits ▲
set -U pure_reverse_prompt_symbol_in_vimode false
