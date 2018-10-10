#!/usr/bin/env bash

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

# Binds
bindkey "^[[3~" delete-char
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward

# Exports
export PATH=$PATH:$(go env GOPATH)/bin
export SSH_KEY_PATH="$HOME/.ssh/rsa_id"
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk-10.0.2.jdk/Contents/Home"

# FZF
readonly FZF_COMMAND="find . -not \\( -path ./.git -prune \\) -not \\( -path ./node_modules -prune \\) -type f | cut -c3-"
export FZF_DEFAULT_COMMAND=$FZF_COMMAND
export FZF_CTRL_T_COMMAND=$FZF_COMMAND
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse'

# History
setopt inc_append_history
setopt share_history
setopt HIST_IGNORE_ALL_DUPS

# Theme
readonly PURE_PROMPT_SYMBOL='λ'
readonly PURE_GIT_DOWN_ARROW='▼'
readonly PURE_GIT_UP_ARROW='▲'

# Sources
source "$HOME"/.aliases
source "$HOME"/.spoud
source "$HOME"/.secrets
[ -f "$HOME"/.fzf.zsh ] && source "$HOME"/.fzf.zsh

