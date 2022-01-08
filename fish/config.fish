set -g fish_greeting Oo

# Editor
set -gx EDITOR nvim
set -gx VISUAL nvim

# Completions
complete -c pip -a '(__fish_complete_suffix .whl)' -n '__fish_seen_subcommand_from install'
complete -c unzip -a '(__fish_complete_suffix .pex; __fish_complete_suffix .whl)'

set -g fish_user_paths /opt/homebrew/bin/ "$HOME"/.pyenv/shims "$HOME"/.local/share/gem/ruby/3.0.0/bin $fish_user_paths "$HOME"/.dotnet/tools

# Theme
set -g hydro_color_duration normal
set -g hydro_color_error red
set -g hydro_color_git blue
set -g hydro_color_prompt purple
set -g hydro_color_pwd yellow
set -g hydro_symbol_prompt Λ

set -g fish_color_autosuggestion grey
set -g fish_color_command green
set -g fish_color_comment yellow
set -g fish_color_end purple
set -g fish_color_error red
set -g fish_color_escape purple
set -g fish_color_param normal
set -g fish_color_operator purple
set -g fish_color_quote yellow
set -g fish_color_redirection brblue

# Binds
set -g fish_key_bindings fish_vi_key_bindings

bind -M insert -k dc delete-char
bind -M insert \ca _fzf_search_history
bind -M insert \ce accept-autosuggestion
bind -M insert \cf _fzf_search_directory
bind -M insert \ci complete # \ci = <tab>
bind -M insert \cl __zoxide_zi
bind -M insert \cn history-search-forward
bind -M insert \cp history-search-backward
bind -M insert \e\x7F backward-kill-word # \cw
bind -M default -k dc forward-char

# Editor
set -gx EDITOR nvim
set -gx VISUAL nvim

# Completions
complete -c pip -a '(__fish_complete_suffix .whl)' -n '__fish_seen_subcommand_from install'
complete -c unzip -a '(__fish_complete_suffix .pex; __fish_complete_suffix .whl)'

pyenv init - | source

# Bat
set -gx BAT_STYLE auto
set -gx BAT_THEME 1337

# Ripgrep
set -gx RIPGREP_CONFIG_PATH "$HOME"/.config/ripgreprc

# Java
set -gx JAVA_HOME /usr/local/opt/openjdk/libexec/openjdk.jdk/Contents/Home

# FZF
set -gx FZF_DEFAULT_OPTS '--border --height 50% --reverse --margin 1% --padding 1%'
zoxide init fish | source

# Abbreviations
# Azure
abbr azas 'az account show --output table'
abbr aza_set 'az account list | jq -r \'.[] | [.id, .name] | join("\\t")\' | fzf | awk \'{print $1F}\' | xargs -t az account set --subscription'

# Brew
abbr b brew
abbr bi 'brew install'
abbr bl 'brew leaves'
abbr blc 'brew list --cask -1'
abbr bsl 'brew services list'
abbr bup 'brew update && brew upgrade --ignore-pinned && brew cleanup && brew doctor'
abbr brew_dump 'brew bundle dump --file "$HOME"/Projects/dotfiles/brew/Brewfile --force'
abbr brew_prune 'brew autoremove'

# Clipboard
abbr P pbpaste
abbr Y pbcopy

# Directories
abbr - 'cd ..'
abbr dir_rmi 'du -hd 1 | fzf -m | awk \'{print $2}\' | xargs -t rm -rf'
abbr dir_size 'du -h -d 1 | sort -hr'

# Docker
abbr doc docker
abbr docc docker-compose
abbr docker_rm 'docker stop (docker ps -a -q) && docker rm (docker ps -a -q) && docker system prune --volumes -f'
abbr docker_rmi 'docker rmi -f (docker images -a -q)'
abbr docker_stop 'docker stop (docker ps -a -q)'

# Dotnet
abbr d dotnet
abbr df 'dotnet format'
abbr dfsi 'dotnet fsi'
abbr dp 'dotnet publish'
abbr dr 'dotnet run'
abbr dt 'dotnet test'
abbr dtup 'dotnet tool list -g | awk \'NR > 2 {print $1}\' | xargs -t -I % dotnet tool update -g %'
abbr dup 'dotnet outdated --upgrade'

# Edit
abbr e nvim
abbr ed 'nvim -d'
abbr enone 'nvim -u NONE'
abbr er 'nvim -MR'

# Files
function backup -d "Backup file"
    cp $argv "$HOME/Library/Mobile Documents/com~apple~CloudDocs/"
end
abbr fy 'rg --files | fzf | xargs -t cat | pbcopy'
abbr l 'exa -al'
abbr lt 'exa --tree --level 2'
abbr rmd 'rm -rf'
abbr rmi 'fd . --hidden --max-depth 1 --no-ignore | fzf -m | xargs -t -I % rm -rf "%"'
function preview -d "Preview directory/file"
    if test -z "$argv" -o -d "$argv"
        exa --tree --level 3 $argv
    else
        set -l ext (string match -r -- '[^.]+$' $argv)
        if test -n "$ext" -a "$ext" = md
            glow $argv
        else
            bat $argv
        end
    end
end
alias p preview

# Git
abbr g git
abbr ga 'git add'
abbr gb 'git branch'
abbr gci 'git commit'
abbr gciamend 'git commit --amend'
abbr gco 'git checkout'
abbr gconf 'git config --list --show-origin'
abbr gf 'git fetch'
abbr gfa 'git fetch --all'
abbr gi lazygit
abbr gl 'git log --all --decorate --graph --format=format:\'%Cblue%h %Creset- %Cgreen%ar %Creset%s %C(dim white)- %an %C(auto)%d\' -20'
abbr glp 'git log -p'
abbr gm 'git merge'
abbr gph 'git push'
abbr gphf 'git push --force'
abbr gpl 'git pull'
abbr gplrb 'git pull --rebase'
abbr grb 'git rebase'
abbr grepack 'git repack -a -d --depth=250 --window=250'
abbr grsh 'git reset --hard HEAD'
abbr gs 'git status -s -u'
abbr gsw 'git switch'
abbr gswi 'git branch --all | fzf | tr -d \'*\' | awk \'{print $1F}\' | xargs -t git switch'
abbr gunstage 'git reset HEAD --'

# Network
abbr scan 'nmap -sP 192.168.1.0/24'

# Node.js
abbr n npm
abbr nr 'cat package.json | jq -r \'.scripts | keys[]\' | fzf | xargs -t npm run'
abbr ns 'cat package.json | jq \'.scripts\''
abbr nupg 'npm update -g'
abbr nup 'npx npm-check-updates --deep -i'
abbr y yarn
abbr ygup 'yarn global upgrade-interactive'
abbr yup 'yarn upgrade-interactive'

# PostgreSQL
abbr pg 'postgres -D /usr/local/var/postgres'
abbr pg_reset 'brew uninstall --ignore-dependencies postgresql && rm -rf /usr/local/var/postgres && brew install postgresql && /usr/local/bin/timescaledb_move.sh'
abbr pg_up 'brew postgresql-upgrade-database'

# Processes
abbr ports 'lsof -PiTCP -sTCP:LISTEN'

# Python
abbr pip_uninstall 'pip freeze | xargs pip uninstall -y'
abbr po poetry
abbr poetry_setup 'poetry init && poetry add --dev black mypy pylint'
abbr py python
abbr pys 'source venv/bin/activate.fish'
abbr python_setup 'python3 -m venv venv && source venv/bin/activate.fish && pip install --upgrade pip && pip install -r requirements.txt && pip install black mypy pylint'

# Pulumi
abbr pu pulumi
abbr pud 'pulumi destroy'
abbr puo 'pulumi stack output --show-secrets'
abbr pus 'pulumi stack ls --json | jq -r \'.[].name\' | fzf | xargs -t pulumi stack select'
abbr puu 'pulumi up'
abbr pulumi_state_delete 'pulumi stack export | jq -r \'.deployment.resources[].urn\' | fzf | xargs -t pulumi state delete'

# Shell
abbr fp 'fish --private'
abbr fish_reset 'rm -rf "$HOME"/.config/fish && cd "$HOME"/Projects/dotfiles && ./dotfiles link && fisher update'
abbr history_clean 'history delete -p cd -p code -p exa -p rm'
abbr s source

# SSH
abbr ssh_copy_id 'ssh-copy-id -i ~/.ssh/id_rsa.pub'

# VSCode
abbr c 'code .'
abbr code_dump 'code --list-extensions > "$HOME/Library/Application Support/Code/User/extensions.txt"'
abbr code_install 'xargs <"$HOME/Library/Application Support/Code/User/extensions.txt" -L 1 code --force --install-extension'

# Web Browser
abbr web_browser 'rm -rf /tmp/chrome_dev_test && /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --user-data-dir="/tmp/chrome_dev_test" --disable-web-security --incognito --no-first-run --new-window "http://localhost:4200"'
