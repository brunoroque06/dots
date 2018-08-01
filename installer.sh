#!/bin/bash 

FILES=".vimrc .zshrc"

for file in $FILES; do
  ln -s `pwd`/$file ~/$file
done

source ~/.zshrc
