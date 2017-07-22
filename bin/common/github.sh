#!/bin/bash

cd $(dirname $0)
. ../util/functions.sh

if is_ubuntu; then
    ../common/gvm.sh
    echo please install hub manually

    ## for normal install
    #source ${HOME}/.gvm/scripts/gvm

    #gvm install go1.4 -B && \
    #gvm use go1.4 && \
    #gvm install go1.8.3 &&\
    #gvm use go1.8.3 --default

    #go get -u github.com/github/hub && echo hub command installed
else
    package_install hub
fi

