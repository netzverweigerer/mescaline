# mescaline for zsh - based on powerline / ezzsh, but this version is
# vim: ts=2 sw=2 sts=2 et
# entirely re-written from scratch.
# Written by Arminius <armin@arminius.org>

# Released under the terms of the GNU General Public License,
# Version 3, © 2007-2015 Free Software Foundation, Inc. -- http://fsf.org/

# osx detection
if [[ "$(uname)" == "Darwin" ]]; then
  osx=1
else
  osx=0
fi

# set mescaline installation location
mescaline_home="$HOME/git/mescaline"

function _mescaline () {
  export PROMPT="$($mescaline_home/mescaline $?)"
}
precmd () {
	_mescaline
}

# force $TERM on rxvt
if [[ "$COLORTERM" == "rxvt-xpm" ]]; then
    export TERM="rxvt-unicode-256color"
fi

# set $PATH
export PATH=/usr/local/bin:/usr/local/sbin:/usr/sbin:/sbin:$PATH:$HOME/bin

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

# fix for ssh host completion from ~/.ssh/config
[ -f ~/.ssh/config ] && : ${(A)ssh_config_hosts:=${${${${(@M)${(f)"$(<~/.ssh/config)"}:#Host *}#Host }:#*\**}:#*\?*}}

# needed to keep backgrounded jobs running
setopt NO_HUP

# set ls options
LS_OPTIONS="--color=auto --group-directories-first -F"

# ssh key management
if hash keychain >/dev/null 2>&1; then
  kc="$mescaline_home/keychain/"
  mkdir -p "$kc"
  host="$kc/$(uname -n)-sh"
  used=0; if [[ -f $host ]]; then source $host; used=1; fi
  sshc="$(which ssh)"
  function ssh () {
    if [[ $used ]]; then
      echo "re-using keychain"
      "$sshc" "$@"
    else
      keychain > $mescaline_home/keychain/log.txt 2>&1
      "$sshc" "$@"
    fi
  }
fi

# grep with color
alias grep='grep --color=auto'

# enable ls colorization: 
if [ "$TERM" != "dumb" ]; then
  eval "$(dircolors "$mescaline_home"/dircolors)"
  alias ls="ls $LS_OPTIONS"
fi

# disable correction for sudo
alias sudo='nocorrect sudo'

# disable all other correction
unsetopt correct{,all} 

# colored grep / less
alias grep="grep --color='auto'"
alias less='less -R'
alias diff='colordiff'

# additional zsh options
unsetopt menu_complete # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu # show completion menu on succesive tab press
setopt complete_in_word
setopt always_to_end

# word completion/deletion non-boundary characters
WORDCHARS=''

# disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
cdpath=(.)

# Use caching so that commands like apt and dpkg complete are useable
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $mescaline_home/cache/

# unless we really want to
zstyle '*' single-ignored show

# completion - TODO: use more comments here
expand-or-complete-with-dots() {
  echo -n "\e[36mᕁ\e[0m"
  zle expand-or-complete
  zle redisplay
}
zle -N expand-or-complete-with-dots
bindkey "^I" expand-or-complete-with-dots
zmodload -i zsh/complist
zstyle ':completion:*' list-colors ''
bindkey -M menuselect '^o' accept-and-infer-next-history
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"

# TODO: find description for this magic:
autoload -Uz select-word-style
$_ bash
zle -N backward-kill-word-match
bindkey 'tab' $_

# enable completion system
autoload -U compinit && compinit

# set history options
export HISTSIZE=2000 
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE
setopt hist_ignore_all_dups

# use autocd feature
setopt autocd

# When set, you're able to use extended globbing queries such as cp ^*.(tar|bz2|gz) .
setopt extendedglob

if [[ "$(uname)" == "Darwin" ]]; then
  osx=1
fi


