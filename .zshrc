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

# Theme
readonly PURE_PROMPT_SYMBOL='λ'
readonly PURE_GIT_DOWN_ARROW='▼'
readonly PURE_GIT_UP_ARROW='▲'

# Binds
bindkey "^[[3~" delete-char
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward

# Sources
source "$HOME"/.aliases
source "$HOME"/.spoud
source "$HOME"/.secrets

# Exports
export SSH_KEY_PATH="$HOME/.ssh/rsa_id"
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk-10.0.2.jdk/Contents/Home"
readonly EDITOR='vim'

# FZF
export FZF_DEFAULT_COMMAND="find . -type f -not -path '*/\.git/*' | cut -c3-"
export FZF_CTRL_T_COMMAND="find . -type f -not -path '*/\.git/*' | cut -c3-"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

