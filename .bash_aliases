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
a ls='ls -hF --show-control-chars --color=tty' # classify files in colour
# a dir='ls --color=auto --format=vertical'
# a vdir='ls --color=auto --format=long'
a ll='ls -l'  # long list
a la='ls -A'  # all but . and ..
# a l='ls -CF'

a j='jobs -l'
a jekyll='bundle exec jekyll serve'

a h='history 16'

a path='echo -e ${PATH//:/\\n}'

a mount='mount | column -t'

# Calendar
alias today='LC_ALL=C date +"%F (%a)"'
alias now='LC_ALL=C date +"%F (%a) %T"'

# wget
a wget='wget --continue --wait=1 --random-wait --limit-rate=200k'

# Cygwin exclusive
if [[ "$(uname -o)" == "Cygwin" ]] ; then
    # Clipboard
    a ge='getclip'
    a pu='putclip'

    # Scripts
    a dlmp4='python $(cygpath -aw ~/devel/bin/dlmp4.py)'
    a gendiary='python $(cygpath -aw ~/devel/bin/gendiary.py)'
    a wselect='python $(cygpath -aw ~/devel/bin/wselect.py)'
    a bundle='ruby $(cygpath -aw $(which bundle))'
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
