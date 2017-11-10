#!/bin/bash

cd $(dirname $0)
. ../util/functions.sh

if is_darwin; then
    return
fi

if is_ubuntu; then
    package_install mercurial binutils bison build-essential
elif [ -f /etc/redhat-release ]; then
    package_install bison
    package_install glibc-devel
fi

if [ ! -d ${HOME}/.gvm ]; then
    bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
    if [ ! -d ${HOME}/.local/share/zsh ]; then
        mkdir ${HOME}/.local/share/zsh
    fi
    echo '[[ -s ${HOME}/.gvm/scripts/gvm ]] && source ${HOME}/.gvm/scripts/gvm' >> ${HOME}/.local/share/zsh/zshenv
fi

