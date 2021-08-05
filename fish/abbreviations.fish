# Azure
abbr azi 'az interactive --style br'
abbr az_subi 'az account list | jq -r \'.[] | [.id, .name] | join("\\t")\' | fzf | awk \'{print $1F}\' | xargs -t az account set --subscription'

# Brew
abbr b brew
abbr b_dump 'brew bundle dump --file "$HOME"/Projects/dotfiles/brew/Brewfile --force'
abbr b_prune 'brew autoremove'
abbr bi 'brew install'
abbr bl 'brew leaves'
abbr blc 'brew list --cask -1'
abbr bsl 'brew services list'
abbr bupa 'brew update && brew upgrade --ignore-pinned && brew cleanup && brew doctor'
abbr bui 'brew leaves | fzf -m | tr \'\n\' \' \' | xargs -t brew uninstall'
abbr buci 'brew list --cask -1 | fzf -m | tr \'\n\' \' \' | xargs -t brew uninstall --cask'

# Clipboard
abbr P pbpaste
abbr Y pbcopy

# Directories
abbr dir_rmi 'du -hd 1 | fzf -m | awk \'{print $2}\' | xargs -t rm -rf'
abbr dir_size 'du -h -d 1 | sort -hr'

# Docker
abbr doc docker
abbr doc_stop 'docker stop (docker ps -a -q)'
abbr doc_rm 'docker stop (docker ps -a -q) && docker rm (docker ps -a -q) && docker system prune --volumes -f'
abbr doc_rmimage 'docker rmi -f (docker images -a -q)'
abbr docc docker-compose
abbr docps 'docker ps -a'

# Dotnet
abbr d dotnet
abbr d_toupa 'dotnet tool list -g | awk \'NR > 2 {print $1}\' | xargs -t -I % dotnet tool update -g %'
abbr dap 'dotnet add package'
abbr dfmt 'dotnet format'
abbr dp 'dotnet publish'
abbr dr 'dotnet run'
abbr dt 'dotnet test'
abbr dup 'dotnet outdated --upgrade'

# Edit
abbr e nvim
abbr ed 'nvim -d'
abbr enone 'nvim -u NONE'

# Files
abbr c bat
abbr l 'exa -al'
abbr lt 'exa --tree --level 2'
abbr rmi 'fd . --hidden --max-depth 1 --no-ignore | fzf -m | xargs -t -I % rm -rf "%"'
abbr fyi 'rg --files | fzf | xargs -t cat | pbcopy'

# Git
abbr g git
abbr g_config 'git config --list --show-origin'
abbr ga 'git add'
abbr gb 'git branch'
abbr gci 'git commit'
abbr gci_amend 'git commit --amend'
abbr gco 'git checkout'
abbr gi tig
abbr gf 'git fetch'
abbr gfa 'git fetch --all'
abbr gl 'git log'
abbr gla 'git log --all --decorate --graph --format=format:\'%Cblue%h %Creset- %Cgreen%ar %Creset%s %C(dim white)- %an %C(auto)%d\' -20'
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
abbr pc_run 'pre-commit run'

# Keyboard
abbr karabiner_config_dump 'cp "$HOME"/.config/karabiner/karabiner.json "$HOME"/Projects/dotfiles/karabiner'
abbr karabiner_config_load 'cp "$HOME"/Projects/dotfiles/karabiner/karabiner.json "$HOME"/.config/karabiner/karabiner.json'

# Makefile
abbr m make

# Mundane Life
abbr cal3 'cal -3'
abbr caly 'cal -y'

# Network
abbr scan 'nmap -sP 192.168.1.0/24'

# Node.js
abbr n npm
abbr nci 'npm ci'
abbr ni 'npm install'
abbr nlg 'npm list -g --depth=0'
abbr nr 'npm run'
abbr nri 'cat package.json | jq -r \'.scripts | keys[]\' | fzf | xargs -t npm run'
abbr ns 'cat package.json | jq \'.scripts\''
abbr nupg 'npm update -g'
abbr nupi 'npx npm-check-updates --deep -i'
abbr y yarn
abbr yupgi 'yarn global upgrade-interactive'
abbr yupi 'yarn upgrade-interactive'

# PostgreSQL
abbr pg_up 'postgres -D /usr/local/var/postgres'
abbr pg_reset 'brew uninstall --ignore-dependencies postgresql && rm -rf /usr/local/var/postgres && brew install postgresql && /usr/local/bin/timescaledb_move.sh'
abbr pg_upgrade 'brew postgresql-upgrade-database'

# Processes
abbr ports_list 'lsof -PiTCP | rg LISTEN'

# Python
abbr pip_uninstall_all 'pip freeze | xargs pip uninstall -y'
abbr po poetry
abbr po_setup 'poetry init && poetry add --dev black mypy pylint'
abbr py python

# Pulumi
abbr pu pulumi
abbr pusdi 'pulumi stack export | jq -r \'.deployment.resources[].urn\' | fzf | xargs -t pulumi state delete'
abbr pussi 'pulumi stack ls --json | jq -r \'.[].name\' | fzf | xargs -t pulumi stack select'
abbr puso 'pulumi stack output --show-secrets'
abbr pud 'pulumi destroy'
abbr puds 'pulumi destroy --skip-preview'
abbr pup 'pulumi preview'
abbr pur 'pulumi refresh'
abbr puu 'pulumi up'
abbr puus 'pulumi up --skip-preview'

# Shell
abbr fp 'fish --private'
abbr hd 'history | fzf | history delete --case-sensitive --exact'
abbr hdc 'history delete --contains'
abbr s source
abbr sh_lint 'shfmt -f . | xargs -t -J % shellcheck -x %'

# VSCode
abbr c. 'code .'
abbr code_ext_dump 'code --list-extensions > "$HOME/Library/Application Support/Code/User/extensions.txt"'
abbr code_ext_install 'xargs <"$HOME/Library/Application Support/Code/User/extensions.txt" -L 1 code --force --install-extension'

# Web Browser
abbr webbrowser 'rm -rf /tmp/chrome_dev_test && /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --user-data-dir="/tmp/chrome_dev_test" --disable-web-security --incognito --no-first-run --new-window "http://localhost:4200"'
