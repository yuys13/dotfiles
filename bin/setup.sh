#!/bin/bash

to_lower() {
    cat - | tr "[:upper:]" "[:lower:]"
}

is_linux() {
    [ "$(get_uname)" = linux ]
}

is_darwin() {
    [ "$(get_uname)" = darwin ]
}

get_uname() {
    echo $(uname | to_lower)
}

package_install () {
    if is_linux; then
        if which dnf > /dev/null 2>&1; then
            sudo dnf install $@
        elif which yum > /dev/null 2>&1; then
            sudo yum install $@
        elif which apt > /dev/null 2>&1; then
            sudo apt install $@
        else
            echo "cannot filed package manager"
            exit 1
        fi
    elif is_darwin; then
        if which brew > /dev/null 2>&1; then
            brew install $@
        else
            echo "cannot filed package manager"
            exit 1
        fi
    else
        echo "unknown os type"
        exit 2
    fi
}

if ! which git >/dev/null 2>&1; then
    package_install git
fi

if ! which git >/dev/null 2>&1; then
    echo git not installed.
    exit 1
fi

git clone https://github.com/yuys13/dotfiles.git ${HOME}/dev/src/github.com/yuys13/dotfiles
cd ${HOME}/dev/src/github.com/yuys13/dotfiles
make install

