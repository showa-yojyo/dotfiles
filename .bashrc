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

# When a history substitution fails, grant a chance to edit the failed history
# substitution.
shopt -u histreedit

# Do not the results of history substitution immediately
# pass to the shell parser.
shopt -s histverify

# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
# shopt -s cdspell

# Programmable completion enhancements are enabled via
# /etc/profile.d/bash_completion.sh when the package bash_completetion
# is installed.  Any completions you add in ~/.bash_completion are
# sourced last.

DEFAULT_EDITOR='code --wait' # --new-window
export EDITOR=$DEFAULT_EDITOR

# FCEDIT: the default editor for the fc builtin command.
export FCEDIT=$DEFAULT_EDITOR

# Git

export GIT_EDITOR=$DEFAULT_EDITOR

#GIT_PS1_SHOWUPSTREAM="auto"
#GIT_PS1_SHOWCOLORHINTS="yes"
#if [ -f "${HOME}/.git-prompt.sh" ] ; then
#  source "${HOME}/.git-prompt.sh"
#fi

# Enable the official completion script by Git.
# Some examples:
# $ git co<tab><tab>
# commit config
#
# $ git log --s<tab><tab>
# --shortstat               --sparse
# --simplify-by-decoration  --src-prefix=
# --simplify-merges         --stat
# --since=                  --summary
if [ -f "${HOME}/.git-completion.sh" ] ; then
  source "${HOME}/.git-completion.sh"
fi

# grep's default options
#export GREP_OPTIONS='--color=auto'

# History Options
#
# ignoredups: lines matching the previous history entry to not be saved.
export HISTCONTROL="ignoredups"

# Ignore some controlling instructions
# The '&' is a special pattern which suppresses duplicate entries.
export HISTIGNORE=$'[ \t]*:&:?:[fb]g:hibernate*:exit:which.+'

# Whenever displaying the prompt, write the previous line to disk
# export PROMPT_COMMAND="history -a"

# The maximum number of lines contained in the history file
export HISTFILESIZE=200
export HISTSIZE=$HISTFILESIZE
export HISTTIMEFORMAT="%F (%a) %T "

# Locale
#
# LANG: the locale category for any category not specifically selected
# with a variable starting with LC_.
export LANG=ja_JP.UTF-8

# LC_ALL: overrides the value of LANG and any other LC_ variable
# specifying a locale category.
export LC_ALL=

#LC_COLLATE
#LC_CTYPE
#LC_MESSAGES
#LC_NUMERIC

#export PATH

# Prompt
#
#export PROMPT_COMMAND='__git_ps1 "\u@\h:\w" "\\\$ "'

# PS1: the primary prompt string.
export PS1='[$OSTYPE \s \W \!]\\$ '
# export PS1='[\u \W$(__git_ps1 " (%s)") \!]\\$ '

export PS2='> '

# PS3: the prompt for the select command
# export PS3

# PS4: the value is printed before each command bash displays during
# an execution trace.
# export PS4

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
export TMPDIR=/tmp

export TZ=JST-09

# Aliases
#
# Some people use a different file for aliases
if [ -f "${HOME}/.bash_aliases" ]; then
  source "${HOME}/.bash_aliases"
fi

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
if [ -f "${HOME}/.bash_functions" ]; then
  source "${HOME}/.bash_functions"
fi
