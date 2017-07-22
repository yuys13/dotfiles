#!/bin/bash

source ${GVM_ROOT}/scripts/gvm

gvm install go1.4 -B && \
gvm use go1.4 && \
gvm install go1.8.3 &&\
gvm use go1.8.3 --default

go get -u github.com/github/hub && echo hub command installed

