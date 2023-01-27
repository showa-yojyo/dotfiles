# .bash_functions

function _anniversary_helper
{
    local basedate=${1:?Usage: $FUNCNAME \'date(YYYY, mm, dd)\'}

    python << EOL -
from datetime import date

print((date.today() - $basedate).days + 1)
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
    local input="${1:?Usage: $FUNCNAME MARKDOWN_PATH}"
    local output="${input%.md}.rst"
    local pandoc_opts="""
        --strip-comments
        --shift-heading-level-by=-1
        --columns=80
        --wrap=preserve
        --to rst
        """
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
        local input="$i"
        local output="${input%.*}.mp3"
        echo "Processing ${input}..." >&2
        ffmpeg $ffmpeg_global_options \
            $ffmpeg_input_options -i "$input" \
            $ffmpeg_output_options "$output"
        if [[ $? != 0 ]]; then
            echo "Error: $output is not generated" >&2
            continue
        fi
        touch -r "$input" "$output"
        rm -f "$input"
    done
}

# The core function for image-resize-xxxx family
function _image-resize
{
    local magick_options="-resize $1 -define preserve-timestamp=true"
    shift
    # Use ImageMagick 7
    magick mogrify $magick_options "$@"
}

# Resize image to fit within 854x480 dots
function image-resize-small
{
    _image-resize 854x480 "$@"
}

# Resize image to fit within 1366x768 dots
function image-resize-medium
{
    _image-resize 1366x768 "$@"
}

# For uploading to Twitter
function video-optimize
{
    local input="${1:?Usage: $FUNCNAME INPUT_VIDEO_PATH}"

    local ffmpeg_global_options="-loglevel error -y"
    local ffmpeg_input_options=""
    local ffmpeg_output_options="-vcodec h264 -crf 28"

    local output="$(mktemp --tmpdir -u --suffix=.mp4 XXXXXXXXX)"
    ffmpeg $ffmpeg_global_options -i "$input" $ffmpeg_output_options $output
    if [[ $? != 0 ]]; then
        echo "Error: $input conversion failed" >&2
        rm -f "$output"
        return 1
    fi

    touch -r "$input" "$output"
    rm -f "$input"
    mv $output "$input"
}

function video-optimize-for-twitter
{
    local input="${1:?Usage: $FUNCNAME INPUT_VIDEO_PATH}"

    local ffmpeg_global_options="-loglevel error -y"
    local ffmpeg_input_options=""
    local ffmpeg_output_options="
        -vcodec libx264 -vf scale=480:854 -pix_fmt yuv420p
        -strict experimental -r 30 -t 2:20 -acodec aac
        -vb 1024k -minrate 1024k -maxrate 1024k -bufsize 1024k
        -ar 44100 -ac 2
        "

    local output="$(mktemp --tmpdir -u --suffix=.mp4 XXXXXXXXX)"
    ffmpeg $ffmpeg_global_options -i "$input" $ffmpeg_output_options "$output"
    if [[ $? != 0 ]]; then
        echo "Error: $output is not generated" >&2
        rm -f "$output"
        return 1
    fi

    touch -r "$input" "$output"
    rm -f "$input"
    mv "$output" "$input"
}

function video-duration
{
    local input="${1:?Usage: $FUNCNAME INPUT_VIDEO_PATH}"

    local ffprobe_options="
        -v error -show_entries format=duration
        -of default=noprint_wrappers=1:nokey=1
        "

    ffprobe $ffprobe_options "$input"
}

# Concatenate video files with exactly the same codec and codec parameters.
function video-concat
{
    if [[ $# -le 2 ]] ; then
        echo Usage: $FUNCNAME INPUT_VIDEO_PATH... OUTPUT_VIDEO_PATH >&2
        return 2
    fi

    local ffmpeg_global_options="-loglevel error -y"
    local ffmpeg_input_options="-f concat -safe 0"
    local ffmpeg_output_options="-c copy"
    local output="${@: -1}"

    ffmpeg $ffmpeg_global_options $ffmpeg_input_options -i \
        <(for f in "${@: 1:$#-1}"; do echo "file '$PWD/$f'" ; done) \
        $ffmpeg_output_options "$output"
}

# Fade out the last second of the video.
function video-fadeout
{
    local input="${1:?Usage: $FUNCNAME INPUT_VIDEO_PATH}"

    # duration of fade out
    local fade_duration=${2:-1}

    local ffmpeg_global_options="-loglevel error -y"

    local video_duration=$(video-duration ${input})
    local output="${input%.*}-faded.${input#*.}"

    # from where to fade out
    local st=$(echo "$video_duration - $fade_duration" | bc)

    local ffmpeg_input_options=""
    local ffmpeg_output_options="""
        -vf "fade=t=out:st=$st:d=$fade_duration"
        -af "afade=t=out:st=$st:d=$fade_duration"
        """

    ffmpeg $ffmpeg_global_options -i "$input" $ffmpeg_output_options "$output"
    touch -r "$input" "$output"
}

# https://superuser.com/questions/268985/remove-audio-from-video-file-with-ffmpeg
function video-mute
{
    local input="${1:?Usage: $FUNCNAME INPUT_VIDEO_PATH}"
    local output="${input%.*}-mute.${input#*.}"
    local ffmpeg_global_options="-loglevel error -y"
    local ffmpeg_output_options="-c copy -an"

    ffmpeg $ffmpeg_global_options -i "$input" $ffmpeg_output_options "$output"
    touch -r "$input" "$output"
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

# Set the title of the terminal window (or current terminal tab)
function settitle
{
     echo -ne '\033]0;'"$1"'\a'
}
