# .bash_functions

# Some example functions
# function settitle() { echo -ne "\e]2;$@\a\e]1;$@\a"; }
# b) function cd_func
# This function defines a 'cd' replacement function capable of keeping,
# displaying and accessing history of visited directories, up to 10 entries.
# To use it, uncomment it, source this file and try 'cd --'.
# acd_func 1.0.5, 10-nov-2004
# Petar Marinov, http:/geocities.com/h2428, this is public domain
# cd_func ()
# {
#   local x2 the_new_dir adir index
#   local -i cnt
#
#   if [[ $1 ==  "--" ]]; then
#     dirs -v
#     return 0
#   fi
#
#   the_new_dir=$1
#   [[ -z $1 ]] && the_new_dir=$HOME
#
#   if [[ ${the_new_dir:0:1} == '-' ]]; then
#     #
#     # Extract dir N from dirs
#     index=${the_new_dir:1}
#     [[ -z $index ]] && index=1
#     adir=$(dirs +$index)
#     [[ -z $adir ]] && return 1
#     the_new_dir=$adir
#   fi
#
#   #
#   # '~' has to be substituted by ${HOME}
#   [[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}"
#
#   #
#   # Now change to the new dir and add to the top of the stack
#   pushd "${the_new_dir}" > /dev/null
#   [[ $? -ne 0 ]] && return 1
#   the_new_dir=$(pwd)
#
#   #
#   # Trim down everything beyond 11th entry
#   popd -n +11 2>/dev/null 1>/dev/null
#
#   #
#   # Remove any other occurence of this dir, skipping the top of the stack
#   for ((cnt=1; cnt <= 10; cnt++)); do
#     x2=$(dirs +${cnt} 2>/dev/null)
#     [[ $? -ne 0 ]] && return 0
#     [[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}"
#     if [[ "${x2}" == "${the_new_dir}" ]]; then
#       popd -n +$cnt 2>/dev/null 1>/dev/null
#       cnt=cnt-1
#     fi
#   done
#
#   return 0
# }
#
# alias cd=cd_func

function optimize-dropbox
{
    # Examples:
    # bash$ optimize-dropbox
    # bash$ optimize-dropbox 201910*
    local target_dir=$(cygpath $USERPROFILE)/Dropbox
    optipng -quiet ${target_dir}/Photos/twitter/2020/${1:-"*"}.png
}

function update-local-copy
{
    if [[ -x "$(command -v cygpath)" ]]; then
        local repos_path="$(cygpath -m $1)"
    else
        local repos_path="$1"
    fi

    if [[ ! -d "$repos_path" ]]; then
        echo "Error: $repos_path not a directory" >&2
        return 1
    fi

    git -C "$repos_path" checkout master
    if [[ $? -ne 0 ]]; then
        echo "Abort $FUNCNAME for $repos_path" >&2
        return 1
    fi

    git -C "$repos_path" remote -v update 2>&1 | grep -qE "up to date.+origin/master"
    if [[ $? -eq 0 ]]; then
        # Your branch is up-to-date with 'origin/master'.
        git -C "$repos_path" checkout -
        return
    fi

    git -C "$repos_path" merge
    git -C "$repos_path" checkout -
}

if [[ -x "$(command -v dot)" ]]; then
    if [[ -x "$(command -v cygpath)" ]]; then
        export PLANTUML_PATH="$(cygpath -aw /usr/share/plantuml/plantuml.jar)"
        export GRAPHVIZ_DOT="$(cygpath -aw "$(command which dot)")"
    else
        export PLANTUML_PATH=/usr/share/plantuml/plantuml.jar
        export GRAPHVIZ_DOT=$(command which dot)
    fi
fi

function plantuml
{
    java -jar "$PLANTUML_PATH" -charset UTF-8 $@
}

function sympydoc
{
    update-local-copy ~/devel/sympy/doc dummy
}

function update-all-repos
{
    update-local-copy ~/devel/gitignore &
    update-local-copy ~/devel/sympy/doc &
}

function backup
{
    local list=~/.remote_repos
    if [[ ! -f $list ]]; then
        echo File $list not found. >&2
        return 1
    fi

    test -x $(command -v cygpath)
    local use_cygpath=$?

    for repo in $(sed -e 's/ *#.\+$//g' $list) ; do
        # Expand tildes in $repo
        repo=$(eval echo "$repo")

        test $use_cygpath && repo=$(cygpath -m "$repo")

        # Push the current branch to the remote repository
        test -d "$repo" && { git -C "$repo" push origin HEAD & }
    done
}

function sync-all
{
    backup &
    update-all-repos &
    git update-git-for-windows -y &
    #conda update --all --yes &
}

function _anniversary_helper
{
    if [[ -z $1 ]]; then
        echo Usage: $FUNCNAME \"date\(YYYY, mm, dd\)\" >&2
        return 1
    fi

    python << EOL -
from datetime import date

print((date.today() - $1).days + 1)
EOL
}

function homeless-anniversary
{
    _anniversary_helper "date(2018, 5, 31)"
}

function sunset-anniversary
{
    _anniversary_helper "date(2020, 4, 27)"
}

function convert_mp3
{
    if [[ ! -x "$(command -v ffmpeg)" ]]; then
        echo 'Error: ffmpeg is not installed.' >&2
        return
    fi

    for i in "$@" ; do
        local source_mp4="$i"
        local dest_mp3="${source_mp4%.mp4}.mp3"
        ffmpeg -loglevel fatal -i "${source_mp4}" "${dest_mp3}"
        if [[ $? != 0 ]]; then
            echo 'Error: '${dest_mp3} 'is not generated' >&2
        else
            rm -f "${source_mp4}"
        fi
    done
}

function backup-bookmark
{
    local source="Sleipnir ブックマーク.html"
    if [[ ! -f "$source" ]]; then
        echo File $source not found >&2
        return 1
    fi

    local dest="$USERPROFILE/Dropbox/locked"
    if [[ ! -d "$dest" ]]; then
        echo $dest not a directory >&2
        return 1
    fi

    local password="$1"
    if [[ -z $1 ]]; then
        read -sp "Password: " password
        tty -s && echo
    fi

    local target=${source%.html}.zip
    zip -e --password "$password" "$target" "$source"
    mv "$target" "$dest" && rm -f "$source"
}

# usage example:
# bash$ extinct *.tmp
# bash$ extinct $(find . -type f -name "*.tmp")
function extinct
{
    shred --iterations=0 --zero --exact "$@"
}

# Taken from Advanced Bash-Scripting Guide Appendix M with a small fix
function extract
{
    local archive="$1"
    case $archive in
    *.tar.bz2|*.tbz2)
        tar xvjf "$archive"
        ;;
    *.tar.gz|*.tgz)
        tar xvzf "$archive"
        ;;
    *.bz2)
        bunzip2 "$archive"
        ;;
    *.rar)
        unrar x "$archive"
        ;;
    *.gz)
        gunzip "$archive"
        ;;
    *.tar)
        tar xvf "$archive"
        ;;
    *.zip)
        unzip "$archive"
        ;;
    *.Z)
        uncompress "$archive"
        ;;
    *.7z)
        7z x "$archive"
        ;;
    *)
        echo $archive cannot be extracted via $FUNCNAME
        return 1
        ;;
    esac
}

function zip-by-pattern
{
    local pattern="${1:-*.extension}"
    find . -type f -name "$pattern" | zip -e -v -@ X
}

# Reference: Bash Guide for Beginners
function pskill
{
    # XXX: for suspended processes, 'S' will come to $1 of awk.
    local pid=$(ps -a -u $USER -W | grep $1 | awk '{ print $1 }')
    echo -n "killing $1 (process $pid)..."
    /bin/kill -9 $pid
    echo "slaughtered."
}

# Reference: info which
function which
{
    { alias ; declare -f ; } | command which \
        --tty-only --read-alias --read-functions --show-tilde --show-dot $@
}
