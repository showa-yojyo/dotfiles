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

# Code by Bash Guide for Beginners
function _munge_path
{
  local a_path="$1"

  if [[ ! -d "$a_path" ]]; then
      echo Warning: $a_path is not directory. >&2
      return
  fi

  if ! echo $PATH | command egrep -q "(^|:)$a_path($|:)" ; then
    if [[ "$2" == "before" ]]; then
      PATH=$a_path:$PATH
    else
      PATH+=":$a_path"
    fi
  fi
}

# source the users bashrc if it exists
test -f "${HOME}/.bashrc" && . "${HOME}/.bashrc"

PATH=/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

# Set PATH so it includes user's private bin if it exists
_home_bin="${HOME}/bin"
test -d "${_home_bin}" && _munge_path ${_home_bin} before
unset _home_bin

# Set MANPATH so it includes users' private man if it exists
if [ -d "${HOME}/man" ]; then
  MANPATH="${HOME}/man:${MANPATH}"
fi

# Set INFOPATH so it includes users' private info if it exists
if [ -d "${HOME}/info" ]; then
  INFOPATH="${HOME}/info:${INFOPATH}"
fi

case "$OSTYPE" in
  cygwin | msys)
    _prefix=
    #_munge_path "${_prefix}/c/texlive/2015/bin/win32"
    #_munge_path "$(cygpath "${PROGRAMFILES}/Graphviz/bin")"
    #_munge_path "$(cygpath "${PROGRAMFILES}/Pandoc")"
    _munge_path "${_prefix}/c/Ruby26-x64/bin"
    _munge_path "$(cygpath "${PROGRAMFILES}/Git/cmd")"
    _munge_path "$(cygpath "${PROGRAMFILES}/nodejs")"
    _munge_path "$(cygpath ${APPDATA}/npm)"
    _munge_path "$(cygpath "${PROGRAMFILES}/Microsoft VS Code/bin")"
    _munge_path "${_prefix}/c/WINDOWS/System32"
    unset _prefix

    # Java stuff
    if [[ -n "$JAVA_HOME" ]]; then
      JAVA_HOME=$(cygpath -pu "$JAVA_HOME")
      _munge_path "$JAVA_HOME/bin"
    fi

    # Python stuffs
    _miniconda_path="$(cygpath ${ALLUSERSPROFILE})/Miniconda3"
    _munge_path "${_miniconda_path}/Library/bin" before
    _munge_path "${_miniconda_path}/Scripts" before
    _munge_path "${_miniconda_path}" before
    unset _miniconda_path
    ;;
  linux*)
    if [[ -d "$HOME/miniconda3/bin" ]]; then
        eval "$($HOME/miniconda3/bin/conda shell.bash hook)"
        conda activate python-3.9
    fi

    if [[ -n "$WSL_DISTRO_NAME" ]]; then
      _prefix=/mnt/c
      _munge_path "$_prefix/Program Files/Microsoft VS Code/bin"
      _munge_path "$_prefix/WINDOWS/System32"
    fi
    unset _prefix
    ;;
  *)
    ;;
esac

# Install Ruby Gems to ~/gems
if [[ -d "$HOME/gems" ]]; then
  export GEM_HOME="$HOME/gems"
  _munge_path "$HOME/gems/bin" before
fi

unset -f _munge_path

# Homebrew
test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

# NVM stuffs
export NVM_DIR="~/.nvm"

# Load nvm
_nvm_sh=/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh
test -s $_nvm_sh && . $_nvm_sh
unset _nvm_sh

# Load nvm bash_completion
_nvm_completion=/home/linuxbrew/.linuxbrew/opt/nvm/etc/bash_completion.d/nvm
test -s $_nvm_completion && . $_nvm_completion
unset _nvm_completion

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
umask 022
