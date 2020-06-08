# ~/.bash_logout: executed by bash(1) when login shell exits.

if (( SHLVL == 1 )); then
    # WSL, i.e. Ubuntu?
    if [ -x /usr/bin/clear_console ]; then
        /usr/bin/clear_console -q
    else
        clear
    fi

    # rm -rf /tmp/*
else
    tput reset
fi
