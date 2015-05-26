# mescaline for zsh - based on powerline

zsh="$HOME/.mescaline/"

function _mescaline () {
  export PROMPT="$(~/.mescaline/mescaline $?)"
}

precmd () {
	_mescaline
}


# workaround for xfce4-terminal to force $TERM:
if [[ "$COLORTERM" == "xfce4-terminal" ]]; then
    export TERM="xterm-256color"
fi

# workaround for rxvt-unicode
if [[ "$COLORTERM" == "rxvt-xpm" ]]; then
    export TERM="rxvt-unicode-256color"
fi

# set $OS_TYPE
export OS_TYPE="$(uname)"

# $PATH
export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:/usr/sbin:/sbin:$PATH

# $EDITOR
export EDITOR='vim'

# man pages color
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;33m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# zsh fix for ssh host completion from ~/.ssh/config
[ -f ~/.ssh/config ] && : ${(A)ssh_config_hosts:=${${${${(@M)${(f)"$(<~/.ssh/config)"}:#Host *}#Host }:#*\**}:#*\?*}}

# needed to keep backgrounded jobs running when exiting zsh:
setopt NO_HUP

# set ls options
LS_OPTIONS="--color=auto --group-directories-first -F"

# enable ls colorization: 
if [ "$TERM" != "dumb" ]; then
  eval "$(dircolors "$zsh"/dircolors)"
  alias ls="ls $LS_OPTIONS"
fi

# set $SHELL:
export SHELL="$(which zsh)"

# keychain stuff
if [[ "$OS_TYPE" == "Linux" ]]; then
if hash keychain; then
ssh_cmd="$(which ssh)"
function ssh () {
echo "$@" >> $HOME/.keychain-args
echo "$(date)" > $HOME/.keychain-output
keychain id_rsa >> $HOME/.keychain-output 2>&1
[ -z "$HOSTNAME" ] && HOSTNAME=`uname -n`
[ -f $HOME/.keychain/$HOSTNAME-sh ] && \
. $HOME/.keychain/$HOSTNAME-sh
[ -f $HOME/.keychain/$HOSTNAME-sh-gpg ] && \
. $HOME/.keychain/$HOSTNAME-sh-gpg
"$ssh_cmd" "$@"
}
fi

fi

# grep with color
alias grep='grep --color=auto'

# enable ls colorization: 
if [ "$TERM" != "dumb" ]; then
  eval "$(dircolors "$zsh"/dircolors)"
  alias ls="ls $LS_OPTIONS"
fi

# do not autocorrect sudo commands (fixes "zsh: correct 'vim' to '.vim' [nyae]?")
alias sudo='nocorrect sudo'

# the more brutal attempt:
unsetopt correct{,all} 

# colored grep / less
alias grep="grep --color='auto'"
alias less='less -R'
alias diff='colordiff'


unsetopt menu_complete # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu # show completion menu on succesive tab press
setopt complete_in_word
setopt always_to_end

WORDCHARS=''

zmodload -i zsh/complist
zstyle ':completion:*' list-colors ''

# should this be in keybindings?
bindkey -M menuselect '^o' accept-and-infer-next-history
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"

# disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
cdpath=(.)

# Use caching so that commands like apt and dpkg complete are useable
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH/cache/

# unless we really want to
zstyle '*' single-ignored show

expand-or-complete-with-dots() {
#    echo -n "\e[36mч\e[0m"
    echo -n "\e[36mᕁ\e[0m"
    zle expand-or-complete
    zle redisplay
  }
  zle -N expand-or-complete-with-dots
  bindkey "^I" expand-or-complete-with-dots

# set backspace boundaries
autoload -Uz select-word-style
$_ bash
zle -N backward-kill-word-match
bindkey 'tab' $_

# enable the advanced completion system
autoload -U compinit && compinit



