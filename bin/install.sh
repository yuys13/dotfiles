#!/bin/bash

cd $(dirname $0)

. ./util/functions.sh

#for file in ${BASEPATH%/}/bin/$(get_uname)/*.sh
for file in $(get_uname)/*.sh
do
  if [ -f "${file}" ]; then
    echo bash "${file}"
    bash "${file}"
  fi
done

echo complete!

