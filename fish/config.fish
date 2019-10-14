# Vim
fish_vi_key_bindings

# Bat
set -Ux BAT_THEME 1337
set -Ux BAT_STYLE header,grid

# Command
set -U fish_color_command green
set -U fish_color_param normal
set -U fish_color_quote yellow

# FZF
set -Ux FZF_DEFAULT_COMMAND 'rg --files'
set -Ux FZF_DEFAULT_OPTS '--border --reverse --height 20%'
set -Ux FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND

# Abbreviations
source "$HOME"/.config/fish/abbreviations.fish

# Prompt
eval (starship init fish)
