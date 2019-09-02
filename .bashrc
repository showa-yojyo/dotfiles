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

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

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
#
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

# Programmable completion enhancements are enabled via
# /etc/profile.d/bash_completion.sh when the package bash_completetion
# is installed.  Any completions you add in ~/.bash_completion are
# sourced last.

# History Options
#
# Don't put duplicate lines in the history.
export HISTCONTROL="ignoredups"

# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.
export HISTIGNORE=$'[ \t]*:&:?:[fb]g:hibernate*:exit:which.+'

# Whenever displaying the prompt, write the previous line to disk
# export PROMPT_COMMAND="history -a"

# その他
export HISTFILESIZE=100
export HISTTIMEFORMAT="%Y/%m/%d (%a) %T "

# Aliases
#
# Some people use a different file for aliases
# if [ -f "${HOME}/.bash_aliases" ]; then
#   source "${HOME}/.bash_aliases"
# fi
#
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
# alias egrep='egrep --color=auto' # show differences in colour
# alias fgrep='fgrep --color=auto' # show differences in colour
#
# Some shortcuts for different directory listings
alias ls='ls -hF --show-control-chars --color=tty' # classify files in colour
# alias dir='ls --color=auto --format=vertical'
# alias vdir='ls --color=auto --format=long'
alias ll='ls -l'  # long list
alias la='ls -A'  # all but . and ..
# alias l='ls -CF'

a h='history 16'

a pu='putclip'

a chcp='C:/WINDOWS/System32/chcp.com'

# Git

export GIT_EDITOR='code --wait' # --new-window

#GIT_PS1_SHOWUPSTREAM="auto"
#GIT_PS1_SHOWCOLORHINTS="yes"
#if [ -f "${HOME}/.git-prompt.sh" ] ; then
#  source "${HOME}/.git-prompt.sh"
#fi
#if [ -f "${HOME}/.git-completion.sh" ] ; then
#  source "${HOME}/.git-completion.sh"
#fi

# Umask
#
# /etc/profile sets 022, removing write perms to group + others.
# Set a more restrictive umask: i.e. no exec perms for others:
# umask 027
# Paranoid: neither group nor others have any perms:
# umask 077

# Functions
#
# Some people use a different file for functions
# if [ -f "${HOME}/.bash_functions" ]; then
#   source "${HOME}/.bash_functions"
# fi
#
# Some example functions
# function settitle() { echo -ne "\e]2;$@\a\e]1;$@\a"; }
# b) function cd_func
# This function defines a 'cd' replacement function capable of keeping,
# displaying and accessing history of visited directories, up to 10 entries.
# To use it, uncomment it, source this file and try 'cd --'.
# acd_func 1.0.5, 10-nov-2004
# Petar Marinov, http:/geocities.com/h2428, this is public domain
# cd_func ()
# {
#   local x2 the_new_dir adir index
#   local -i cnt
#
#   if [[ $1 ==  "--" ]]; then
#     dirs -v
#     return 0
#   fi
#
#   the_new_dir=$1
#   [[ -z $1 ]] && the_new_dir=$HOME
#
#   if [[ ${the_new_dir:0:1} == '-' ]]; then
#     #
#     # Extract dir N from dirs
#     index=${the_new_dir:1}
#     [[ -z $index ]] && index=1
#     adir=$(dirs +$index)
#     [[ -z $adir ]] && return 1
#     the_new_dir=$adir
#   fi
#
#   #
#   # '~' has to be substituted by ${HOME}
#   [[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}"
#
#   #
#   # Now change to the new dir and add to the top of the stack
#   pushd "${the_new_dir}" > /dev/null
#   [[ $? -ne 0 ]] && return 1
#   the_new_dir=$(pwd)
#
#   #
#   # Trim down everything beyond 11th entry
#   popd -n +11 2>/dev/null 1>/dev/null
#
#   #
#   # Remove any other occurence of this dir, skipping the top of the stack
#   for ((cnt=1; cnt <= 10; cnt++)); do
#     x2=$(dirs +${cnt} 2>/dev/null)
#     [[ $? -ne 0 ]] && return 0
#     [[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}"
#     if [[ "${x2}" == "${the_new_dir}" ]]; then
#       popd -n +$cnt 2>/dev/null 1>/dev/null
#       cnt=cnt-1
#     fi
#   done
#
#   return 0
# }
#
# alias cd=cd_func

function xyzzycli()
{
    local prog='C:/Program Files/xyzzy/xyzzycli.exe'
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

    if [[ ! -d "$REPOS_PATH" ]] ; then
        return
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

if [[ -x "$(command -v dot)" ]] ; then
    if [[ "$OSTYPE" == cygwin ]] ; then
        export PLANTUML_PATH="$(cygpath -aw /usr/share/plantuml/plantuml.jar)"
        export GRAPHVIZ_DOT="$(cygpath -aw "$(which dot)")"
    else
        export PLANTUML_PATH=/usr/share/plantuml/plantuml.jar
        export GRAPHVIZ_DOT=$(which dot)
    fi
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
    update-local-copy ~/devel/gitignore &
    update-local-copy ~/devel/sympy/doc &
}

if [[ "$OSTYPE" == cygwin ]] ; then
function gendiary()
{
    python "$(cygpath -aw ~/devel/bin/gendiary.py)" $@
}

function download_mp4()
{
    python "$(cygpath -aw ~/devel/bin/dlmp4.py)" $@
}

function bundle()
{
    ruby "$(cygpath -aw $(which bundle))" $@
}

fi

function push-all-repos()
{
    local repos=(\
        ~/devel/bin \
        ~/devel/dotfiles \
        ~/devel/sketchbook \
        ~/devel/all-note/notebook \
        ~/devel/all-note/notebook/gh-pages \
        ~/devel/all-note/jupyter-notebooks \
        ~/devel/wandering)

    for repo in "${repos[@]}" ; do
        if [[ "$OSTYPE" == cygwin ]] ; then
            repo=$(cygpath -aw "$repo")
        fi
        # Push the current branch to the same name on the remote
        git -C "$repo" push origin HEAD &
    done
}

function sync-all()
{
    push-all-repos &
    update-all-repos $
    #conda update --all --yes &
}

function homeless-anniversary()
{
    LC_ALL=C date -d "2018-05-31 $1 days" +"%Y-%m-%d (%a)"
}

function convert_mp3()
{
    if [[ ! -x "$(command -v ffmpeg)" ]]; then
        echo 'Error: ffmpeg is not installed.' >&2
        return
    fi

    for i in "$@" ; do
        local source_mp4="$i"
        local dest_mp3="${source_mp4%.mp4}.mp3"
        ffmpeg -loglevel fatal -i "${source_mp4}" "${dest_mp3}"
        if [[ $? != 0 ]] ; then
            echo 'Error: '${dest_mp3} 'is not generated' >&2
        fi
    done
}

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
PS1='[$OSTYPE \s \W \!]\\$ '
#PS1='[\u \W$(__git_ps1 " (%s)") \!]\\$ '
#PROMPT_COMMAND='__git_ps1 "\u@\h:\w" "\\\$ "'
PS2='> '

