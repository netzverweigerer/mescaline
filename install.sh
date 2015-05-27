#!/bin/sh
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

# print an error message and exit with an error code != 0
error () {
  msg="$@"
	printf "Critical error: %s" "${msg}"
	exit 1
}

# check for conflicting ".mescaline" in your home directory, and if all is
# cool, copy over mescaline files to ~/.mescaline
if [[ -e $HOME/.mescaline ]]; then
	error "mescaline exists in your home directory, exiting."
	exit 1
else
  mkdir -p $HOME/.mescaline
	cp -R ./ $HOME/.mescaline; cd; ln -s .mescaline/zshrc .zshrc
fi



