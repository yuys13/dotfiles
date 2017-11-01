#!/bin/bash

cd $(dirname $0)

. ./util/functions.sh

if [ -n "${XDG_CONFIG_HOME}" ]; then
  if [ ! -e ${XDG_CONFIG_HOME} ]; then
    mkdir -p ${XDG_CONFIG_HOME}
  fi
else
  if [ ! -e ~/.config ]; then
    mkdir -p ~/.config
  fi
fi

if is_darwin && ! which brew >> /dev/null 2>&1; then
  /usr/bin/ruby -e "$(curl -fsSL https:/raw.githubusercontent.com/Homebrew/install/master/install)"
fi

#for file in ${BASEPATH%/}/bin/$(get_uname)/*.sh
for file in $(get_uname)/*.sh
do
  if [ -f "${file}" ]; then
    echo bash "${file}"
    bash "${file}"
  fi
done

echo complete install!

