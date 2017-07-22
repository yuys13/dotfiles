#!/bin/bash

to_lower() {
  cat - | tr "[:upper:]" "[:lower:]"
}

is_linux() {
 [ "$(get_uname)" = linux ]
}

is_centos() {
  [ -f /etc/redhat-release ] && grep CentOS /etc/redhat-release > /dev/null 2>&1
}

is_ubuntu() {
  [ -f /etc/lsb-release ] && grep Ubuntu /etc/lsb-release > /dev/null 2>&1
}

is_osx() {
 [ "$(get_uname)" = darwin ]
}

get_uname() {
  echo $(uname | to_lower)
}

package_install () {
  if is_linux; then
    if which dnf > /dev/null 2>&1; then
      sudo dnf -y install $@
    elif which yum > /dev/null 2>&1; then
      sudo yum -y install $@
    elif which apt > /dev/null 2>&1; then
      sudo apt -y install $@
    else
      echo "cannot filed package manager"
      exit 1
    fi
  elif is_osx; then
    if which brew > /dev/null 2>&1; then
      brew -y install $@
    else
      echo "cannot filed package manager"
      exit 1
    fi
  else
    echo "unknown os type"
    exit 2
  fi
}

