#
# [mescaline] zshrc for zsh - based on powerline / ezzsh, but this version is
# entirely re-written from scratch.
#
# version ##version##; written and copyright by Armin Jenewein.
#
# set vim indenting if ":set modeline" is used in vim
# vim: ts=2 sw=2 sts=2 et
#
# mescaline is released under the terms of the GNU General Public License,
# Version 3, © Free Software Foundation Inc., http://fsf.org/
#
# This is free (as in "freedom") software, without ANY warranty,
# but with best wishes and written in the hope that you may find it useful.

# set mescaline installation location
mescaline_home="$HOME/git/mescaline"

function _mescaline () {
  export PROMPT="$($mescaline_home/mescaline $?)"
}
precmd () {
	_mescaline
}

# force $TERM on rxvt-xpm compatible rxvt
if [[ "$COLORTERM" == "rxvt-xpm" ]]; then
    export TERM="rxvt-unicode-256color"
fi

# set $PATH variable (notice the *appended* ~/bin)
export PATH="$PATH:/usr/local/bin:/usr/local/sbin:/usr/sbin:/sbin:$HOME/bin"

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

# enable dirty zsh ssh host completion workaround hack for ~/.ssh/config
# : ${(A)ssh_config_hosts:=${${${${(@M)${(f)"$(<~/.ssh/config)"}:#Host *}#Host }:#*\**}:#*\?*}}

# keep backgrounded jobs running
setopt NO_HUP

# set ls options
LS_OPTIONS="--color=auto --group-directories-first -F"

# set $osx variable to 1 if we are on OS X
if [[ "$(uname)" == "Darwin" ]]; then
  osx=1
else
  osx=0
fi

# osx specific settings:
if [[ "$osx" ]]; then
  # homebrew setup
  if hash brew; then
    # preceed path with homebrew stuff:
    export PATH="/usr/local/sbin:/usr/local/bin:$PATH"
    # enable homebrew verbosity
    export HOMEBREW_VERBOSE=1
    export HOMEBREW_CURL_VERBOSE=1
    # disable homebrew emoji:
    export HOMEBREW_NO_EMOJI=1
   fi
  # alias for custom ipython from ~/git from ~/git/ipython
  if [[ -f $HOME/git/ipython/bin/ipython ]]; then
    alias ipython="$HOME/git/ipython/bin/ipython"
  fi
  # use ls from GNU coreutils because the oldschool bsd ls doesn't know long
  # options like --group-directories-first
  if hash gls; then
    LS_COMMAND="gls"
  else
    LS_COMMAND="ls"
  fi
  # same for dircolors
  if hash gdircolors; then alias dircolors="gdircolors"; fi
else
  # use normal "ls" command on non-osx systems
  LS_COMMAND="ls"
fi

# finally, set alias for ls
alias ls="$LS_COMMAND $LS_OPTIONS"

# enable dircolors
eval "$(dircolors "$mescaline_home"/dircolors)"

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

# if glob returns multiple matches, abort
zstyle '*' single-ignored show

# completion setup
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
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"

# word selection style
autoload -Uz select-word-style
select-word-style bash
zle -N backward-kill-word-match
bindkey 'tab' backward-kill-word-match

# enable completion system
autoload -U compinit && compinit

# set history options
export HISTSIZE=2000 
export HISTFILE="$HOME/.history"
export SAVEHIST="$HISTSIZE"
setopt hist_ignore_all_dups

# use autocd feature
setopt autocd

# use extended globbing queries - example: cp ^*.(tar|bz2|gz) .
setopt extendedglob

# EOF

