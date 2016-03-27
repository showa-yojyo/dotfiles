# .bashrc
# When Bash is invoked as an interactive shell that is not a login shell,
# it reads and executes commands from this file.

# base-files version 3.9-3

# To pick up the latest recommended .bashrc content,
# look in /etc/defaults/etc/skel/.bashrc

# Modifying /etc/skel/.bashrc directly will prevent
# setup from updating it.

# The copy in your home directory (~/.bashrc) is yours, please
# feel free to customise it to create a shell
# environment to your liking.  If you feel a change
# would be benificial to all, please feel free to send
# a patch to the cygwin mailing list.

# User dependent .bashrc file

# Environment Variables
# #####################

# TMP and TEMP are defined in the Windows environment.  Leaving
# them set to the default Windows temporary directory can have
# unexpected consequences.
unset TMP
unset TEMP

# Alternatively, set them to the Cygwin temporary directory
# or to any other tmp directory of your choice
export TMP=/tmp
export TEMP=/tmp

# Or use TMPDIR instead
# export TMPDIR=/tmp

# Shell Options
# #############

# See man bash for more options...

# Don't wait for job termination notification
# set -o notify

# Don't use ^D to exit
# set -o ignoreeof

# Use case-insensitive filename globbing
# shopt -s nocaseglob

# Make bash append rather than overwrite the history on disk
shopt -s histappend

# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
# shopt -s cdspell

# Completion options
# ##################

# These completion tuning parameters change the default behavior of bash_completion:

# Define to access remotely checked-out files over passwordless ssh for CVS
# COMP_CVS_REMOTE=1

# Define to avoid stripping description in --option=description of './configure --help'
# COMP_CONFIGURE_HINTS=1

# Define to avoid flattening internal contents of tar files
# COMP_TAR_INTERNAL_PATHS=1

# If this shell is interactive, turn on programmable completion enhancements.
# Any completions you add in ~/.bash_completion are sourced last.
# case $- in
#   *i*) [[ -f /etc/bash_completion ]] && . /etc/bash_completion ;;
# esac

# History Options
# ###############

# Don't put duplicate lines in the history.
export HISTCONTROL="ignoredups"

# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.
export HISTIGNORE=$'[ \t]*:&:?:[fb]g:hibernate:exit:which.+'

# Whenever displaying the prompt, write the previous line to disk
# export PROMPT_COMMAND="history -a"

# その他
export HISTFILESIZE=100
export HISTTIMEFORMAT="%Y/%m/%d (%a) %T "

# Aliases
# #######

# Some example alias instructions
# If these are enabled they will be used instead of any instructions
# they may mask.  For example, alias rm='rm -i' will mask the rm
# application.  To override the alias instruction use a \ before, ie
# \rm will call the real rm not the alias.

alias a='alias'

# Interactive operation...
a rm='rm -i'
a cp='cp -i'
a mv='mv -i'

# Default to human readable figures
a df='df -h'
a du='du -h'

# Misc :)
# alias less='less -r'      # raw control characters
# alias whence='type -a'    # where, of a sort
alias grep='grep --color=auto' # show differences in colour

# Some shortcuts for different directory listings
alias ls='ls -hF --show-control-chars --color=tty' # classify files in colour
# alias dir='ls --color=auto --format=vertical'
# alias vdir='ls --color=auto --format=long'
alias ll='ls -l'  # long list
alias la='ls -A'  # all but . and ..
# alias l='ls -CF'

a h='history 16'

a pu='pushd'
a po='popd'

a python26='D:/Python26/python.exe'
a python27='D:/Python27/python.exe'
a python34='D:/Python34/python.exe'
a python35='D:/Python35/python.exe'
a runhhc='/cygdrive/c/Program\ Files/HTML\ Help\ Workshop/hhc.exe'

a chcp='C:/WINDOWS/System32/chcp.com'

# Git

export GIT_EDITOR="'D:/Program Files/xyzzy/xyzzy.exe'"

#GIT_PS1_SHOWUPSTREAM="auto"
#GIT_PS1_SHOWCOLORHINTS="yes"
#if [ -f "${HOME}/.git-prompt.sh" ] ; then
#  source "${HOME}/.git-prompt.sh"
#fi
#if [ -f "${HOME}/.git-completion.sh" ] ; then
#  source "${HOME}/.git-completion.sh"
#fi

# Functions
# #########

# Some example functions
# function settitle() { echo -ne "\e]2;$@\a\e]1;$@\a"; }

function xyzzycli()
{
    local prog='/cygdrive/d/Program Files/xyzzy/xyzzycli.exe'
    for name in "$@"; do
        echo \"$(cygpath -m "$name")\"
    done | xargs "$prog"
}

function update-local-copy()
{
    if [[ "$OSTYPE" == cygwin ]] ; then
        local REPOS_PATH="$(cygpath -aw $1)"
    else
        local REPOS_PATH="$1"
    fi

    git -C "$REPOS_PATH" checkout master
    git -C "$REPOS_PATH" remote -v update 2>&1 | grep -qE "up to date.+origin/master"
    if [[ $? -eq 0 ]]; then
        # Your branch is up-to-date with 'origin/master'.
        git -C "$REPOS_PATH" checkout -
        return
    fi

    git -C "$REPOS_PATH" merge

    if [ $# -gt 1 ]; then
        make -C "$REPOS_PATH" html
    fi

    git -C "$REPOS_PATH" checkout -
}

if [[ "$OSTYPE" == cygwin ]] ; then
    export PLANTUML_PATH="$(cygpath -aw /usr/share/plantuml/plantuml.jar)"
    export GRAPHVIZ_DOT="$(cygpath -aw "$(which dot.exe)")"
else
    export PLANTUML_PATH=/usr/share/plantuml/plantuml.jar
    export GRAPHVIZ_DOT=$(which dot)
fi

function plantuml()
{
    java -jar "$PLANTUML_PATH" -charset UTF-8 $@
}

function sympydoc()
{
    update-local-copy ~/devel/sympy/doc dummy
}

function update-all-repos()
{
    update-local-copy ~/devel/gitignore
    update-local-copy ~/devel/sympy/doc
}

if [[ "$OSTYPE" == cygwin ]] ; then
function gendiary()
{
    python "$(cygpath -aw ~/bin/gendiary.py)" $@
}
fi

#
# set locale
#
export LC_ALL=
export LANG=ja_JP.UTF-8
export TZ=JST-09

# grep's default options
#export GREP_OPTIONS='--color=auto'

#
# set prompt
#
PS1='[\u \W \!]\\$ '
#PS1='[\u \W$(__git_ps1 " (%s)") \!]\\$ '
#PROMPT_COMMAND='__git_ps1 "\u@\h:\w" "\\\$ "'
PS2='> '
