#!/bin/bash -e

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
    uname | to_lower
}

package_install () {
    if is_linux; then
        if command -v dnf >/dev/null 2>&1; then
            sudo dnf install "$@"
        elif command -v yum >/dev/null 2>&1; then
            sudo yum install "$@"
        elif command -v apt >/dev/null 2>&1; then
            sudo apt install "$@"
        else
            echo "cannot filed package manager"
            exit 1
        fi
    elif is_darwin; then
        if command -v brew >/dev/null 2>&1; then
            brew install "$@"
        else
            echo "cannot filed package manager"
            exit 1
        fi
    else
        echo "unknown os type"
        exit 2
    fi
}

if ! command -v git >/dev/null 2>&1; then
    package_install git
fi

if ! command -v git >/dev/null 2>&1; then
    echo git not installed.
    exit 1
fi

git clone https://github.com/yuys13/dotfiles.git "${HOME}"/src/github.com/yuys13/dotfiles
cd "${HOME}"/src/github.com/yuys13/dotfiles
make install

