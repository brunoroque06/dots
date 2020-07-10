# Arch Linux
abbr sx 'startx'
abbr pacman_sync 'sudo pacman -Syu'
abbr pacman_remove 'sudo pacman -Rs'
abbr pacman_remove_unused 'sudo pacman -R (pacman -Qdqt)'
abbr yay_sync 'yay -Syu'

# Azure
abbr azi 'az interactive --style br'
abbr az_sub 'az account list --query \'[].{subscriptionName:name, subscriptionId:id}\' -o tsv | fzf | awk \'{print $NF}\' | xargs -J % az account set -s %'

# Brew
abbr brew_cask_upgrade 'brew update; brew cask upgrade; brew cask doctor'
abbr brew_prune 'brew bundle --force cleanup'
abbr brew_upgrade 'brew update; brew upgrade; brew cleanup; brew doctor'

# Docker
abbr d 'docker'
abbr dpsa 'docker ps -a'
abbr docker_containers_remove 'docker stop (docker ps -a -q); docker rm (docker ps -a -q); docker system prune --volumes -f'
abbr docker_images_remove 'docker rmi -f (docker images -a -q)'

# Files
abbr c 'bat'
abbr l 'exa -al'
abbr fm 'lf'
abbr rm_dir 'du -hd 1 | fzf -m | awk \'{print $2}\' | xargs rm -rf'
abbr rm_empty_dirs 'find . -type d -empty -delete'
abbr tree 'exa --tree'
abbr zl 'cd (z -l | awk \'{print $2}\' | fzf || printf .)'

# Git
abbr ga 'git add'
abbr gaa 'git add --a'
abbr gb 'git branch'
abbr gbd 'git branch -D'
abbr gc 'git commit'
abbr gcam 'git commit -am'
abbr gcamend 'git commit --amend --no-edit'
abbr gcm 'git commit -m'
abbr gco 'git checkout'
abbr gcob 'git checkout -b'
abbr gcp 'git cherry-pick'
abbr gd 'git diff'
abbr gl 'git log --all --decorate --graph --format=format:"%C(blue)%h%C(reset) - %C(green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)" -20'
abbr glf 'git log -p -1'
abbr gp 'git pull'
abbr gP 'git push -u origin (git rev-parse --abbrev-ref HEAD)'
abbr grb 'git rebase'
abbr greset 'git reset --hard'
abbr gs 'git status -u'
abbr lg 'lazygit'
abbr pc_run 'pre-commit run'

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
abbr y 'yarn'
abbr yarn_global_upgrade 'yarn global upgrade-interactive --latest'
abbr yarn_upgrade 'yarn upgrade-interactive --latest'
abbr ys "awk '/\"scripts\":/,/}/' package.json"
abbr yt 'yarn test'

# Processes
abbr list_ports 'lsof -PiTCP | grep LISTEN'
abbr to 'gotop'

# Python
abbr pip_uninstall_all 'pip freeze | xargs pip uninstall -y'
abbr py 'python'
abbr pydb 'python -m pdb'
abbr pye 'source (pyenv init -|psub); pyenv shell 3.6.9'
abbr pys 'source venv/bin/activate.fish'
abbr python_setup 'python3 -m venv venv/; source venv/bin/activate.fish; pip install --upgrade pip; pip install -r requirements.txt; pip install black mypy pylint pytest'

# Pulumi
abbr pu 'pulumi'
abbr pud 'pulumi destroy'
abbr pur 'pulumi refresh'
abbr puu 'pulumi up'
abbr puusp 'pulumi up --skip-preview'

# Shell
abbr fp 'fish --private'
abbr s 'source'
abbr sh_fmt 'shfmt -i 2 -s -w .'
abbr sh_lint 'find . -not -path "./.git/*" -type f -perm -u=x | xargs -t -J % shellcheck -x %'

# Tmux
abbr ta 'tmux attach-session -t'
abbr tks 'tmux kill-session -t (tmux display-message -p "#S")'
abbr tl 'tmux list-sessions'
abbr tn 'tmux new-session -s default'

# Vim
abbr v 'vim'
abbr vim_plug 'vim +PlugUpgrade +PlugClean +PlugInstall +PlugUpdate +qa'

# VSCode
abbr code_ext_export 'code --list-extensions > "$HOME/Library/Application Support/Code/User/extensions.txt"'
abbr code_ext_install 'xargs <"$HOME/Library/Application Support/Code/User/extensions.txt" -L 1 code --force --install-extension'

# Paste/Yank
abbr P 'pbpaste'
abbr Y 'pbcopy'

# Window Manager
abbr amethyst_config_export 'cp "$HOME"/Library/Preferences/com.amethyst.amethyst.plist "$HOME"/Projects/dotfiles/window-manager/com.amethyst.amethyst.plist'
