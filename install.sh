#!/bin/sh
# vim: ts=2 sw=2 sts=2 et
#
# simple mescaline setup script
# written by Arminius <armin@arminius.org>
#
# This file is part of mescaline for zsh.
#

# parameter expansion to extract the scripts home directory
home="${0%/*}"

# cd to parent location folder
cd "$home"

# print a message
msg () {
	printf "[mescaline] "
  printf "$@ \n"
}

bailout () {
  printf "ERROR: $@\n"
  exit 255
}

# file/directory exists error message
fileexists () {
  if [ -e "$1" ]; then
    msg "File or directory exists: $1"
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

ln -s .mescaline/zshrc .zshrc || bailout 'Symbolic link ~/.zshrc exists, I will not touch this for you.'

msg "setup complete."




