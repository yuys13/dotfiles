#!/bin/bash

cd $(dirname $0)
. ../util/functions.sh

if ! which zsh > /dev/null 2>&1; then
  package_install zsh
fi

echo create XDG Base Directories

if [ ! -e ~/.config ]; then
  mkdir -p ~/.config
fi

if [ ! -e ~/.cache ]; then
  mkdir -p ~/.cache
fi

if [ ! -e ~/.local/share/zsh ]; then
  mkdir -p ~/.local/share/zsh
fi

if is_ubuntu; then
  package_install gawk
fi

curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

