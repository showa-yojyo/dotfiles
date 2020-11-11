# ~/.bash_profile: executed by bash(1) for login shells.

# The latest version as installed by the Cygwin Setup program can
# always be found at /etc/defaults/etc/skel/.bash_profile

# Modifying /etc/skel/.bash_profile directly will prevent
# setup from updating it.

# The copy in your home directory (~/.bash_profile) is yours, please
# feel free to customise it to create a shell
# environment to your liking.  If you feel a change
# would be benifitial to all, please feel free to send
# a patch to the cygwin mailing list.

# User dependent .bash_profile file

# source the users bashrc if it exists
test -f "${HOME}/.bashrc" && . "${HOME}/.bashrc"

_is_cygpath_available=$(test -x $(command -v cygpath))

PATH=/bin:/usr/local/bin:/usr/bin

# Code by Bash Guide for Beginners
function _munge_path
{
  local a_path="$1"

  test ! -d "$a_path" && echo Warning: $a_path is not directory. >&2

  if ! echo $PATH | command egrep -q "(^|:)$a_path($|:)" ; then
    if [[ "$2" == "before" ]]; then
      PATH=$a_path:$PATH
    else
      PATH+=":$a_path"
    fi
  fi
}

if [[ _is_cygpath_available ]]; then
  _cygdrive_prefix=
  _munge_path "${_cygdrive_prefix}/c/texlive/2015/bin/win32"
  _munge_path "$(cygpath "${PROGRAMFILES}/Graphviz/bin")"
  _munge_path "$(cygpath "${PROGRAMFILES}/Pandoc")"
  _munge_path "${_cygdrive_prefix}/c/Ruby26-x64/bin"
  _munge_path "$(cygpath "${PROGRAMFILES}/Git/cmd")"
  _munge_path "$(cygpath "${PROGRAMFILES}/Microsoft VS Code/bin")"
  _munge_path "$(cygpath "${PROGRAMFILES}/nodejs")"
  _munge_path "$(cygpath ${APPDATA}/npm)"
  _munge_path "${_cygdrive_prefix}/c/WINDOWS/System32"
  unset _cygdrive_prefix

  # Java stuff
  if [[ -n "$JAVA_HOME" ]]; then
    JAVA_HOME=$(cygpath -pu "$JAVA_HOME")
    _munge_path "$JAVA_HOME/bin"
  fi
fi

# Set PATH so it includes user's private bin if it exists
_home_bin="${HOME}/devel/bin"
test -d "${_home_bin}" && _munge_path $_home_bin before
test -d "${_home_bin}/ffmpeg" && _munge_path "${_home_bin}/ffmpeg" before
unset _home_bin

# Set MANPATH so it includes users' private man if it exists
test -d "${HOME}/man" && _munge_path ${HOME}/man before

# Set INFOPATH so it includes users' private info if it exists
test -d "${HOME}/info" && _munge_path ${HOME}/info before

# Python stuffs
if [[ _is_cygpath_available ]]; then
  _miniconda_path="$(cygpath ${ALLUSERSPROFILE})/Miniconda3"
  _munge_path "${_miniconda_path}/Library/bin" before
  _munge_path "${_miniconda_path}/Scripts" before
  _munge_path "${_miniconda_path}" before
  unset _miniconda_path
fi

unset -f _munge_path
