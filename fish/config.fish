set -U fish_greeting 'Oo'

# Vim
fish_vi_key_bindings

# Abbreviations
source "$HOME"/.config/fish/abbreviations.fish

# Completions
complete -c pip -a '(__fish_complete_suffix .whl)' -n '__fish_seen_subcommand_from install'
complete -c unzip -a '(__fish_complete_suffix .pex; __fish_complete_suffix .whl)'

# Bat
set -Ux BAT_THEME 1337
set -Ux BAT_STYLE grid,numbers

# Fzf
set -Ux FZF_DEFAULT_COMMAND 'fd . --type f --hidden -E .git'
set -Ux FZF_DEFAULT_OPTS '--border --reverse --height 20%'
set -Ux FZF_ALT_C_COMMAND 'fd . --type d --hidden -E .git'
set -Ux FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND

# Java
set -Ux JAVA_HOME /Library/Java/JavaVirtualMachines/adoptopenjdk-13.0.2.jdk/Contents/Home

# Path
set -x PATH /usr/local/opt/ruby/bin $PATH "$HOME"/.dotnet/tools "$HOME"/.cargo/bin (go env GOPATH)/bin

# Pulumi
set -Ux PULUMI_PREFER_YARN 'true'

# Theme
set -U fish_color_command green
set -U fish_color_param normal
set -U fish_color_quote yellow

set -e fish_user_paths

eval (starship init fish)
