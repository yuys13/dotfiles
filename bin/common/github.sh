#!/bin/bash

cd $(dirname $0)
. ../util/functions.sh

if is_ubuntu; then
  echo please install hub manually
else
  package_install hub
fi

