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
}

# call _mescaline function
precmd () {
	_mescaline
}

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
LS_OPTIONS="--color=auto --group-directories-first -F"

# keychain
if hash keychain; then
	_s="$(which ssh)"
	ssh () {
		keychain >/dev/null 2>&1
		h="$(uname -n)-sh"
		[ -f $h ] && . $h
		$_s "$@"
	}
fi

# grep with color
alias grep='grep --color=auto'

# enable ls colorization: 
if [ "$TERM" != "dumb" ]; then
  eval "$(dircolors "$mescaline_home"/dircolors)"
	export LS_OPTIONS
  alias ls="ls $LS_OPTIONS"
fi

# disable auto correction (sudo)
alias sudo='nocorrect sudo'

# disable auto correction (global)
unsetopt correct{,all} 

# colored grep / less
alias grep="grep --color='auto'"
alias less='less -R'
alias diff='colordiff'

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
WORDCHARS=''

# load complist mod
zmodload -i zsh/complist

# completion list color definitions
zstyle ':completion:*' list-colors ''

# enable in-menu keybindings
bindkey -M menuselect '^o' accept-and-infer-next-history
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"

# disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
cdpath=(.)

# allow extended globbing
setopt extendedglob

# don't complete first match (wildcard match)
zstyle '*' single-ignored show

# enable completion system
autoload -U compinit && compinit

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
$_ bash

# enable backward-kill-word-match
zle -N backward-kill-word-match

# history options 
export HISTSIZE=2000 
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE
setopt hist_ignore_all_dups

# automatically cd to dir without "cd" needed
setopt autocd


