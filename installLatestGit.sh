#!/usr/bin/env  bash
set -x

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi


apt-get install python-software-properties
add-apt-repository ppa:git-core/ppa
apt-get update
apt-get install git
