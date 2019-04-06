# Arch Linux
abbr s startx

# Bazel
abbr bb 'bazel build --verbose_failures'
abbr bba 'bazel build --verbose_failures //...'
abbr br 'bazel run'
abbr bt 'bazel test'
abbr btcn 'bazel test --cache_test_results=no'
abbr bta 'bazel test //...'

# Brew
abbr brew_update 'brew update; brew upgrade; brew cleanup; brew doctor'

# Directories
abbr l 'exa --all --classify --git --long'
abbr rmrf 'rm -rf'
abbr tree 'exa --all --tree --level=2 --ignore-glob=".git|node_modules"'

# Display
abbr displays 'system_profiler SPDisplaysDataType'

# Docker
abbr dcb 'docker-compose build --force-rm --pull --no-cache'
abbr dcd 'docker-compose down'
abbr dcp 'docker-compose pull'
abbr dcu 'docker-compose up --abort-on-container-exit'
abbr dprune 'docker stop (docker ps -a -q); docker rm (docker ps -a -q); docker system prune --volumes -f'
abbr dps 'docker ps'
abbr dr 'docker run'
abbr drmi 'docker rmi -f (docker images -a -q)'

# Files
abbr c 'bat --theme=1337 --style=header,grid'

# Git
abbr ga 'git add'
abbr gaa 'git add --a'
abbr gb 'git branch'
abbr gba 'git branch -a'
abbr gbd 'git branch -D'
abbr gc 'git commit'
abbr gcam 'git commit -am'
abbr gcm 'git commit -m'
abbr gcamend 'git commit --amend --no-edit'
abbr gco 'git checkout'
abbr gcob 'git checkout -b'
abbr gcp 'git cherry-pick'
abbr gd 'git diff --color | diff-so-fancy | less -RFX'
abbr gl 'git log --graph --abbrev-commit --decorate --format=format:"%C(blue)%h%C(reset) - %C(green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)" --all -20'
abbr glp 'git log -p'
abbr gpush 'git push -u origin (git rev-parse --abbrev-ref HEAD)'
abbr gpull 'git pull'
abbr grb 'git rebase'
abbr greset 'git reset --hard'
abbr grl 'git reflog --date iso'
abbr gs 'git status -u'
abbr lg 'lazygit'

# Golang
abbr gob 'go build ./...'
abbr gof 'gofmt -s -w .'
abbr gor 'go run'
abbr got 'go test ./...'

# Java
abbr jr 'java -jar'
abbr jv 'jar tvf'

# Makefile
abbr m 'make'

# Mundane Life
abbr cal3 'cal -3'
abbr caly 'cal -y'
abbr cv_update 'cp "$HOME"/Downloads/curriculum_vitae.pdf "$HOME"/Projects/brunoroque06.github.io/documents/BrunoRoqueCv.pdf; tar -xf "$HOME"/Downloads/curriculum-vitae.zip -C "$HOME"/Projects/brunoroque06.github.io/documents/curriculum-vitae'

# Npm
abbr nci 'npm ci'
abbr ni 'npm install'
abbr npm_global_list 'npm list -g --depth=0'
abbr npm_global_update 'npm update -g'
abbr nr 'npm run'
abbr ns "awk '/\"scripts\":/,/}/' package.json"

# Pacman
abbr pacman_update 'sudo pacman -Syu'
abbr yay_update 'yay -Syu'

# Processes
abbr list_ports 'lsof -PiTCP G LISTEN'
abbr k9 'kill -9'

# Shell
abbr shell_scripts_lint 'find . -not -path "./.git/*" -type f \( ! -name "*.*" -o -name ".*" \) -exec shellcheck -x -e SC1090 {} \;'
abbr shell_scripts_format 'shfmt -i 2 -s -w .'

# Tmux
abbr ta 'tmux attach-session -t'
abbr tks 'tmux kill-server'
abbr tl 'tmux list-sessions'
abbr tn 'tmux new-session -s default'

# Vim
abbr v 'vim'
abbr vim_none 'vim -u NONE'
abbr vim_update 'vim +PlugUpgrade +PlugUpdate! +PlugClean! +qa'

# VSCode
abbr code_extensions_export 'code --list-extensions > $HOME/.vscode/extensions.txt'
abbr code_extensions_install '< $HOME/.vscode/extensions.txt xargs -L 1 code --install-extension'

# Yank/Paste
abbr p 'pbpaste'
abbr y 'pbcopy'
