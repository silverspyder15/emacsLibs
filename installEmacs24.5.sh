#!/usr/bin/env  bash
set -x

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi


apt-get install build-essential
apt-get build-dep emacs24
tar -xf emacs-24.5.tar.*
pushd emacs-24.5
./configure
make
make install
popd
