#!/bin/bash -e

if ! command -v git >/dev/null 2>&1; then
    echo git not installed.
    exit 1
fi

git clone https://github.com/yuys13/dotfiles.git "${HOME}"/src/github.com/yuys13/dotfiles
cd "${HOME}"/src/github.com/yuys13/dotfiles
make link
