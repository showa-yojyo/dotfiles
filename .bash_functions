# .bash_functions

function _anniversary_helper
{
    local -r basedate=${1:?Usage: $FUNCNAME \'date(YYYY, mm, dd)\'}

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
    local -r input="${1:?Usage: $FUNCNAME MARKDOWN_PATH}"
    local -r output="${input%.md}.rst"
    local -r pandoc_opts="
        --strip-comments
        --shift-heading-level-by=-1
        --columns=80
        --wrap=preserve
        --to rst
        "
    pandoc $pandoc_opts -o "$output" "$input"
}

# Convert MP4 video to MP3 audio
function convert_mp3
{
    if ! command -v ffmpeg &> /dev/null; then
        echo 'Error: ffmpeg is not available.' >&2
        return
    fi

    local -r ffmpeg_global_options="-loglevel error -y"
    local -r ffmpeg_input_options=""
    local -r ffmpeg_output_options="-qscale:a 0 -map a"

    for i in "$@";
    do
        local -r input="$i"
        local -r output="${input%.*}.mp3"
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
    local -r magick_options="-resize $1 -define preserve-timestamp=true"
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
    local -r input="${1:?Usage: $FUNCNAME INPUT_VIDEO_PATH}"

    local -r ffmpeg_global_options="-loglevel error -y"
    local -r ffmpeg_input_options=""
    local -r ffmpeg_output_options="
        -c:v libx264 -pix_fmt yuv420p -strict -2
        -c:a aac -vb 1024k -minrate 1024k -maxrate 1024k -bufsize 1024k
        -ar 44100 -ac 2 -r 30"

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

function video-duration
{
    local -r input="${1:?Usage: $FUNCNAME INPUT_VIDEO_PATH}"

    local -r ffprobe_options="
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

    local -r ffmpeg_global_options="-loglevel error -y"
    local -r ffmpeg_input_options="-f concat -safe 0"
    local -r ffmpeg_output_options="-c copy"
    local -r output="${@: -1}"

    ffmpeg $ffmpeg_global_options $ffmpeg_input_options -i \
        <(for f in "${@: 1:$#-1}"; do echo "file '$PWD/$f'" ; done) \
        $ffmpeg_output_options "$output"
}

# TODO: wrap drawtext
#function video-text
#{
#    ffmpeg -i "$input" -vf "drawtext=text='xxxxx':fontfile=/path/to/xxxxx:
#        box=0:boxcolor=white@0.5:
#        x=20:y=20:
#        shadowx=1:shadowy=1:shadowcolor=xxxxx@0.9:
#        fontcolor=xxxxx:fontsize=48:line_spacing=8" -c:a copy "$output"
#}

# XXX
# How to fade from one video to another in ffmpeg, both audio and video - Super User
# https://superuser.com/questions/1739162/how-to-fade-from-one-video-to-another-in-ffmpeg-both-audio-and-video
function video-xfade-naive
{
    local -r usage="Usage: $FUNCNAME [-d DURATION] INPUT_VIDEO_PATH0 INPUT_VIDEO_PATH1"

    local duration=1
    local OPTIND
    local opt

    while getopts ":d" opt; do
      case $opt in
         d)
           duration="${OPTARG}"
           ;;
         *)
           echo $usage
           return 1
           ;;
      esac
    done
    shift $((OPTIND-1))

    local -r input0="${1:?${usage}}"
    local -r input1="${2:?${usage}}"
    local -r output=xfade.mp4

    local -r ffmpeg_global_options="-v error -y -hide_banner"
    local -r trim=$(video-duration ${input0})
    local -r offset=$(echo $trim - $duration | bc)

    ffmpeg $ffmpeg_global_options \
        -i "${input0}" -i "${input1}" -filter_complex "
        [0:v]setpts=PTS,settb=AVTB,fps=30[0v];
        [1:v]setpts=PTS,settb=AVTB,fps=30[1v];
        [0v][1v]xfade=transition=fade:duration=${duration}:offset=${offset}[video];
        [0:a]asetpts=PTS,asettb=AVTB,atrim=0:${trim}[a0];
        [a0][1:a]acrossfade=d=${duration}[audio]" \
        -map "[video]" -map "[audio]" "$output"
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

    local -r ffmpeg_input_options=""
    local -r ffmpeg_output_options="
        -vf "fade=t=out:st=$st:d=$fade_duration"
        -af "afade=t=out:st=$st:d=$fade_duration"
        "

    ffmpeg $ffmpeg_global_options -i "$input" $ffmpeg_output_options "$output"
    touch -r "$input" "$output"
}

# https://superuser.com/questions/268985/remove-audio-from-video-file-with-ffmpeg
function video-mute
{
    local -r input="${1:?Usage: $FUNCNAME INPUT_VIDEO_PATH}"
    local -r output="${input%.*}-mute.${input#*.}"
    local -r ffmpeg_global_options="-loglevel error -y"
    local -r ffmpeg_output_options="-c copy -an"

    ffmpeg $ffmpeg_global_options -i "$input" $ffmpeg_output_options "$output"
    touch -r "$input" "$output"
}

# Preview a video with ffplay
function video-preview
{
    if [ -t 0 ]; then
        local -r input="${1:?Usage: $FUNCNAME INPUT_VIDEO_PATH}"
    else
        local -r input="-"
    fi

    local -r ffplay_global_options="-v error -hide_banner"
    local -r ffplay_input_options="-autoexit -x 240 -y 320"
    ffplay $ffplay_global_options $ffplay_input_options "$input"
}

# A variant of video-optimize
function twitter-merge-video-audio
{
    local -r usage="Usage: $FUNCNAME VIDEO_PATH AUDIO_PATH OUTPUT_PATH"
    local -r input_video="${1:?$usage}"
    local -r input_audio="${2:?$usage}"
    local -r output="${3:?$usage}"

    local -r ffmpeg_global_options="-loglevel error -y"
    local -r ffmpeg_output_options="
        -c:v libx264 -pix_fmt yuv420p -strict -2
        -c:a aac -vb 1024k -minrate 1024k -maxrate 1024k -bufsize 1024k
        -ar 44100 -ac 2 -r 30"

    ffmpeg $ffmpeg_global_options \
        -i "$input_video" -i "$input_audio" \
        -map 0:v -map 1:a $ffmpeg_output_options "$output"
}

# Download an audio file (m4a) from YouTube
function youtube-download-audio
{
    local -r video_url="${1:?Usage: $FUNCNAME VIDEO_URL}"
    local -r options="-q --no-playlist -x --audio-format m4a"
    youtube-dl $options -o "%(id)s-%(title)s.%(ext)s" "$video_url"
}

# Download a video file (mp4) from YouTube
function youtube-download-video
{
    local -r video_url="${1:?Usage: $FUNCNAME VIDEO_URL}"
    local -r options="
        -q --no-playlist
        -f bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best
        "
    youtube-dl $options -o "%(id)s-%(title)s.%(ext)s" "$video_url"
}

# Show summary of all items in a play list
function youtube-playlist-summary
{
    local -r playlist_url="${1:?Usage: $FUNCNAME PLAYLIST_URL}"
    local -r options="--flat-playlist --yes-playlist -J"

    youtube-dl $options "$playlist_url" \
        | jq -r '.entries[] | ["https://www.youtube.com/watch?v=" + .id, .title, .duration] | @tsv'
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
    local -r CPPFLAG="-g -Werror -Wall -Wextra -ansi -pedantic -std=$1"
    local -r INFILE="${2:?Usage: $FUNCNAME ${1} CPPFILE}"
    local -r OUTFILE=${INFILE%.cpp}
    g++ $CPPFLAG $INFILE -latomic -o $OUTFILE
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

function g++20
{
    _g++base c++20 $1
}

# Set the title of the terminal window (or current terminal tab)
function settitle
{
     echo -ne '\033]0;'"$1"'\a'
}
