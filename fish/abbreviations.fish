# Arch Linux
abbr sx 'startx'
abbr pacman_sync 'sudo pacman -Syu'
abbr pacman_remove 'sudo pacman -Rs'
abbr pacman_remove_unused 'sudo pacman -R (pacman -Qdqt)'
abbr yay_sync 'yay -Syu'

# Azure
abbr azi 'az interactive --style br'
abbr az_sub 'az account list --query \'[].{subscriptionName:name, subscriptionId:id}\' -o table | sed -e \'1,2d\' | fzf | awk \'{print $NF}\' | xargs -J % az account set -s %'

# Brew
abbr brew_cask_upgrade 'brew update; brew upgrade --cask; brew doctor'
abbr brew_dump 'brew bundle dump --file "$HOME"/Projects/dotfiles/brew/Brewfile --force'
abbr bl 'brew leaves'
abbr blc 'brew list --cask -1'
abbr brew_prune 'brew bundle dump; brew bundle --force cleanup; rm Brewfile'
abbr brew_upgrade 'brew update; brew upgrade; brew cleanup; brew doctor'

# Directories
abbr d 'dirh'
abbr n 'nextd'
abbr p 'prevd'
abbr dir_rm_i 'du -hd 1 | fzf -m | awk \'{print $2}\' | xargs rm -rf'
abbr dir_rm_empty 'find . -type d -empty -delete'
abbr dir_size 'du -h -d 1 | sort -hr'

# Docker
abbr dr 'docker'
abbr drpsa 'docker ps -a'
abbr docker_containers_remove 'docker stop (docker ps -a -q); docker rm (docker ps -a -q); docker system prune --volumes -f'
abbr docker_images_remove 'docker rmi -f (docker images -a -q)'

# Dotnet
abbr do 'dotnet'

# Files
abbr c 'bat'
abbr l 'exa -al'
abbr fm 'lf'
abbr tree 'exa --tree'

# Git
abbr g 'git'
abbr gi 'lazygit'
abbr pc_run 'pre-commit run'

# Google Chrome
abbr chrome_dev 'rm -rf /tmp/chrome_dev_test; open -n -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --args --user-data-dir="/tmp/chrome_dev_test" --disable-web-security'

# Keyboard
abbr karabiner_config_dump 'cp "$HOME"/.config/karabiner/karabiner.json "$HOME"/Projects/dotfiles/karabiner'
abbr karabiner_config_load 'cp "$HOME"/Projects/dotfiles/karabiner/karabiner.json "$HOME"/.config/karabiner/karabiner.json'

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
abbr puds 'pulumi destroy --skip-preview'
abbr pur 'pulumi refresh'
abbr puu 'pulumi up'
abbr puus 'pulumi up --skip-preview'

# Shell
abbr fp 'fish --private'
abbr hdc 'history delete --contains'
abbr history_delete 'history | fzf | history delete --case-sensitive --exact'
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
abbr code_ext_dump 'code --list-extensions > "$HOME/Library/Application Support/Code/User/extensions.txt"'
abbr code_ext_install 'xargs <"$HOME/Library/Application Support/Code/User/extensions.txt" -L 1 code --force --install-extension'

# Paste/Yank
abbr P 'pbpaste'
abbr Y 'pbcopy'

# Window Manager
abbr rectangle_config_dump 'cp "$HOME"/Library/Preferences/com.knollsoft.Rectangle.plist "$HOME"/Projects/dotfiles/window-manager'
