#!/usr/bin/env bash

# Auto-completion
zstyle ':completion:*' completer _oldlist _expand _complete _match _ignored _approximate
zstyle ':completion:*' menu select

# Exports
export -U PATH=$PATH:$(go env GOPATH)/bin:$(ruby -e 'print Gem.user_dir')/bin
export SSH_KEY_PATH="$HOME/.ssh/rsa_id"
export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk-12.0.1.jdk/Contents/Home"

# FZF
export FZF_DEFAULT_OPTS='--border --height 20% --layout=reverse'
readonly FZF_COMMAND="find . -not \\( -path ./.git -prune \\) -not \\( -path ./node_modules -prune \\) -type f | cut -c3-"
export FZF_DEFAULT_COMMAND=$FZF_COMMAND
export FZF_CTRL_T_COMMAND=$FZF_COMMAND

# History
export HISTSIZE=1000
export SAVEHIST=1000
HISTFILE=$HOME/.zsh_history
setopt HIST_IGNORE_ALL_DUPS
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# Plugins
source "$HOME"/.zsh_plugins
zsh_plugins_load

# Binds
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
bindkey -v
export KEYTIMEOUT=1
bindkey -M vicmd '\e[3~' delete-char
bindkey '\e[3~' delete-char
bindkey '^E' autosuggest-accept
bindkey '^N' history-substring-search-down
bindkey '^P' history-substring-search-up
bindkey '^W' backward-delete-word

# Sources
source "$HOME"/.aliases
source "$HOME"/.fzf.zsh
source "$HOME"/.secrets
