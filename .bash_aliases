# .bash_aliases

alias a='alias'

# Interactive operation
a cp='cp -i'
a ln='ln -i'
a mv='mv -i'
a rm='rm -i'

# Default to human readable figures
a df='df -h'
a du='du -h'

# Misc :)
# a less='less -r'      # raw control characters
# a whence='type -a'    # where, of a sort
a grep='grep --color=auto' # show differences in colour
a egrep='egrep --color=auto' # show differences in colour
a fgrep='fgrep --color=auto' # show differences in colour

# Some shortcuts for different directory listings
a ls='ls -hF --show-control-chars --color=tty --time-style=long-iso'
a ll='ls -l' # long list
a la='ls -A' # all but . and ..

a j='jobs -l'

a h='history 16'

a path='echo -e ${PATH//:/\\n}'

a mount='mount | column -t'

# Calendar
a today='LC_ALL=C date +"%F (%a)"'
a now='LC_ALL=C date +"%F (%a) %T"'

# wget
a wget='wget --continue --wait=1 --random-wait --limit-rate=200k --quiet --show-progress'

# Cygwin exclusive
if [[ "$(uname -o)" == "Cygwin" ]]; then
    # ShellExecute
    a s='cygstart'

    a cygwin-setup='s $(cygpath -m ~/Downloads/setup-x86_64.exe)'

    # Clipboard
    a ge='getclip'
    a pu='putclip'

    # Scripts
    a dlmp4='python $(cygpath -aw ~/devel/bin/dlmp4.py)'
    a gendiary='python $(cygpath -aw ~/devel/bin/gendiary.py)'
    a portrait='python $(cygpath -aw ~/devel/bin/portrait.py)'
    a wselect='python $(cygpath -aw ~/devel/bin/wselect.py)'
    a resizeimg='python $(cygpath -aw ~/devel/bin/resizeimg.py)'

    # Assume that Ruby is built for x64-mingw32
    a bundle=bundle.bat
    a gem=gem.bat
    a jekyll=jekyll.bat

    a wifirobot='python $(cygpath -aw ~/devel/bin/wifirobot.py)'
    a wifikoto="wifirobot koto"
    a wifishinagawa='wifirobot shinagawa'
    a wifiota='wifirobot ota'
    a mjnet='python $(cygpath -aw ~/devel/bin/mjnet.py)'
else
    a dlmp4='dlmp4.py'
    a gendiary='gendiary.py'
    a wselect='wselect.py'
    a wifikoto='wifirobot.py koto'
    a wifishinagawa='wifirobot.py shinagawa'
    a wifiota='wifirobot.py ota'
    a mjnet='mjnet.py'
fi

unalias a
