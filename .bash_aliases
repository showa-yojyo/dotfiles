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
# alias less='less -r'      # raw control characters
# alias whence='type -a'    # where, of a sort
alias grep='grep --color=auto' # show differences in colour
alias egrep='egrep --color=auto' # show differences in colour
alias fgrep='fgrep --color=auto' # show differences in colour

# Some shortcuts for different directory listings
alias ls='ls -hF --show-control-chars --color=tty' # classify files in colour
# alias dir='ls --color=auto --format=vertical'
# alias vdir='ls --color=auto --format=long'
alias ll='ls -l'  # long list
alias la='ls -A'  # all but . and ..
# alias l='ls -CF'

a j='jobs -l'
a h='history 16'

a path='echo -e ${PATH//:/\\n}'

a mount='mount | column -t'

# Calendar
alias today='LC_ALL=C date +"%F (%a)"'
alias now='LC_ALL=C date +"%F (%a) %T"'

# Cygwin exclusive
if [[ "$(uname -o)" == "Cygwin" ]] ; then
    # Clipboard
    a ge='getclip'
    a pu='putclip'

    # Scripts
    a dlmp4='python $(cygpath -aw ~/devel/bin/dlmp4.py)'
    a gendiary='python $(cygpath -aw ~/devel/bin/gendiary.py)'
    a bundle='ruby $(cygpath -aw $(which bundle))'
fi

unalias a
