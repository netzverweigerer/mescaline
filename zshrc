# mescaline for zsh - based on powerline / ezzsh, but this version is
# entirely re-written from scratch.
# Written by Arminius <armin@arminius.org>
#
# Released under the terms of the GNU General Public License,
# Version 3, © 2007-2015 Free Software Foundation, Inc. -- http://fsf.org/

# set mescaline installation location
mescaline_home="$HOME/git/mescaline/"

_mescaline () {
  export PROMPT="$($mescaline_home/mescaline $?)"
	print -Pn "\e]0;%n@%m: %~\a"
}

# call _mescaline function
precmd () {
	_mescaline
}

# osx specifics
if [[ "$(uname)" == "Darwin" ]]; then
  osx=1
else
  osx=0
fi

# force $TERM on rxvt
if [[ "$COLORTERM" == "rxvt-xpm" ]]; then
  export TERM="rxvt-unicode-256color"
fi

# force $TERM on xfce4-terminal
if [[ "$COLORTERM" == "xfce4-terminal" ]]; then
  export TERM="xterm-256color"
fi

# set $PATH
export PATH="/usr/local/bin:/usr/local/sbin:/usr/sbin:/sbin:$PATH:"

# set standard editor via $EDITOR
if hash vim; then
  export EDITOR='vim'
else
	export EDITOR='vi'
fi

# show man pages color
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;33m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# fix for ssh host completion from ~/.ssh/config (yes, this is ugly, sorry for this)
[ -f ~/.ssh/config ] && : ${(A)ssh_config_hosts:=${${${${(@M)${(f)"$(<~/.ssh/config)"}:#Host *}#Host }:#*\**}:#*\?*}}

# needed to keep backgrounded jobs running
setopt NO_HUP

# set ls options
ls_options="--color=auto --group-directories-first -F"

# OS X specifics - allows us to use some GNU coreutils overrides.
# we use variables here, as aliasing aliases may not work.
if [[ "$osx" -gt 0 ]]; then
  dircolors_command="gdircolors"
  ls_command="gls"
else
  dircolors_command="dircolors"
  ls_command="ls"
fi

# enable ls colorization: 
if [[ "$TERM" != "dumb" ]]; then
  # this sets $LS_COLORS as well:
  eval "$("$dircolors_command" "$mescaline_home"/dircolors)"
  export ls_options
  export LS_COLORS
  alias ls="$ls_command $ls_options"
  # colored grep / less
  alias grep="grep --color='auto'"
  alias less='less -R'
  alias diff='colordiff'
fi

# disable auto correction (sudo)
alias sudo='nocorrect sudo'

# disable auto correction (global)
unsetopt correct{,all} 

# don't select first tab menu entry
unsetopt menu_complete

# disable flowcontrol
unsetopt flowcontrol

# enable tab completion menu
setopt auto_menu

# enable in-word completion
setopt complete_in_word
setopt always_to_end

# word characters
# WORDCHARS='-'
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# load complist mod
zmodload -i zsh/complist

# completion list color definitions
zstyle ':completion:*' list-colors ''

# enable in-menu keybindings
bindkey -M menuselect '^o' accept-and-infer-next-history
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:*:*:*:*' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=00;33=0=01'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"

# disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
cdpath=(.)

# allow extended globbing
setopt extendedglob

# don't complete first match (wildcard match)
zstyle '*' single-ignored show

# enable completion system (-i: disable check for insecure
# files/directories)
autoload -U compinit && compinit -i

# use expand-or-complete-with-dots
zle -N expand-or-complete-with-dots
expand-or-complete-with-dots() {
    echo -n "\e[36mᕁ\e[0m"
    zle expand-or-complete
    zle redisplay
}
bindkey "^I" expand-or-complete-with-dots
bindkey 'tab' expand-or-complete-with-dots

# load "select-word-style"
autoload -Uz select-word-style

# it's magic!
select-word-style bash

# enable backward-kill-word-match
zle -N backward-kill-word-match

# history options 
export HISTSIZE=2000 
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE
setopt hist_ignore_all_dups

# automatically cd to dir without "cd" needed
setopt autocd

# this let's us select keymaps (command prompt input mode)
zle -N zle-keymap-select

# use emacs line editing (command prompt input mode)
bindkey -e

_ssh-agent-wrapper () {
	source $HOME/bin/ssh-check-identities
	ssh "$@"
}

compdef g='git'
alias g='git'


compdef s='ssh'
alias s='ssh'

if [[ -n $SSH_AGENT_SETTINGS ]]; then
	eval "$SSH_AGENT_SETTINGS"
else
	echo "SSH_AGENT_SETTINGS is unset."
fi

# alias ssh="_ssh-agent-wrapper"

alias bspwm-edit-config="vi $HOME/git/bspwm/config"

alias dzen2='dzen2 -fn verdana-7 -bg "#262626"'

$HOME/bin/space-invaders.sh


