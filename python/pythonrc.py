# PYTHONSTARTUP
# References:
# 1. XDG Base Directory - ArchWiki
#    <https://wiki.archlinux.org/title/XDG_Base_Directory>
# 2. python - Change location of `~/.python_history` - Unix & Linux Stack Exchange
#    <https://unix.stackexchange.com/questions/630642/change-location-of-python-history>
import os
import atexit
import readline

PYTHON_HISTFILE_PATH = None
if XDG_STATE_HOME := os.environ.get('XDG_STATE_HOME'):
    # $XDG_STATE_HOME/python_history
    PYTHON_HISTFILE_PATH = os.path.join(XDG_STATE_HOME, 'python_history')
else:
    # ~/.local/state/python_history
    PYTHON_HISTFILE_PATH = os.path.join(os.path.expanduser('~/.local/state'), 'python_history')

if not PYTHON_HISTFILE_PATH:
    PYTHON_HISTFILE_PATH = os.path.join(os.path.expanduser('~'), '.python_history')

try:
    readline.read_history_file(PYTHON_HISTFILE_PATH)
except OSError:
    pass

def write_history():
    try:
        readline.write_history_file(PYTHON_HISTFILE_PATH)
    except OSError:
        pass

atexit.register(write_history)
