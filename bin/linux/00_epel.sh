#!/bin/bash

cd $(dirname $0)
. ../util/functions.sh

if is_centos; then
  package_install epel-release
fi

