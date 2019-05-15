#!/usr/bin/env bash

# Auto-completion
zstyle ':completion:*' completer _oldlist _expand _complete _match _ignored _approximate
zstyle ':completion:*' menu select

# Exports
PATH=$PATH:$(go env GOPATH)/bin:$HOME/Library/Python/3.7/bin:$(ruby -e 'print Gem.user_dir')/bin
export PATH
export SSH_KEY_PATH="$HOME/.ssh/rsa_id"
export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk-12.0.1.jdk/Contents/Home"

# FZF
export FZF_DEFAULT_OPTS='--height 20% --layout=reverse'

# History
export HISTSIZE=1000
export SAVEHIST=1000
HISTFILE=$HOME/.history
setopt HIST_IGNORE_ALL_DUPS
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# Vim
bindkey -v
export KEYTIMEOUT=1

# Plugins
source "$HOME"/.zsh_plugins
zsh_plugins_load

# Binds
bindkey '^E' autosuggest-accept
bindkey '^N' history-substring-search-down
bindkey '^P' history-substring-search-up

# Sources
source "$HOME"/.aliases
source "$HOME"/.fzf.zsh
source "$HOME"/.secrets
source "$HOME"/.spoud
