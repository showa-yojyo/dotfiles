# .bash_functions

function optimize-dropbox
{
    # Examples:
    # bash$ optimize-dropbox
    # bash$ optimize-dropbox 201910*
    local target_dir="$HOME/Dropbox"
    optipng ${target_dir}/Photos/twitter/2020/${1:-"*"}.png
}

function update-local-copy
{
    local repos_path="$1"
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

function plantuml
{
    if [[ -x "$(command -v cygpath)" ]]; then
        export PLANTUML_PATH="$(cygpath -aw /usr/share/plantuml/plantuml.jar)"
    else
        export PLANTUML_PATH=/usr/share/plantuml/plantuml.jar
    fi

    java -jar "$PLANTUML_PATH" -charset UTF-8 $@
}

function update-all-repos
{
    update-local-copy "$HOME/devel/gitignore" &
}

function backup
{
    local list="$HOME/.remote_repos"
    if [[ ! -f "$list" ]]; then
        echo File $list not found. >&2
        return 1
    fi

    test -x "$(command -v cygpath)"
    local use_cygpath=$?

    for repo in $(sed -e 's/ *#.\+$//g' $list) ; do
        # Expand tildes in $repo
        repo=$(eval echo "$repo")

        if [[ $use_cygpath -eq 0 ]]; then
            repo=$(cygpath -m "$repo")
        fi

        # Push the current branch to the remote repository
        test -d "$repo" && { git -C "$repo" push origin HEAD & }
    done
}

function sync-all
{
    backup &
    update-all-repos &

    if git --version | grep -q windows; then
        git update-git-for-windows -y &
    fi
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

# Convert Markdown to reStructuredText
function convert_md_to_rst
{
    local input="$1"
    local output="${1/.md/.rst}"
    local pandoc_opts="--strip-comments --shift-heading-level-by=-1 --columns=80 --wrap=preserve --to rst"
    pandoc $pandoc_opts -o "$output" "$input"
}

# Convert MP4 video to MP3 audio
function convert_mp3
{
    if ! command -v ffmpeg &> /dev/null; then
        echo 'Error: ffmpeg is not available.' >&2
        return
    fi

    local ffmpeg_global_options="-loglevel error -y"
    local ffmpeg_input_options=""
    local ffmpeg_output_options="-qscale:a 0 -map a"

    for i in "$@";
    do
        local input_url="$i"
        local output_url="${input_url%.mp4}.mp3"
        echo "Processing ${input_url}..." >&2
        ffmpeg $ffmpeg_global_options \
            $ffmpeg_input_options -i "$input_url" \
            $ffmpeg_output_options "$output_url"
        if [[ $? != 0 ]]; then
            echo "Error: $output_url is not generated" >&2
            continue
        fi
        rm -f "$input_url"
    done
}

# For uploading to Twitter
function optimize-video
{
    if [[ -z "$1" ]]; then
        echo Usage: $FUNCNAME input_mp4_path >&2
        return 2
    fi

    local ffmpeg_global_options="-loglevel error -y"
    local ffmpeg_input_options=""
    local ffmpeg_output_options="-vcodec h264 -crf 28"
    local input="$1"
    local output="$(mktemp -u --suffix=.mp4 XXXXXXXXX)"
    ffmpeg $ffmpeg_global_options -i "$input" $ffmpeg_output_options $output
    if [[ $? != 0 ]]; then
        echo "Error: $input conversion failed" >&2
        return 1
    fi

    rm -f "$input"
    mv $output "$input"
}

function optimize-video-for-twitter
{
    if [[ -z "$1" ]]; then
        echo Usage: $FUNCNAME input_mp4_path >&2
        return 2
    fi

    local ffmpeg_global_options="-loglevel error -y"
    local ffmpeg_input_options=""
    local ffmpeg_output_options="""
        -vcodec libx264 -vf scale=480:854 -pix_fmt yuv420p
        -strict experimental -r 30 -t 2:20 -acodec aac
        -vb 1024k -minrate 1024k -maxrate 1024k -bufsize 1024k
        -ar 44100 -ac 2
        """
    local input="$1"
    local output="$(mktemp -u --suffix=.mp4 XXXXXXXXX)"
    ffmpeg $ffmpeg_global_options -i "$input" $ffmpeg_output_options "$output"
    if [[ $? != 0 ]]; then
        echo "Error: $output is not generated" >&2
        return 1
    fi

    rm -f "$input"
    mv "$output" "$input"
}

function backup-bookmark
{
    local SLEIPNIR_PREFIX=sleipnir-bookmarks

    local source="$HOME/$SLEIPNIR_PREFIX"
    if [[ ! -d "$source" ]]; then
        echo $source not found >&2
        return 1
    fi

    local dest="$HOME/Dropbox/locked"
    if [[ ! -d "$dest" ]]; then
        echo $dest not a directory >&2
        return 1
    fi

    local password="$1"
    if [[ -z $1 ]]; then
        read -sp "Password: " password
        tty -s && echo
    fi

    local target=${SLEIPNIR_PREFIX}.zip
    zip -r -e --password "$password" "$target" "$source"
    mv -f -v "$target" "$dest"
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
    if [[ -n "$WSL_DISTRO_NAME" ]]; then
        command which $@
    else
        { alias ; declare -f ; } | command which \
            --tty-only --read-alias --read-functions --show-tilde --show-dot $@
    fi
}

function _g++base
{
    local CPPFLAG="-g -Werror -Wall -Wextra -ansi -pedantic -std=$1"
    local INFILE=$2
    local OUTFILE=${INFILE/.cpp/}
    g++ $CPPFLAG $INFILE -o $OUTFILE
}

function g++11
{
    _g++base c++11 $1
}

function g++14
{
    _g++base c++14 $1
}

function g++17
{
    _g++base c++17 $1
}

function hibernate
{
    if [[ -n "$WSL_DISTRO_NAME" ]]; then
        shutdown.exe /h $@
    else
        command hibernate $@
    fi
}

# Set the title of the terminal window (or current terminal tab)
function settitle
{
     echo -ne '\033]0;'"$1"'\a'
}
