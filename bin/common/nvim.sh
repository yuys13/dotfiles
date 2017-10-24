#!/bin/bash

cd $(dirname $0)
. ../util/functions.sh

if is_ubuntu; then
  return
fi

if ! which nvim > /dev/null 2>&1; then
    package_install neovim
fi

echo install dein.vim

#if [ ! -e ~/.local/share/dein/repos/github.com/Shougo ]; then
#    mkdir -p ~/.local/share/dein/repos/github.com/Shougo
#fi

git clone https://github.com/Shougo/dein.vim ~/.local/share/dein/repos/github.com/Shougo/dein.vim

