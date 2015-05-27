#!/bin/sh
# vim: ts=2 sw=2 sts=2 et
#
# simple mescaline setup script
# written by Arminius <armin@arminius.org>
#
# This file is part of mescaline for zsh.
#

# parameter expansion to extract the scripts home directory
script="${0%/*}"
home="$(readlink -f $script)"
cd "$home"

# print a message
msg () {
  msg="$@"
	printf "[mescaline] %s \n" "${msg}"
}

# check for conflicting ".mescaline" in your home directory, and if all is
# cool, copy over mescaline files to ~/.mescaline
if [ -e $HOME/.mescaline ]; then
	msg "mescaline already exists in your home directory:"
	ls -ald "$HOME/.mescaline"
	msg "I'm not going to overwrite it, so you have to resolve this \
		situation on your own."
	exit 1
else
  mkdir -p $HOME/.mescaline
	cp -R ./ $HOME/.mescaline; cd; ln -s .mescaline/zshrc .zshrc
fi



