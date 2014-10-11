#
# ~/.bashrc
#

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# History settings
HISTCONTROL=ignoreboth
HISTSIZE=100000
HISTFILESIZE=200000
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# Auto cd when entering just a path
shopt -s autocd

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Set PS1
if [ `id -u` = "0" ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# Enable programmable completion features
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Add ~/bin to path
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# Set editor
export EDITOR="vim"

# Coloured man pages
man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}

# Set XDG dirs
export XDG_CONFIG_HOME=~/.config/
export XDG_CACHE_HOME=~/.cache/

# Set vimrc's location and source it on vim startup
export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'

# Dont display ^C
stty -ctlecho

# Command not found hook (requires pkgfile)
source /usr/share/doc/pkgfile/command-not-found.bash

################
# Bash aliases #
################

# cd
#
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# pacman
#
alias pacu='pacman -Syu'
alias paci='pacman -S'
alias pacr='pacman -Rs'
alias pacrf='pacman -Rns'
alias pacs='pacman -Ss'

# systemd
#
alias sc='systemctl'
alias scu='systemctl --user'
alias jc='journalctl'
alias journ='journalctl -b -n 500 -f'

# grep
#
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias pg='ps -Af | grep $1'
alias hist='history | grep'

# ls
#
alias ls='ls -lh --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'

# vi
#
alias vi='vim'

# git
alias gita='git add '
alias gitc='git commit -a'
alias gitp='git push'
alias gitl='git log --graph --oneline --decorate'
alias gits='git status'

# misc
alias df='df -h -t ext4'
alias du='du -h --max-depth=1 | sort -hr'
alias lsblk='lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT,LABEL,UUID'
alias strc="awk '!/^ *#/ && NF'"


##################
# Bash functions #
##################


# Package list
#

packages () {
	cat <<-EOF

	# Repository packages
	#

	$(comm -23 <(comm -23 <(pacman -Qeq|sort) <(pacman -Qgq base base-devel|sort)) <(pacman -Qqm|sort))


	# AUR packages
	#

	$(pacman -Qqm)

EOF
}

