#!/usr/bin/env  bash

set -x

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

cp -r emacs ~
cp .emacs ~
cp pycscope* /usr/local/bin/.
