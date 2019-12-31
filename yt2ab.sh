#!/bin/bash

# Uncomment for verbose Bash logging
set +x

# Stop on all errors
set -e


###############################################################################
#                             Default Arguments                               #
###############################################################################

# Static definitions; purpose of each variable as indicated by its name
# Set the default audio speed to 1 (leaving the audio unchanged)
DEFAULT_AUDIO_SPEED=1
# Set the default audio quality to 4; see <https://trac.ffmpeg.org/wiki/Encode/MP3> for details
DEFAULT_AUDIO_QUALITY=4




###############################################################################
#                              Helper Functions                               #
###############################################################################

# Helper function for checking multiple dependencies
function check_dependencies {
	dependencies=$1
	for dependency in ${dependencies};
	do
		if ! hash ${dependency} 2>/dev/null;
		then
		        echo -e "This script requires '${dependency}' but it cannot be detected. Aborting..."
		        exit 1
		fi
	done
}


# Helper function for displaying help text (pun intended)
function display_help {
  script_name=`basename "$0"`
  echo "Usage  : $script_name -u <youtube-url>                -s [audio-speed] -q [audio-quality] -v(erbose)"
  echo "Example: $script_name -u https://youtu.be/WRbalzuvms4"
  echo "Example: $script_name -u https://youtu.be/WRbalzuvms4 -s 1.5"
  echo "Example: $script_name -u https://youtu.be/WRbalzuvms4 -s 1.5           -q 3"
  echo "Example: $script_name -u https://youtu.be/WRbalzuvms4 -s 1.5           -q 3               -v"
  echo "Note: for audio quality see also column 'ffmpeg option' on <https://trac.ffmpeg.org/wiki/Encode/MP3>; defaults to 4"
}


# Helper function for echoing debug information
function echo_debug {
  if $is_verbose;
  then 
    echo "$1"
  fi
}


# Helper function for downloading and converting YouTube videos from a given URL
function download_and_convert_youtube_video () {
	_url=$1
	# Dynamic file name definitions
	_youtube_filename=$(youtube-dl --get-filename "${_url}")
	_cover="${_youtube_filename}".jpg
	_youtube_audio="${_youtube_filename}"-youtube-audio.mp3
	_audiobook_filename="${_youtube_filename}.mp3"

	# Ensure proper cleanup upon function return
	trap 'rm -f "${_cover}"; rm -f "${_youtube_audio}"' RETURN

	# Download thumbnail and audio from given YouTube ${_url}
	youtube-dl "${_url}" --write-thumbnail --skip-download -o "${_cover}"
	youtube-dl "${_url}" -x --audio-format mp3 --audio-quality 0 -o "${_youtube_audio}"

	# Convert audio to Mp3, including thumbnail for easier recognition
	ffmpeg -i "${_youtube_audio}" -i "${_cover}" -map_metadata 0 -map 0 -map 1 -codec:a libmp3lame -qscale:a ${audio_quality} -filter:a "atempo=${audio_speed}" "${_audiobook_filename}"

	# Remove original extension from ${_audiobook_filename}
	_base=${_audiobook_filename%.*.mp3}
	mv "${_audiobook_filename}" "${_base}.mp3" 
}




###############################################################################
#                             Dependency Checks                               #
###############################################################################

# Check dependencies of Bash script
DEPENDENCIES='youtube-dl ffmpeg jq'
check_dependencies "${DEPENDENCIES}"




###############################################################################
#                          Input Argument Handling                            #
###############################################################################

# Input argument parsing
while getopts ":hu:s:q:v" option
do
  case "${option}" in
    u) url=${OPTARG};;
    s) audio_speed=${OPTARG};;
    q) audio_quality=$OPTARG;;
    v) is_verbose=true;;
    h) display_help; exit -1;;
    :) echo "Missing option argument for -$OPTARG" >&2; exit 1;;
  esac
done

# Mandatory input arguments check
if [[ -z "${url}" ]]; then
    display_help
    exit -1
fi

# Handle optional verbosity parameter
is_verbose=${is_verbose:-false}

# Handle optional audio speed parameter
audio_speed=${audio_speed:-$DEFAULT_AUDIO_SPEED}
echo_debug "Audio speed set to ${audio_speed}"

# Handle optional audio speed parameter
audio_quality=${audio_quality:-$DEFAULT_AUDIO_QUALITY}
echo_debug "Audio quality set to ${audio_quality}"




###############################################################################
#                           YouTube Audio Download                            #
###############################################################################

# Retrieve the flat JSON representation of the "${url}" playlist (using the fact
# that 'youtube-dl' produces the identical JSON format for both single videos 
# as well as playlists) and store each result in an array in order to avoid
# interferences with later outputs by other programmes
declare -a video_jsons
while IFS= read -r video_json
do
	video_jsons+=("${video_json}")
done < <(youtube-dl -j --flat-playlist "${url}")

# Download and convert each video in "${video_jsons}"; inspired by <https://superuser.com/a/1359132>
for video_json in "${video_jsons[@]}"
do
	title=$(jq -r '.title' <<< "${video_json}")
	id=$(jq -r '.id' <<< "${video_json}")
	video_url="https://youtu.be/${id}"
	echo "Processing ${video_url}: '${title}'..."
	download_and_convert_youtube_video "${video_url}"
	echo "...done processing '${title}'!"
done
