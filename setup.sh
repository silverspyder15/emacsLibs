#!/usr/bin/env  bash

set -x

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

cp -r emacs ~
cp .emacs ~
cp pycscope* /usr/local/bin/.


# Replace all instances of nilesh with your username inside
# ~/.emacs
# ~/emacs/site-lisp/init.el
# ~/emacs/site-lisp/magit/config.mk
curUser=`who am i | awk '{print $1}'`
sed -i "s/nilesh/$curUser/g" ~/.emacs ~/emacs/site-lisp/init.el ~/emacs/site-lisp/magit/config.mk
