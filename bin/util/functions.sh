#!/bin/bash

to_lower() {
    cat - | tr "[:upper:]" "[:lower:]"
}

is_linux() {
    [ "$(get_uname)" = linux ]
}

is_centos() {
    [ -f /etc/redhat-release ] && grep CentOS /etc/redhat-release >/dev/null 2>&1
}

is_ubuntu() {
    [ -f /etc/lsb-release ] && grep Ubuntu /etc/lsb-release >/dev/null 2>&1
}

is_darwin() {
    [ "$(get_uname)" = darwin ]
}

get_uname() {
    uname | to_lower
}

package_install() {
    if is_linux; then
        if command -v dnf >/dev/null 2>&1; then
            sudo dnf -y install "$@"
        elif command -v yum >/dev/null 2>&1; then
            sudo yum -y install "$@"
        elif command -v apt >/dev/null 2>&1; then
            sudo apt -y install "$@"
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
