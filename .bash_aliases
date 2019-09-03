# .bash_aliases

alias a='alias'

# Interactive operation...
a rm='rm -i'
a cp='cp -i'
a mv='mv -i'

# Default to human readable figures
a df='df -h'
a du='du -h'

# Misc :)
# alias less='less -r'      # raw control characters
# alias whence='type -a'    # where, of a sort
alias grep='grep --color=auto' # show differences in colour
# alias egrep='egrep --color=auto' # show differences in colour
# alias fgrep='fgrep --color=auto' # show differences in colour
#
# Some shortcuts for different directory listings
alias ls='ls -hF --show-control-chars --color=tty' # classify files in colour
# alias dir='ls --color=auto --format=vertical'
# alias vdir='ls --color=auto --format=long'
alias ll='ls -l'  # long list
alias la='ls -A'  # all but . and ..
# alias l='ls -CF'

a h='history 16'
a pu='putclip'
