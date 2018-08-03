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
readonly PURE_PROMPT_SYMBOL='λ'
readonly PURE_GIT_DOWN_ARROW='▼'
readonly PURE_GIT_UP_ARROW='▲'

# Search
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward

# Sources
source $HOME/.credentials
source $HOME/.alias
source $HOME/.spoud

# Exports
export PATH=$PATH:$HOME/bin
export SSH_KEY_PATH="$HOME/.ssh/rsa_id"
readonly EDITOR='vim'
