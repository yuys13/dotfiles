#!/bin/bash

if ! which git >/dev/null 2>&1; then
    echo git not installed.
    exit 1
fi

git clone https://github.com/yuys13/dotfiles.git ${HOME}/dotfiles
cd ${HOME}/dotfiles
make link

