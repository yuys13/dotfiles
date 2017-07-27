#!/bin/bash

cd $(dirname $0)
. ../util/functions.sh

brew tap tkengo/highway
package_install highway

