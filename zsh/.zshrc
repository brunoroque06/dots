#!/usr/bin/env bash

# Auto-completion
zstyle ':completion:*' completer _oldlist _expand _complete _match _ignored _approximate
zstyle ':completion:*' menu select

# Binds
bindkey "^[[3~" delete-char
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward

# Exports
PATH=$PATH:$(go env GOPATH)/bin:$HOME/Library/Python/3.7/bin:$(ruby -e 'print Gem.user_dir')/bin
export PATH
export SSH_KEY_PATH="$HOME/.ssh/rsa_id"
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk-10.0.2.jdk/Contents/Home"

# FZF
readonly FZF_COMMAND="find . -not \\( -path ./.git -prune \\) -not \\( -path ./node_modules -prune \\) -type f | cut -c3-"
export FZF_DEFAULT_COMMAND=$FZF_COMMAND
export FZF_CTRL_T_COMMAND=$FZF_COMMAND
export FZF_DEFAULT_OPTS='--height 20% --layout=reverse'

# History
export HISTSIZE=1000
export SAVEHIST=1000
HISTFILE=$HOME/.history
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS

# Sources
source "$HOME"/.aliases
source "$HOME"/.spoud
source "$HOME"/.secrets
[ -f "$HOME"/.fzf.zsh ] && source "$HOME"/.fzf.zsh

# Plugins
source "$HOME"/.zsh_plugins
plugins_load
