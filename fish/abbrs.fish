# Brew
abbr brew_update 'brew update; brew upgrade; brew cleanup; brew doctor'

# Directories
abbr l 'exa --all --classify --git --long'
abbr rmrf 'rm -rf'
abbr tree 'exa --all --tree --level=3 --ignore-glob=".git|node_modules"'

# Display
abbr displays 'system_profiler SPDisplaysDataType'

# Docker
abbr dcb 'docker-compose build --force-rm --pull --no-cache'
abbr dcd 'docker-compose down'
abbr dcp 'docker-compose pull'
abbr dcu 'docker-compose up --abort-on-container-exit'
abbr dprune 'docker stop $(docker ps -a -q); docker rm $(docker ps -a -q); docker system prune --volumes -f'
abbr dps 'docker ps'
abbr dr 'docker run'
abbr drmi 'docker rmi -f $(docker images -a -q)'

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
abbr gpush 'git push -u origin $(git rev-parse --abbrev-ref HEAD)'
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
