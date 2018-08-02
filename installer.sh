#!/bin/bash

FILES=".alias bin .gitconfig .spoud .vimrc .zshrc"

for file in $FILES; do
  ln -s $(pwd)/$file ~/$file
done

source ~/.zshrc
