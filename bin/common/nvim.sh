#!/bin/bash

cd $(dirname $0)
. ../util/functions.sh

if is_ubuntu; then
    return
fi

if ! which nvim > /dev/null 2>&1; then
    package_install neovim
fi

