# PYTHONSTARTUP
# References:
# 1. XDG Base Directory - ArchWiki
#    <https://wiki.archlinux.org/title/XDG_Base_Directory>
# 2. python - Change location of `~/.python_history` - Unix & Linux Stack Exchange
#    <https://unix.stackexchange.com/questions/630642/change-location-of-python-history>
import os
import atexit
import readline

python_histfile_path = None
if XDG_STATE_HOME := os.environ.get('XDG_STATE_HOME'):
    # $XDG_STATE_HOME/python_history
    python_histfile_path = os.path.join(XDG_STATE_HOME, 'python_history')
else:
    # ~/.local/state/python_history
    python_histfile_path = os.path.join(os.path.expanduser('~/.local/state'), 'python_history')

if not python_histfile_path:
    python_histfile_path = os.path.join(os.path.expanduser('~'), '.python_history')

try:
    readline.read_history_file(python_histfile_path)
    # default history len is -1 (infinite), which may grow unruly
    readline.set_history_length(1000)
except FileNotFoundError:
    pass

atexit.register(readline.write_history_file, python_histfile_path)
