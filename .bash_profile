# .bash_profile
# When Bash is invoked as an interactive login shell, it reads this file.

# base-files version 3.9-3

# To pick up the latest recommended .bash_profile content,
# look in /etc/defaults/etc/skel/.bash_profile

# Modifying /etc/skel/.bash_profile directly will prevent
# setup from updating it.

# The copy in your home directory (~/.bash_profile) is yours, please
# feel free to customise it to create a shell
# environment to your liking.  If you feel a change
# would be benifitial to all, please feel free to send
# a patch to the cygwin mailing list.

# ~/.bash_profile: executed by bash for login shells.

# source the system wide bashrc if it exists
if [ -e /etc/bash.bashrc ] ; then
  source /etc/bash.bashrc
fi

# source the users bashrc if it exists
if [ -e "${HOME}/.bashrc" ] ; then
  source "${HOME}/.bashrc"
fi

CYGDRIVE_PREFIX=
if [[ "$OSTYPE" == "cygwin" ]] ; then
  # See also /etc/fstab.
  CYGDRIVE_PREFIX=
fi

PATH=/bin:/usr/local/bin:/usr/bin

function append_path()
{
  local one_path="$1"
  if [[ -d "$one_path" ]] ; then
    PATH=${PATH}:"$one_path"
  else
    echo Warning: $one_path is not directory. >&2
  fi
}

# Python stuffs
MINICONDA_PATH="${CYGDRIVE_PREFIX}/c/ProgramData/Miniconda3"
append_path "${MINICONDA_PATH}"
append_path "${MINICONDA_PATH}/Scripts"
append_path "${MINICONDA_PATH}/Library/bin"
unset MINICONDA_PATH

append_path "${CYGDRIVE_PREFIX}/c/texlive/2015/bin/win32"
append_path "$(cygpath ${CYGDRIVE_PREFIX}/c/Program\ Files/Graphviz/bin)"
append_path "$(cygpath ${CYGDRIVE_PREFIX}/c/Program\ Files/Pandoc)"
append_path "${CYGDRIVE_PREFIX}/c/Ruby26-x64/bin"
append_path "$(cygpath ${CYGDRIVE_PREFIX}/c/Program\ Files/Git/cmd)"
append_path "$(cygpath ${CYGDRIVE_PREFIX}/c/Program\ Files/Microsoft\ VS\ Code)"
append_path "${CYGDRIVE_PREFIX}/c/WINDOWS/System32"

# Java stuff
if [[ -n "$JAVA_HOME" ]] ; then
  JAVA_HOME=$(cygpath -pu "$JAVA_HOME")
  append_path "$JAVA_HOME/bin"
fi

unset -f append_path

# Set PATH so it includes user's private bin if it exists
HOME_BIN="${HOME}/devel/bin"
if [ -d "${HOME_BIN}" ] ; then
  PATH=${HOME_BIN}:${PATH}

  if [[ -d "${HOME_BIN}/ffmpeg" ]] ; then
    PATH=${HOME_BIN}/ffmpeg:${PATH}
  fi
fi
unset HOME_BIN

# Set MANPATH so it includes users' private man if it exists
# if [ -d "${HOME}/man" ]; then
#   MANPATH=${HOME}/man:${MANPATH}
# fi

# Set INFOPATH so it includes users' private info if it exists
# if [ -d "${HOME}/info" ]; then
#   INFOPATH=${HOME}/info:${INFOPATH}
# fi

# Miscellaneous commands.

stty stop ^S intr ^C erase ^?
set -o nounset
