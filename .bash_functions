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

function xyzzycli()
{
    local prog='C:/Program Files/xyzzy/xyzzycli.exe'
    for name in "$@"; do
        echo \"$(cygpath -m "$name")\"
    done | xargs "$prog"
}

function update-local-copy()
{
    if [[ -x "$(command -v cygpath)" ]] ; then
        local REPOS_PATH="$(cygpath -aw $1)"
    else
        local REPOS_PATH="$1"
    fi

    if [[ ! -d "$REPOS_PATH" ]] ; then
        return
    fi

    git -C "$REPOS_PATH" checkout master
    git -C "$REPOS_PATH" remote -v update 2>&1 | grep -qE "up to date.+origin/master"
    if [[ $? -eq 0 ]]; then
        # Your branch is up-to-date with 'origin/master'.
        git -C "$REPOS_PATH" checkout -
        return
    fi

    git -C "$REPOS_PATH" merge

    if [ $# -gt 1 ]; then
        make -C "$REPOS_PATH" html
    fi

    git -C "$REPOS_PATH" checkout -
}

if [[ -x "$(command -v dot)" ]] ; then
    if [[ -x "$(command -v cygpath)" ]] ; then
        export PLANTUML_PATH="$(cygpath -aw /usr/share/plantuml/plantuml.jar)"
        export GRAPHVIZ_DOT="$(cygpath -aw "$(which dot)")"
    else
        export PLANTUML_PATH=/usr/share/plantuml/plantuml.jar
        export GRAPHVIZ_DOT=$(which dot)
    fi
fi

function plantuml()
{
    java -jar "$PLANTUML_PATH" -charset UTF-8 $@
}

function sympydoc()
{
    update-local-copy ~/devel/sympy/doc dummy
}

function update-all-repos()
{
    update-local-copy ~/devel/gitignore &
    update-local-copy ~/devel/sympy/doc &
}

function push-all-repos()
{
    local repos=(\
        ~/devel/bin \
        ~/devel/dotfiles \
        ~/devel/sketchbook \
        ~/devel/all-note/notebook \
        ~/devel/all-note/notebook/gh-pages \
        ~/devel/all-note/jupyter-notebooks \
        ~/devel/wandering)

    for repo in "${repos[@]}" ; do
        if [[ -x "$(command -v cygpath)" ]] ; then
            repo=$(cygpath -aw "$repo")
        fi
        # Push the current branch to the same name on the remote
        git -C "$repo" push origin HEAD &
    done
}

function sync-all()
{
    push-all-repos &
    update-all-repos $
    #conda update --all --yes &
}

function homeless-anniversary()
{
    LC_ALL=C date -d "2018-05-31 $1 days" +"%Y-%m-%d (%a)"
}

function convert_mp3()
{
    if [[ ! -x "$(command -v ffmpeg)" ]]; then
        echo 'Error: ffmpeg is not installed.' >&2
        return
    fi

    for i in "$@" ; do
        local source_mp4="$i"
        local dest_mp3="${source_mp4%.mp4}.mp3"
        ffmpeg -loglevel fatal -i "${source_mp4}" "${dest_mp3}"
        if [[ $? != 0 ]] ; then
            echo 'Error: '${dest_mp3} 'is not generated' >&2
        fi
    done
}

function opti()
{
    local dir=${USERPROFILE}/Dropbox/Photos/twitter/2019
    pushd $dir
    optipng 2019*.png
    popd
}