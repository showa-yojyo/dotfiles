# ~/.bashrc: executed by bash(1) for interactive shells.

# The latest version as installed by the Cygwin Setup program can
# always be found at /etc/defaults/etc/skel/.bashrc

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

# Shell Options
#
# See man bash for more options...

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

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
shopt -s cdspell dirspell

# multi-line commands are saved to the history with embedded newlines rather
# than using semicolon separators where possible.
shopt -s lithist

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Honor XDG_*_HOME
# See XDG Base Directory Specification
# <https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html>
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/.cache

# Comment out so that WSLg works fine
#if [[ -f /etc/resolv.conf ]]; then
#    export DISPLAY=$(grep -oP "(?<=nameserver ).+" /etc/resolv.conf):0.0
#    export XDG_RUNTIME_DIR=/tmp/xdg-runtime
#    export RUNLEVEL=3
#fi

case "$OSTYPE" in
    cygwin | msys)
        export BROWSER=cygstart
        ;;
    linux-gnu)
        if [[ -n "$WSL_DISTRO_NAME" ]]; then
            export BROWSER=wslview
        fi
        ;;
esac

export EDITOR='code --wait' # --new-window

# FCEDIT: the default editor for the fc builtin command.
export FCEDIT=$EDITOR

# Git

export GIT_EDITOR=$EDITOR

# See .git-prompt.sh
# Show unstaged (*) and staged (+) changes.
GIT_PS1_SHOWDIRTYSTATE="yes"

# Show if currently something is stashed.
GIT_PS1_SHOWSTASHSTATE="yes"

# Show if there're untracked files.
#GIT_PS1_SHOWUNTRACKEDFILES=

# Show the difference between HEAD and its upstream.
GIT_PS1_SHOWUPSTREAM="verbose"

# Specify the separator between the branch name and the state symbol.
#GIT_PS1_STATESEPARATOR=" "

# Show more information about the identity of commits checked out as a
# detached HEAD.
#GIT_PS1_DESCRIBE_STYLE="default"

# Enable a colored hint about the current dirty state.
GIT_PS1_SHOWCOLORHINTS="yes"

# Make __git_ps1 to do nothing in the case when the current directory is set
# up to be ignored by git.
#GIT_PS1_HIDE_IF_PWD_IGNORED=

test -f "$XDG_CONFIG_HOME/.git-prompt.sh" && . "$XDG_CONFIG_HOME/.git-prompt.sh"

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
test -f "$XDG_CONFIG_HOME/.git-completion.sh" && . "$XDG_CONFIG_HOME/.git-completion.sh"

# grep's default options
#export GREP_OPTIONS='--color=auto'

# History Options
#
# Don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
export HISTCONTROL="ignoreboth"

# Ignore some controlling instructions
# The '&' is a special pattern which suppresses duplicate entries.
export HISTIGNORE=$'[ \t]*:&:?:[fb]g:hibernate*:exit:which.+'

# Whenever displaying the prompt, write the previous line to disk
# export PROMPT_COMMAND="history -a"

# ~/.bash_history
export HISTFILE="$XDG_STATE_HOME/bash_history"

# The maximum number of lines contained in the history file
export HISTFILESIZE=2200
export HISTSIZE=1000
export HISTTIMEFORMAT="%F %T "

# ~/.inputrc
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"

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

# less
export LESSHISTFILE=-

# Docker (only config.json?)
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"

export AZURE_CONFIG_DIR="$XDG_DATA_HOME/azure"

# Rust
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

# Ruby Gems bundler
export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME/bundle"
export BUNDLE_USER_PLUGIN="$XDG_DATA_HOME/bundle"
export BUNDLE_USER_CACHE="$XDG_CACHE_HOME/bundle"

# XDG_CONFIG_HOME/gemrc

# XDG_CONFIG_HOME/irb
export IRBRC="$XDG_CONFIG_HOME/irb/irbrc"

export GEM_HOME="$XDG_DATA_HOME/gem"
export GEM_SPEC_CACHE="$XDG_CACHE_HOME/gem"

# XDG_DATA_HOME/rdoc

# MySQL
export MYSQL_HISTFILE="$XDG_STATE_HOME/mysql_history"

# Node.js
export NODE_REPL_HISTORY="$XDG_STATE_HOME/node_repl_history"

# npm
export NPM_CONFIG_USERCONFIG="$MY_CONFIG_HOME/npm/npmrc"

#export PATH

# Prompt
# See .git-prompt.sh
#export PROMPT_COMMAND="__git_ps1; $PROMPT_COMMAND"

# PS1: the primary prompt string.
#export PS1='[$OSTYPE \s \W \!]\\$ '
#export PS1='\u@\h \w> '
export PS2='> '

# PS3: the prompt for the select command
# export PS3

# PS4: the value is printed before each command bash displays during
# an execution trace, e.g. `set -x`, `bash -x script.sh`, etc.
# export PS4

# Pylint
export PYLINTHOME="$XDG_CACHE_HOME/pylint"
export PYLINTRC="$XDG_CONFIG_HOME/pylint/pylintrc"

# Python
export PYTHONPYCACHEPREFIX="$XDG_CACHE_HOME/python"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc.py"
export PYTHONUSERBASE="$XDG_DATA_HOME/python"

# SQLite
export SQLITE_HISTORY="$XDG_STATE_HOME/sqlite_history"

# Vim
export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'

# wget
export WGETRC="$XDG_CONFIG_HOME/wgetrc"

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

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
test -f "$XDG_CONFIG_HOME/.bash_aliases" && . "$XDG_CONFIG_HOME/.bash_aliases"

# Functions
#
# Some people use a different file for functions
test -f "$XDG_CONFIG_HOME/.bash_functions" && . "$XDG_CONFIG_HOME/.bash_functions"

# Lazy version of $(wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash).
export NVM_DIR="$HOME/.nvm"

# This lazy loads nvm
nvm() {
    unset -f nvm
    [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh" --no-use # This loads nvm
    nvm $@
}

# This loads nvm bash_completion
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# Rust
[ -s "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
