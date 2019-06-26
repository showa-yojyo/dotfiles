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

if [[ "$OSTYPE" == "cygwin" && -n "$JAVA_HOME" ]] ; then
  # See also /etc/fstab.
  CYGDRIVE_PREFIX=

  TEXLIVE_PATH=${CYGDRIVE_PREFIX}/d/texlive/2015/bin/win32
  GRAPHVIZ_PATH=${CYGDRIVE_PREFIX}/d/Program\ Files/Graphviz/bin
  PANDOC_PATH=${CYGDRIVE_PREFIX}/d/Program\ Files/Pandoc
  PYTHON_PATH=${CYGDRIVE_PREFIX}/d/Miniconda3:${CYGDRIVE_PREFIX}/d/Miniconda3/Scripts:${CYGDRIVE_PREFIX}/d/Miniconda3/Library/bin
  RUBY_PATH=${CYGDRIVE_PREFIX}/d/Ruby26-x64/bin
  GIT_PATH=${CYGDRIVE_PREFIX}/d/Program\ Files/Git/cmd
  VSCODE_PATH=$(cygpath ${LOCALAPPDATA}/Programs/Microsoft\ VS\ Code/bin)
  SYSTEM_PATH=${CYGDRIVE_PREFIX}/c/WINDOWS/System32
  JAVA_HOME=$(cygpath -pu "$JAVA_HOME")
fi

PATH=/bin:/usr/local/bin:/usr/bin:$TEXLIVE_PATH:$GRAPHVIZ_PATH:$PANDOC_PATH:$PYTHON_PATH:$GIT_PATH:$RUBY_PATH:$VSCODE_PATH:$SYSTEM_PATH:$JAVA_HOME/bin
# Set PATH so it includes user's private bin if it exists
if [ -d "${HOME}/bin" ] ; then
  PATH=${HOME}/bin:${PATH}
fi

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
