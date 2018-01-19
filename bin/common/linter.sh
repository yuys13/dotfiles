#!/bin/bash

cd $(dirname $0)
. ../util/functions.sh

pip_install() {
    local BIN_NAME=$1
    local PACKAGE_NAME=${BIN_NAME}
    if [ $# -ge 2 ]; then
        PACKAGE_NAME=$2
    fi

    if type ${BIN_NAME} > /dev/null; then
        echo ${PACKAGE_NAME} already installed
        return
    fi

    ${SUDO} pip3 install --user ${PACKAGE_NAME}
}

npm_install() {
    local BIN_NAME=$1
    local PACKAGE_NAME=${BIN_NAME}
    if [ $# -ge 2 ]; then
        PACKAGE_NAME=$2
    fi

    if type ${BIN_NAME} > /dev/null; then
        echo ${PACKAGE_NAME} already installed
        return
    fi

    npm install ${PACKAGE_NAME} --global
}

main() {
    if type pip3 > /dev/null; then
        pip_install "vint" "vim-vint"
        pip_install "gitlint"
    fi

    if type npm > /dev/null; then
        npm_install "alex"
        npm_install "write-good"
    fi

    if type go > /dev/null; then
        go get -u github.com/mrtazz/checkmake
    fi
}

main

