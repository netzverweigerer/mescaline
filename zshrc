# mescaline for zsh - based on powerline / ezzsh, but this version is
# entirely re-written from scratch.
# Written by Arminius <armin@arminius.org>
#
# Released under the terms of the GNU General Public License,
# Version 3, © 2007-2015 Free Software Foundation, Inc. -- http://fsf.org/

# set mescaline installation location (no need to suffix with /)
mescaline_home="$HOME/.mescaline"

# set path to zsh-syntax-highlighting file
zsh_syntax_highlighting_file="$HOME/git/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

_mescaline () {

if [[ ! "$TERM" == linux ]]; then;
	if [[ "$TERM" != "dumb" ]]; then
		export PROMPT="$($mescaline_home/mescaline $1 2>/dev/null)"
	else
		export PROMPT="[zsh] $ "
	fi
else
  export PROMPT="[zsh] > "
fi

print -Pn "\e]0;%n@%m: %~\a"
}

# call _mescaline function
precmd () {
	_mescaline "$?"
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

# fix for ssh host completion from ~/.ssh/config (yes, this is ugly, sorry for this)
[ -f ~/.ssh/config ] && : ${(A)ssh_config_hosts:=${${${${(@M)${(f)"$(<~/.ssh/config)"}:#Host *}#Host }:#*\**}:#*\?*}}

# needed to keep backgrounded jobs running
setopt NO_HUP

# set ls options
ls_options="--color=auto --group-directories-first -F"

# ls_options="-F"

dircolors_command="dircolors"
ls_command="ls"

# enable ls colorization: 
if [[ "$TERM" != "dumb" ]]; then
if [[ "$TERM" != "linux" ]]; then
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;38;2;74m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[38;5;46m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32;2;12m'

# NOTE: this sets $LS_COLORS as well:
if hash "$dircolors_command" >/dev/null 2>&1; then
  eval "$("$dircolors_command" "$mescaline_home"/dircolors)"
fi

export ls_options
export LS_COLORS

alias ls="$ls_command $ls_options"
# colored grep / less
alias grep="grep --color='auto'"
alias less='less -R'
alias diff='colordiff'
fi
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
    echo -n "\e[36m⌛\e[0m"
    zle expand-or-complete
    zle redisplay
}









#DISABLED
# bindkey 'tab' expand-or-complete-with-dots
# bindkey "^I" expand-cmd-path 
# bindkey "^I" expand-cmd-path 
#
bindkey "^I" expand-or-complete-with-dots





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

# fix home/end keys
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line

# share history among sessions?
setopt share_history


. /etc/profile


export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export PATH="$PATH:/usr/local/libexec/git-core"

if [[ -f "$zsh_syntax_highlighting_file" ]]; then
  . "$zsh_syntax_highlighting_file"
fi

# custom aliases
if [[ -f "$HOME/.zsh_aliases" ]]; then
  . $HOME/.zsh_aliases
fi

# source environment setup file
if [ -f $HOME/.env ]; then
  source $HOME/.env
fi


