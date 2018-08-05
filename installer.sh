#!/bin/bash

FILES=".aliases bin .gitconfig .spoud .vimrc .zshrc"

for file in $FILES; do
  ln -s $(pwd)/$file $HOME/$file
done

source $HOME/.zshrc
