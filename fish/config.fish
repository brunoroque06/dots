# Vim
fish_vi_key_bindings

# Bat
set -Ux BAT_THEME 1337
set -Ux BAT_STYLE grid

# Command
set -U fish_color_command green
set -U fish_color_param normal
set -U fish_color_quote yellow

# FZF
set -Ux FZF_DEFAULT_COMMAND 'rg --files --hidden -g !.git/'
set -Ux FZF_DEFAULT_OPTS '--border --reverse --height 20%'
set -Ux FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND

# Abbreviations
source "$HOME"/.config/fish/abbreviations.fish

# Completions
complete -c unzip -x -a '(__fish_complete_suffix .whl)'
complete -c unzip -x -a '(__fish_complete_suffix .pex)'

# Java
set -Ux JAVA_HOME /Library/Java/JavaVirtualMachines/adoptopenjdk-13.0.2.jdk/Contents/Home

# Pulumi
set -Ux PULUMI_PREFER_YARN 'true'

# Golang
set -x PATH $PATH (go env GOPATH)/bin

# Prompt
eval (starship init fish)
