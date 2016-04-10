#!/bin/sh
# vim: ts=2 sw=2 sts=2 et
#
# simple mescaline setup script
# written by Arminius <armin@arminius.org>
#
# This file is part of mescaline for zsh.
#

# exit on errors
set -e

# parameter expansion to extract the scripts home directory
home="${0%/*}"
# cd to $home
cd "$home"

# print a message
msg () {
	printf "[mescaline] "
  printf "$@ \n"
}

# file/directory exists error message
fileexists () {
  file="$@"
  if [ -e "$file" ]; then
    msg "File or directory exists: "
    msg "${file}"
    msg "I'm not going to overwrite it, so you have to resolve this manually."
    msg "Exiting gracefully. Goodbye."
    exit 1
  fi
}

# check for conflicts
fileexists "$HOME/.mescaline"
fileexists "$HOME/.zshrc"

mkdir -p "$HOME/.mescaline"
cp -R ./ "$HOME/.mescaline"
cd
ln -s .mescaline/zshrc .zshrc || msg 'Symbolic link ~/.zshrc exists, I will not touch this for you.'

msg "setup complete."




