#!/bin/bash 

FILES=".alias .spoud .vimrc .zshrc"

for file in $FILES; do
  ln -s $(pwd)/$file ~/$file
done

exec zsh
