# Azure
abbr azi 'az interactive --style br'
abbr azsubi 'az account list | jq -r \'.[] | [.id, .name] | join("\\t")\' | fzf | awk \'{print $1F}\' | xargs -t az account set --subscription'

# Brew
abbr b 'brew'
abbr bdump 'brew bundle dump --file "$HOME"/Projects/dotfiles/brew/Brewfile --force'
abbr bi 'brew install'
abbr bl 'brew leaves'
abbr blc 'brew list --cask -1'
abbr bprune 'brew bundle dump && brew bundle --force cleanup && rm Brewfile'
abbr bsl 'brew services list'
abbr bupa 'brew upgrade'
abbr bupa 'brew update && brew upgrade && brew cleanup && brew doctor'
abbr bui 'brew leaves | fzf -m | tr \'\n\' \' \' | xargs -t brew uninstall'
abbr buci 'brew list --cask -1 | fzf -m | tr \'\n\' \' \' | xargs -t brew uninstall --cask'

# Browser
abbr browser 'rm -rf /tmp/chrome_dev_test && open -a "Google Chrome" --args --user-data-dir="/tmp/chrome_dev_test" --disable-web-security --incognito --no-first-run --new-window "http://localhost:5000"'

# Clipboard
abbr P 'pbpaste'
abbr yi 'rg --files | fzf | xargs -t cat | pbcopy'
abbr Y 'pbcopy'

# Directories
abbr dh 'dirh'
abbr dirrmi 'du -hd 1 | fzf -m | awk \'{print $2}\' | xargs -t rm -rf'
abbr dirsize 'du -h -d 1 | sort -hr'
abbr n 'nextd'
abbr p 'prevd'

# Docker
abbr doc 'docker'
abbr docps 'docker ps -a'
abbr docstop 'docker stop (docker ps -a -q)'
abbr docrm 'docker stop (docker ps -a -q) && docker rm (docker ps -a -q) && docker system prune --volumes -f'
abbr docrmimage 'docker rmi -f (docker images -a -q)'
abbr doccu 'docker-compose up'

# Dotnet
abbr d 'dotnet'
abbr dap 'dotnet add package'
abbr dfmt 'dotnet format'
abbr dp 'dotnet publish'
abbr dr 'dotnet run'
abbr dt 'dotnet test'
abbr dtoupa 'dotnet tool list -g | awk \'NR > 2 {print $1}\' | xargs -t -I % dotnet tool update -g %'
abbr dup 'dotnet outdated --upgrade'

# Edit (Neovim)
abbr e 'nvim'
abbr ed 'nvim -d'
abbr enone 'nvim -u NONE'
abbr eup 'brew upgrade neovim --fetch-head'

# Files
abbr c 'bat'
abbr gr 'rg'
abbr l 'exa -al'
abbr lt 'exa --tree --level 2'
abbr fm 'lf'
abbr rmi 'fd . --hidden --max-depth 1 --no-ignore | fzf -m | xargs -t -I % rm -rf "%"'

# Git
abbr g 'git'
abbr gi 'lazygit'
abbr ga 'git add'
abbr gaa 'git add --a'
abbr gb 'git branch -a'
abbr gbcoi 'git branch --all | fzf | tr -d \'*\' | awk \'{print $1F}\' | xargs -t git checkout'
abbr gbd 'git branch -d'
abbr gcfl 'git config --list --show-origin'
abbr gci 'git commit'
abbr gciam 'git commit -am'
abbr gciamend 'git commit --amend'
abbr gcim 'git commit -m'
abbr gco 'git checkout'
abbr gcob 'git checkout -b'
abbr gcof 'git checkout --'
abbr gcofm 'git checkout origin/master --'
abbr gcp 'git cherry-pick'
abbr gd 'git diff'
abbr gdt 'git difftool'
abbr gf 'git fetch'
abbr gfa 'git fetch --all'
abbr gl 'git log'
abbr gla 'git log --all --decorate --graph --format=format:\'%Cblue%h %Creset- %Cgreen%ar %Creset%s %C(dim white)- %an %C(auto)%d\' -20'
abbr glast 'git log -1 -p'
abbr glp 'git log -p'
abbr gm 'git merge'
abbr gmt 'git mergetool'
abbr gpack 'git gc'
abbr gph 'git push'
abbr gpl 'git pull'
abbr gplrb 'git pull --rebase'
abbr grb 'git rebase'
abbr grepack 'git repack -a -d --depth=250 --window=250'
abbr grsh 'git reset --hard HEAD'
abbr gs 'git status -s -u'
abbr gunstage 'git reset HEAD --'
abbr pc_run 'pre-commit run'

# Keyboard
abbr karabiner_config_dump 'cp "$HOME"/.config/karabiner/karabiner.json "$HOME"/Projects/dotfiles/karabiner'
abbr karabiner_config_load 'cp "$HOME"/Projects/dotfiles/karabiner/karabiner.json "$HOME"/.config/karabiner/karabiner.json'

# Makefile
abbr m 'make'

# Mundane Life
abbr cal3 'cal -3'
abbr caly 'cal -y'

# Node.js
abbr nci 'npm ci'
abbr ni 'npm install'
abbr nlg 'npm list -g --depth=0'
abbr nupg 'npm update -g'
abbr nr 'npm run'
abbr y 'yarn'
abbr yupgi 'yarn global upgrade-interactive'
abbr yupi 'yarn upgrade-interactive'
abbr yr 'yarn run'
abbr yri 'cat package.json | jq -r \'.scripts | keys[]\' | fzf | xargs -t yarn run'
abbr yrt 'yarn run test'
abbr ys 'cat package.json | jq \'.scripts\''

# PostgreSQL
abbr pg_up 'postgres -D /usr/local/var/postgres'
abbr pg_reset 'brew uninstall --ignore-dependencies postgresql && rm -rf /usr/local/var/postgres && brew install postgresql && /usr/local/bin/timescaledb_move.sh'
abbr pg_upgrade 'brew postgresql-upgrade-database'

# Processes
abbr portsl 'lsof -PiTCP | rg LISTEN'

# Python
abbr pip_uninstall_all 'pip freeze | xargs pip uninstall -y'
abbr py 'python'
abbr pydb 'python -m pdb'
abbr pys 'source venv/bin/activate.fish'
abbr pysetup 'python3 -m venv venv && source venv/bin/activate.fish && pip install --upgrade pip && pip install -r requirements.txt && pip install black mypy pylint pytest'

# Pulumi
abbr pu 'pulumi'
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
abbr ci 'fzf-history-widget'
abbr fp 'fish --private'
abbr hd 'history | fzf | history delete --case-sensitive --exact'
abbr hdc 'history delete --contains'
abbr s 'source'
abbr sh_fmt 'shfmt -i 2 -s -w .'
abbr sh_lint 'find . -not -path "./.git/*" -type f -perm -u=x | xargs -t -J % shellcheck -x %'

# Tmux
abbr ta 'tmux a -t'
abbr td 'tmux detach'
abbr tk 'tmux kill-session -t'
abbr tka 'tmux kill-session -t (tmux display-message -p "#S")'
abbr tl 'tmux ls'
abbr tn 'tmux new -s'
abbr tnd 'tmux new -d -s'

# VSCode
abbr c. 'code .'
abbr code_ext_dump 'code --list-extensions > "$HOME/Library/Application Support/Code/User/extensions.txt"'
abbr code_ext_install 'xargs <"$HOME/Library/Application Support/Code/User/extensions.txt" -L 1 code --force --install-extension'
