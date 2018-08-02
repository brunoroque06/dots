#!/bin/bash 

FILES=".alias .gitconfig .spoud .vimrc .zshrc"

for file in $FILES; do
  ln -s $(pwd)/$file ~/$file
done

exec zsh
