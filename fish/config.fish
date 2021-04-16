set -U fish_greeting 'Oo'

# Editor
fish_vi_key_bindings
set -Ux EDITOR nvim
set -Ux VISUAL nvim

# Abbreviations
source "$HOME"/.config/fish/abbreviations.fish

# Completions
complete -c pip -a '(__fish_complete_suffix .whl)' -n '__fish_seen_subcommand_from install'
complete -c unzip -a '(__fish_complete_suffix .pex; __fish_complete_suffix .whl)'

# Fzf
set -Ux FZF_DEFAULT_OPTS '--border=sharp --height 20% --reverse'
set -Ux FZF_CTRL_T_COMMAND 'fd . --type f --hidden -E .git'
set -Ux FZF_CTRL_T_OPTS '--height 40% --preview \'bat {}\' --preview-window border-left'

# Java
set -Ux JAVA_HOME /Library/Java/JavaVirtualMachines/adoptopenjdk-13.0.2.jdk/Contents/Home

# Man Pages
set -x LESS_TERMCAP_mb (set_color brblue)
set -x LESS_TERMCAP_md (set_color brblue)
set -x LESS_TERMCAP_me (set_color normal)
set -x LESS_TERMCAP_se (set_color normal)
set -x LESS_TERMCAP_so (set_color -b blue bryellow)
set -x LESS_TERMCAP_ue (set_color normal)
set -x LESS_TERMCAP_us (set_color brgreen)

# Path
fish_add_path -p /usr/local/opt/ruby/bin
fish_add_path -aP "$HOME"/.dotnet/tools "$HOME"/.cargo/bin (go env GOPATH)/bin /usr/local/opt/qt/bin

# Theme
set -U fish_color_autosuggestion grey
set -U fish_color_command green
set -U fish_color_comment yellow
set -U fish_color_end purple
set -U fish_color_error red
set -U fish_color_escape purple
set -U fish_color_param normal
set -U fish_color_operator blue
set -U fish_color_quote yellow
set -U fish_color_redirection brblue

# Pulumi
set -Ux PULUMI_PREFER_YARN true

# Ripgrep
set -Ux RIPGREP_CONFIG_PATH "$HOME"/.config/ripgreprc

# Zoxide
zoxide init fish | source

set -e fish_user_paths

starship init fish | source
