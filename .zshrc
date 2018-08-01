#!/bin/zsh
autoload -Uz compinit
compinit

# Plugins
source <(antibody init)
antibody bundle zsh-users/zsh-completions
antibody bundle mafredri/zsh-async
antibody bundle sindresorhus/pure
antibody bundle zsh-users/zsh-syntax-highlighting

# Auto-completion
zstyle ':completion:*' completer _oldlist _expand _complete _match _ignored _approximate
zstyle ':completion:*' menu select

# Theme
PURE_PROMPT_SYMBOL='λ'
PURE_GIT_DOWN_ARROW='▼'
PURE_GIT_UP_ARROW='▲'

# Imports
source ~/.credentials

# Exports
export EDITOR='vim'
export SSH_KEY_PATH='~/.ssh/rsa_id'

# Antibody
alias antibody-remove-plugins='rm -rf `antibody home`'

# Bazel
alias bb='bazel build --verbose_failures //...'
function bdeps() { bazel query 'deps('$1')' }
alias br='bazel run'
alias bt='bazel test'
alias bta='bazel test //...'

# Config
alias reload='. ~/.zshrc'
alias configzsh="${EDITOR} ~/.zshrc"
alias configvim="${EDITOR} ~/.vimrc"
alias configgit="${EDITOR} ~/.gitconfig"

# Directory
alias ..='cd ..'
alias cppwd="echo -ne \$(pwd) | pbcopy"
alias chmodx='chmod +x'
alias ls='ls -FHG'
alias la='ls -FHGa'
alias ll='ls -FHGal'
function mvfiles() { mv $1*(DN) $2 }
alias rmrf='rm -rf'
function up() {
  if [[ "$#" < 1 ]] ; then
    cd ..
  else
    CDSTR=""
    for i in {1..$1} ; do
      CDSTR="../$CDSTR"
    done
    cd $CDSTR
  fi
}
alias tree='find . | sed -e "s/[^-][^\/]*\//  |/g" -e "s/|\([^ ]\)/|-\1/"'

# Docker
alias drun='docker build -t ${PWD##*/} . ; docker run --net='host' ${PWD##*/}'
alias dclean='docker system prune --volumes -f'
alias dcomposebuild='docker-compose build --force-rm --pull --no-cache'
alias dcomposeup='dockerClean ; dockerComposeBuild ; docker-compose up'
function dcomposefileup() { docker-compose -f $1 up }
function dcomposefiledown() { docker-compose -f $1 down }
alias drmimages='docker rmi $(docker images -a -q)'
alias drmcontainers='docker stop $(docker ps -a -q) ; docker drm $(docker ps -a -q)'

# Find
export GREP_OPTIONS='--color=always'
alias -g G='| grep'

# Git
alias ga='git add'
alias gaa='git add --a'
alias gb='git checkout'
alias gbb='git checkout -b'
alias gbdelete='git branch -d'
alias gbdeleteremote='git push origin --delete'
alias gbmaster='git checkout master'
alias gc='git commit'
alias gcam='git commit -am'
alias gd='git diff --color | ~/diff-so-fancy.sh'
function gdb() { gd $1..$2 }
alias gl='git log'
alias gpush='git push -u origin $(git rev-parse --abbrev-ref HEAD)'
alias gpull='git pull'
alias grebase='git rebase'
alias greset='git reset --hard'
alias gs='git status -u'
function gmergemaster() {
  BRANCH=$(git rev-parse --abbrev-ref HEAD)
  git checkout master
  git pull
  git checkout ${BRANCH}
  echo "Merging master into ${BRANCH}"
}

# Java
alias jrun='java -jar'
alias jview='jar tvf'

# Maven
alias manalyse='mvn dependency:analyze'
alias minstall='mvn install'
alias mtree='mvn dependency:tree'

# Network
alias getPorts='lsof -PiTCP | grep LISTEN'

# Spoud
# Logistics
MONO='/Users/brunoroque/Documents/dm'
REPO='spoud/dm'
alias logisticsup="(cd $MONO/sdm/development/local-logistics ; dockerComposeUp)"
alias logisticsdown="(cd $MONO/sdm/development/local-logistics ; docker-compose down)"
alias mrcode="code $MONO"
alias mrcd="cd $MONO"

function git-create-pr() {
  MESSAGE=$@
  BRANCH="bruno/$(echo ${@:l} | sed 's/[^a-zA-Z0-9]/-/g')"
  git checkout -b $BRANCH
  git add --a
  git commit -am "$MESSAGE"
  git push -u origin $BRANCH
  curl -X POST -H "Content-Type: application/json" -u $BITBUCKET_USERNAME:$BITBUCKET_PASSWORD https://api.bitbucket.org/2.0/repositories/$REPO/pullrequests -d "{\"title\":\"$MESSAGE\",\"source\":{\"branch\":{\"name\":\"$BRANCH\"},\"repository\":{\"full_name\":\"$REPO\"}},\"reviewers\":[{\"uuid\":\"{c231a263-3dcc-4eb9-a606-e661b8c48fca}\"},{\"uuid\":\"{9106fa9d-4925-45f1-b8cd-3111bae26696}\"},{\"uuid\":\"{6cfc4e0d-806c-482b-8d2f-ed8fb198f91e}\"},{\"uuid\":\"{1dbb5f95-3ad8-49e5-a353-002a5c52b277}\"}],\"close_source_branch\":\"true\"}"
  git checkout master
  echo "Pull request successfully created: $BRANCH ($MESSAGE)."
}
function pullRequest() {
  echo $(curl -X POST -H "Content-Type: application/json" -u $BITBUCKET_USERNAME:$BITBUCKET_PASSWORD https://api.bitbucket.org/2.0/repositories/$REPO/pullrequests -d @pullrequest.json -v)
}

# Text
function replace() { echo ${1//$2/$3} }
function trim() { echo $@ | tr -d '\040\011\012\015' }
function json() { echo $1 | python -m json.tool }
