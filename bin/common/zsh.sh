#!/bin/bash

cd $(dirname $0)
. ../util/functions.sh

if is_ubuntu; then
  package_install gawk
fi

package_install zsh

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

#curl -sL --proto-redir -all,https https://zplug.sh/installer | zsh
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
