# Arch Linux
abbr sx 'startx'
abbr pacman_sync 'sudo pacman -Syu'
abbr pacman_remove 'sudo pacman -Rs'
abbr pacman_remove_unused 'sudo pacman -R (pacman -Qdqt)'
abbr yay_sync 'yay -Syu'

# Azure
abbr azi 'az interactive --style br'

# Brew
abbr brew_upgrade 'brew update; brew upgrade; brew cleanup; brew doctor'
abbr brew_cask_upgrade 'brew update; brew cask upgrade; brew cask doctor'

# Directory
abbr c 'bat'
abbr l 'ls -AGlh'
abbr fm 'lf'
abbr rm_dir 'du -hd 1 | fzf -m | awk \'{print $2}\' | xargs rm -rf'
abbr rm_empty_dirs 'find . -type d -empty -delete'
abbr zl 'cd (z -l | awk \'{print $2}\' | fzf || printf .)'

# Docker
abbr d 'docker'
abbr docker_containers_remove 'docker stop (docker ps -a -q); docker rm (docker ps -a -q); docker system prune --volumes -f'
abbr docker_images_remove 'docker rmi -f (docker images -a -q)'

# Git
abbr ga 'git add'
abbr gaa 'git add --a'
abbr gb 'git branch'
abbr gbd 'git branch -D'
abbr gc 'git commit'
abbr gd 'git diff'
abbr gcam 'git commit -am'
abbr gcm 'git commit -m'
abbr gcamend 'git commit --amend --no-edit'
abbr gco 'git checkout'
abbr gcob 'git checkout -b'
abbr gcp 'git cherry-pick'
abbr gl 'git log --all --decorate --graph --format=format:"%C(blue)%h%C(reset) - %C(green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)" -20'
abbr gpush 'git push -u origin (git rev-parse --abbrev-ref HEAD)'
abbr gpull 'git pull'
abbr grb 'git rebase'
abbr greset 'git reset --hard'
abbr gs 'git status -u'
abbr lg 'lazygit'
abbr pc_run 'pre-commit run'

# Mac OS
abbr amethyst_backup 'cp "$HOME"/Library/Preferences/com.amethyst.amethyst.plist "$HOME"/Projects/dotfiles/window-manager/macos'

# Makefile
abbr m 'make'

# Mundane Life
abbr cal3 'cal -3'
abbr caly 'cal -y'
abbr cv_update 'cp "$HOME"/Downloads/curriculum_vitae.pdf "$HOME"/Projects/brunoroque06.github.io/documents/BrunoRoqueCv.pdf; tar -xf "$HOME"/Downloads/curriculum-vitae.zip -C "$HOME"/Projects/brunoroque06.github.io/documents/curriculum-vitae'

# Node.js
abbr nci 'npm ci'
abbr ni 'npm install'
abbr npm_global_list 'npm list -g --depth=0'
abbr npm_global_update 'npm update -g'
abbr nr 'npm run'
abbr ns "awk '/\"scripts\":/,/}/' package.json"
abbr y 'yarn'
abbr yarn_global_upgrade 'yarn global upgrade-interactive --latest'
abbr yarn_upgrade 'yarn upgrade-interactive --latest'

# Processes
abbr list_ports 'lsof -PiTCP | grep LISTEN'
abbr t 'gotop'

# Python
abbr pip_uninstall_all 'pip freeze | xargs pip uninstall -y'
abbr py 'python'
abbr pydb 'python -m pdb'
abbr pye 'source (pyenv init -|psub); pyenv shell 3.6.9'
abbr pys 'source venv/bin/activate.fish'
abbr python_setup 'python3 -m venv venv/; source venv/bin/activate.fish; pip install --upgrade pip; pip install -r requirements.txt; pip install pylint'

# Pulumi
abbr pu 'pulumi'
abbr pud 'pulumi destroy'
abbr pur 'pulumi refresh'
abbr puu 'pulumi up'
abbr puusp 'pulumi up --skip-preview'

# Shell
abbr fp 'fish --private'
abbr s 'source'
abbr shell_scripts_lint 'find . -not -path "./.git/*" -type f \( ! -name "*.*" -o -name ".*" \) -exec shellcheck -x -e SC1090 {} \;'
abbr shell_scripts_format 'shfmt -i 2 -s -w .'

# Tmux
abbr ta 'tmux attach-session -t'
abbr tks 'tmux kill-session -t (tmux display-message -p "#S")'
abbr tl 'tmux list-sessions'
abbr tn 'tmux new-session -s default'

# Vim
abbr v 'vim'
abbr vim_plug 'vim +PlugUpgrade +PlugClean +PlugInstall +PlugUpdate +qa'

# VSCode
abbr code_extensions_export 'code --list-extensions > "$HOME"/.vscode/extensions.txt'
abbr code_extensions_install '< "$HOME"/.vscode/extensions.txt xargs -L 1 code --install-extension'

# Paste/Yank
abbr P 'pbpaste'
abbr Y 'pbcopy'
