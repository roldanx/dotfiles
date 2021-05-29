# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

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
    #PS1='\[\033[01;32m\]\u\[\033[00m\]@\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00;33m\]$(parse_git_branch)\[\033[00m\]\$ '
    PS1='\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\w\[\033[00;33m\]$(parse_git_branch)\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# if this is an xterm set the title to user@host:dir
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
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# git help
# if the current dir is a git repo shows the branch name in prompt
# if there are changes to commit, shows * next to the branch name
function parse_git_dirty {
# if the return value is NOT zero it means there are changes to commit, echo * for the prompt
  if ! git status 2> /dev/null |tail -n1 |grep "nada para hacer commit" &> /dev/null
  then
          echo '*'
  fi
}
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
}

## Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

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

# SYSTEM TOOLS
alias ..='cd ..'
alias svim='sudo vim'
alias shtdwn='sudo shutdown -h +100'
alias eip='curl portquiz.net'
alias eport='ss -tu state listening'
alias rsynca='rsync -azvP'
alias update='sudo snap refresh'

# GIT
alias gch='git checkout'
alias gcm='git commit'
alias glg='git log --graph --decorate --oneline'
alias glga='git log --graph --decorate --oneline --all'

# PYTHON
alias pip='pip3'
alias python='python3'

# DOCKER
alias pm='sudo podman'
alias pmc='sudo podman-compose'
alias prune='sudo podman system prune'
alias prunev='sudo podman system prune && sudo podman volume prune'

# KUBERNETES
alias kb='sudo /usr/local/bin/kubectl' # Configured to use kind
alias kind='sudo /usr/local/bin/kind'
alias mkb='minikube kubectl --'

# MAVEN
# wrapper function for Maven's mvn command.
mvn-color()
{
  # Filter mvn output using sed
  mvn $@ | sed -e "s/\(\[INFO\]\ \-.*\)/${TEXT_BLUE}${BOLD}\1${RESET_FORMATTING}/g" \
               -e "s/\(\[INFO\]\ \[.*\)/${TEXT_WHITE}${BOLD}\1${RESET_FORMATTING}/g" \
               -e "s/\(\[INFO\]\ Including.*\)/${TEXT_WHITE}\1${RESET_FORMATTING}/g" \
               -e "s/\(\[INFO\]\ BUILD SUCCESS\)/${BOLD}${TEXT_GREEN}\1${RESET_FORMATTING}/g" \
               -e "s/\(\[INFO\]\ BUILD FAILURE\)/${BOLD}${TEXT_RED}\1${RESET_FORMATTING}/g" \
               -e "s/\(\[WARNING\].*\)/${BOLD}${TEXT_YELLOW}\1${RESET_FORMATTING}/g" \
               -e "s/\(\[ERROR\].*\)/${BOLD}${TEXT_RED}\1${RESET_FORMATTING}/g" \
               -e "s/Tests run: \([^,]*\), Failures: \([^,]*\), Errors: \([^,]*\), Skipped: \([^,]*\)/${BOLD}${TEXT_GREEN}Tests run: \1${RESET_FORMATTING}, Failures: ${BOLD}${TEXT_RED}\2${RESET_FORMATTING}, Errors: ${BOLD}${TEXT_RED}\3${RESET_FORMATTING}, Skipped: ${BOLD}${TEXT_YELLOW}\4${RESET_FORMATTING}/g"
  # Make sure formatting is reset
  echo -ne ${RESET_FORMATTING}
}

# override the mvn command with the colorized one
alias mvn="mvn-color"
# maven command
alias mvni='mvn clean install -T 2 -DskipTests'

# IBM variables
export PATH="$PATH:$HOME/.local/bin"

# IBM alias
alias dx='dx-cli'
#source /usr/local/ibmcloud/autocomplete/bash_autocomplete
alias ibm='ibmcloud'
alias ibmk='ibmcloud ks'
