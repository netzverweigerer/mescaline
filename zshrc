# mescaline for zsh - based on powerline / ezzsh, but this version is
# entirely re-written from scratch.
# Written by Arminius <armin@mutt.email>
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
export PATH="$HOME/bin:/usr/local/bin:/usr/local/sbin:/usr/sbin:/sbin:$PATH"
# set standard editor via $EDITOR
if hash vim 2>&1 >/dev/null; then
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
# [ -f ~/.ssh/config ] && : ${(A)ssh_config_hosts:=${${${${(@M)${(f)"$(<~/.ssh/config)"}:#Host *}#Host }:#*\**}:#*\?*}}
# needed to keep backgrounded jobs running
setopt NO_HUP
# set ls options
ls_options="--color=auto --group-directories-first -F"
# grep with color
alias grep='grep --color=auto'
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
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
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

# dirty hack to enable ssh host completions
h=()
if [[ -r ~/.ssh/config ]]; then
  h=($h ${${${(@M)${(f)"$(cat ~/.ssh/config)"}:#host *}#host }:#*[*?]*})
fi
if [[ -r ~/.ssh/known_hosts ]]; then
  h=($h ${${${(f)"$(cat ~/.ssh/known_hosts{,2} || true)"}%%\ *}%%,*}) 2>/dev/null
fi
if [[ $#h -gt 0 ]]; then
  zstyle ':completion:*:ssh:*' hosts $h
  zstyle ':completion:*:slogin:*' hosts $h
fi

# simple ssh wrapper
_ssh="$(which ssh)";ssh(){tput setaf 241; $_ssh -v "$@"; tput setaf 248}

# debian/apt aliases
alias apt-get="tput setaf 106; sudo apt-get -y"
alias aptitude="sudo aptitude -y"
alias apt-cache="sudo apt-cache"
alias apt-file="sudo apt-file"
alias install='sudo apt-get -y install'

# pentadactyl -> firefox alias 
alias pentadactyl=firefox

# gpg aliases
alias gpg="gpg --keyserver wwwkeys.eu.pgp.net"

# sudo: retain customized user environment
alias sudo="sudo -E"

if [[ -f "$HOME/.ssh-agent.out" ]]; then
	grep -v '^echo' $HOME/.ssh-agent.out | while read line; do eval "$line"; done
fi

# does what the name says.
alias getporn="$HOME/git/getporn.github.io/getporn"

# FIXME
zstyle ':completion:*:default' list-colors $LS_COLORS





