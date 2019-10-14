# Arch Linux
abbr sx startx
abbr pacman_sync 'sudo pacman -Syu'
abbr pacman_remove 'sudo pacman -Rs'
abbr pacman_remove_unused 'sudo pacman -R (pacman -Qdqt)'
abbr yay_sync 'yay -Syu'

# Brew
abbr brew_update 'brew update; brew upgrade; brew cleanup; brew doctor'
abbr brew_cask_update 'brew update; brew cask upgrade; brew cask doctor'

# Directory
abbr l 'exa --all --classify --git --long'
abbr ll 'ls -aGlh'
abbr fm 'ranger'
abbr rm_dir 'du -hd 1 | fzf -m | awk \'{print $2}\' | xargs rm -rf'
abbr rm_empty_dirs 'find . -type d -empty -delete'
abbr tree 'exa --all --tree --level=2 --ignore-glob=".git|node_modules"'
abbr zl 'cd (z -l | awk \'{print $2}\' | fzf || printf .)'

# Docker
abbr d 'docker'
abbr docker_containers_remove 'docker stop (docker ps -a -q); docker rm (docker ps -a -q); docker system prune --volumes -f'
abbr docker_images_remove 'docker rmi -f (docker images -a -q)'

# File
abbr c 'bat'

# Fish
abbr fp 'fish --private'

# Git
abbr ga 'git add'
abbr gaa 'git add --a'
abbr gb 'git branch'
abbr gbd 'git branch -D'
abbr gc 'git commit'
abbr gcam 'git commit -am'
abbr gcm 'git commit -m'
abbr gcamend 'git commit --amend --no-edit'
abbr gco 'git checkout'
abbr gcob 'git checkout -b'
abbr gcp 'git cherry-pick'
abbr gd 'git diff --color | diff-so-fancy | less -RFX'
abbr gl 'git log --all --decorate --graph --format=format:"%C(blue)%h%C(reset) - %C(green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)" -20'
abbr gpush 'git push -u origin (git rev-parse --abbrev-ref HEAD)'
abbr gpull 'git pull'
abbr grb 'git rebase'
abbr greset 'git reset --hard'
abbr gs 'git status -u'
abbr lg 'lazygit'

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

# Pre-commit
abbr pc_run 'pre-commit run'

# Processes
abbr list_ports 'lsof -PiTCP | grep LISTEN'

# Python
abbr py 'python'
abbr pydb 'python -m pdb'
abbr pye 'source (pyenv init -|psub); pyenv shell 3.6.9'
abbr pys 'source (ls -d */ | grep venv | fzf)bin/activate.fish'
abbr pip_uninstall_all 'pip freeze | xargs pip uninstall -y'

# Shell
abbr s 'source'
abbr shell_scripts_lint 'find . -not -path "./.git/*" -type f \( ! -name "*.*" -o -name ".*" \) -exec shellcheck -x -e SC1090 {} \;'
abbr shell_scripts_format 'shfmt -i 2 -s -w .'

# Tmux
abbr ta 'tmux attach-session -t'
abbr tks 'tmux kill-session -t (tmux display-message -p "#S")'
abbr tl 'tmux list-sessions'
abbr tn 'tmux new-session -s default'

# Top
abbr top 'gotop'

# Vim
abbr v 'vim'

# VSCode
abbr code_extensions_export 'code --list-extensions > "$HOME"/.vscode/extensions.txt'
abbr code_extensions_install '< "$HOME"/.vscode/extensions.txt xargs -L 1 code --install-extension'

# Yank/Paste
abbr p 'pbpaste'
