# Vim
fish_vi_key_bindings

# Bat
set -Ux BAT_THEME 1337
set -Ux BAT_STYLE header,grid

# Bind
bind -M insert \ce accept-autosuggestion
bind -M insert \cn history-search-forward
bind -M insert \cp history-search-backward

# Command
set -U fish_color_command green
set -U fish_color_param normal
set -U fish_color_quote yellow

# FZF
set -Ux FZF_DEFAULT_OPTS '--border --reverse --height 20%'

# PATH
# set PATH /usr/local/bin /usr/sbin $PATH

# Prompt
set -U pure_symbol_prompt \$
set -U pure_symbol_git_unpulled_commits ▼
set -U pure_symbol_git_unpushed_commits ▲

# Abbreviations
source "$HOME"/.config/fish/abbreviations.fish
