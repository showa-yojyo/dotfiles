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

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    a ls='ls -hF --show-control-chars --color=tty --time-style=long-iso --group-directories-first'
    #a dir='dir --color=auto'
    #a vdir='vdir --color=auto'

    # show differences in colour
    a grep='grep --color=auto'
    a egrep='egrep --color=auto'
    a fgrep='fgrep --color=auto'
fi

# Some more ls aliases
a ll='ls -l' # long list
a la='ls -A' # all but . and ..
a l='ls -CF'

a j='jobs -l'

a h='history 16'

a path='echo -e ${PATH//:/\\n}'

a mount='mount | column -t'

# Calendar
a today='LC_ALL=C date +"%F (%a)"'
a now='LC_ALL=C date +"%F (%a) %T"'

# wget
a wget='wget --continue --random-wait --limit-rate=200k --quiet --show-progress --no-clobber'

# Cygwin exclusive

case "$OSTYPE" in
    cygwin | msys)
        # Cygwin, Bash for Windows, MSYS.
        a s=cygstart
        a cygwin-setup='s $(cygpath -m ~/Downloads/setup-x86_64.exe)'

        # Clipboard
        a ge='getclip'
        a pu='putclip'

        # Scripts
        a dlmp4='python $(cygpath -aw ~/devel/bin/dlmp4.py)'
        a mjnet='python $(cygpath -aw ~/devel/bin/mjnet.py)'
        a portrait='python $(cygpath -aw ~/devel/bin/portrait.py)'

        # Assume that Ruby is built for x64-mingw32
        a bundle=bundle.bat
        a gem=gem.bat
        a jekyll=jekyll.bat
        ;;
    *)
        if [[ -n "$WSL_DISTRO_NAME" ]]; then
            a s='wslview'
        fi
        a dlmp4='dlmp4.py'
        a mjnet='mjnet.py'
        a portrait='portrait.py'
        ;;
esac

a doctest='python -m doctest'

unalias a
