# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Export LD_LIBRARY_PATH to include locally installed libraries
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

# Export PATH to include other locally installed programs, including nix
export PATH=$PATH:/usr/sbin:/home/$USER/.platformio/penv/bin:/home/$USER/bin:/home/$USER/.nix-profile/bin:/home/$USER/.local/bin:/nix/var/nix/profiles/default/bin

# If nix home manager session vars file exists, source it
if [ -f $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh ]; then
  source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
fi

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=20000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi # set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -l'
alias la='ls -a'
alias l='ls'

# some git aliases
alias gstat='git status'
alias gcm='git add -u && git commit -m'
alias glog='git log'
alias gpush='git push origin $(git branch --show-current)'
alias gbranch='git branch'
alias gpull='git pull'
alias gdiff='git diff'
alias gstash='git stash'

# tmux alias
alias tm='tmux -2 new-session -A -s main'
alias tmses='tmux -2 new-session -A -s '
alias tmsp="tmux if-shell -F '#{==:#{prefix},C-Space}' 'set-option -g prefix M-Space; display-message \"Prefix toggled to M-Space\"' 'set-option -g prefix C-Space; display-message \"Prefix toggled to C-Space\"'"
alias tmsp2="tmux if-shell -F '#{==:#{prefix},C-Space}' 'set-option -g prefix C-M-Space; display-message \"Prefix toggled to C-M-Space\"' 'set-option -g prefix C-Space; display-message \"Prefix toggled to C-Space\"'"

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Useful utilities, implemented as bash functions

# Simple wrapper around X11 clipboard utility xsel
# If stdin has any data, it gets copied to the clipboard selection
# Otherwise, the clipboard selection is output to stdout
clipboard() {
    IFS= read -r -d '' -t 0 -N 1;

    # stdin had data, copy to clipboard
    if [[ $? -eq 0 ]]; then
        xsel -i -b

        # stdin did not have data, dump clipboard contents to stdout
    else
        xsel -o -b
    fi
}


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# powerline config.
# Configure at /usr/share/powerline/config_files
# Set POWERLINE_BASH_BINDING_PATH to override, e.g. ~/.nix-profile/share/bash/powerline.sh for nix
_POWERLINE_BASH_BINDING_PATH="${POWERLINE_BASH_BINDING_PATH:-/usr/share/powerline/bindings/bash/powerline.sh}"
if [ -f ${_POWERLINE_BASH_BINDING_PATH} ]; then
  powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  source ${_POWERLINE_BASH_BINDING_PATH}
fi

# i3 tinkering: unset SESSION_MANAGER
# If i3 is the current WM, unset SESSION_MANAGER env var
# to avoid 1-second vim startup delay in case where GNOME ran before i3
if [ ! -z "$SESSION_MANAGER" ]; then
  unset SESSION_MANAGER
fi

# pywal colorscheme activation
# only activate if user is "skeet" (me)
#if [ $USER == "skeet" ] && [ -z "$SSH_CLIENT" ]; then
#  (cat ~/.cache/wal/sequences &)
#fi

# Exporting these environment variables sets default text editor to vim
export EDITOR="/usr/bin/vim"
export VISUAL="/usr/bin/vim"

# Set bash options (see man bash for more info)
# This one sets background jobs to notify immediately upon exit, instead of 
# waiting for the next terminal prompt
set -b

# Export other bash vars
#export DOCKER_HOST=unix:///run/user/1000/docker.sock

export LANG=en_US.UTF-8

# This executes tmux if in an interactive shell not already running tmux
if [[ -n "$INSIDE_EMACS" ]]; then
  tmses ide
elif [[ "$TERM_PROGRAM" != "tmux" ]]; then
  tm
fi

