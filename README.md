# YouTube2Audiobook

This repository contains a Bash script that [downloads the audio section of a given YouTube link and converts it into an audiobook](https://www.how-hard-can-it.be/tag/youtube2audiobook/?utm_source=GitHub&utm_medium=social&utm_campaign=README). The audiobook can then be used like any other Mp3 file.

> See also [Continuously Listen to YouTube Audiobooks on Your Phone](https://www.how-hard-can-it.be/continuously-listen-to-youtube-audiobooks-on-your-phone/?utm_source=GitHub&utm_medium=social&utm_campaign=README) on [How Hard Can It Be?!](https://www.how-hard-can-it.be/?utm_source=GitHub&utm_medium=social&utm_campaign=README) for an end-to-end solution for downloading any YouTube video as an audiobook and listening to it on your phone. While keeping track of playback positions. Even during app restarts and system reboots.

There is also a Docker container, which is automatically built from this repository, readily available for use on [Docker Hub](https://hub.docker.com/repository/docker/dumrauf/yt2ab). It provides the same functionality by packaging the Bash script and all necessary dependencies.


## You Have

Before you can use the [_Bash script_](yt2ab.sh) in this repository out of the box, you need

 - [youtube-dl](https://youtube-dl.org/) which is a Python application that ships with a CLI and allows to download audio and video from YouTube
 - [FFmpeg](https://ffmpeg.org/) which is "a complete, cross-platform solution to record, convert and stream audio and video" (from [https://ffmpeg.org/](https://ffmpeg.org/)) and also ships with a CLI
 - [`jq`](https://stedolan.github.io/jq/) which is a standalone, "lightweight and flexible command-line JSON processor" (from [https://stedolan.github.io/jq/](https://stedolan.github.io/jq/))

The corresponding [_Docker container_ on Docker Hub](https://hub.docker.com/r/dumrauf/yt2ab) only requires a recent Docker engine.

Most likely, you also have a YouTube link that you want to convert to an audiobook.


## You Want

After running the Bash script or the Docker container in this repository you get an audiobook version of the input YouTube link stored on your device.


## Execution: Bash Script

The stand-alone Bash script `yt2ab.sh` is located in the root folder.

### Getting Started

At minimum, the Bash script `yt2ab.sh` requires a YouTube URL to be passed in via the `-u` parameter.

YouTube link `<YouTube-URL>` can be converted into an audiobook via
```
./yt2ab.sh -u <YouTube-URL>
```
Depending on the size of the audio section in the given YouTube link, your connection speed, and the audio conversion speed, it may take several minutes before the Bash script successfully completes.

### Advanced Use

Further options are available via additional CLI parameters.

The full list of currently available parameters is
```
Usage  : yt2ab.sh -u <youtube-url>                -s [audio-speed] -q [audio-quality] -v(erbose)
Example: yt2ab.sh -u https://youtu.be/WRbalzuvms4
Example: yt2ab.sh -u https://youtu.be/WRbalzuvms4 -s 1.5
Example: yt2ab.sh -u https://youtu.be/WRbalzuvms4 -s 1.5           -q 3
Example: yt2ab.sh -u https://youtu.be/WRbalzuvms4 -s 1.5           -q 3               -v
Note: for audio quality see also column 'ffmpeg option' on <https://trac.ffmpeg.org/wiki/Encode/MP3>; defaults to 4
```

The `audio_speed` parameter allows to increase or decrease the speed of the resulting audiobook; defaults to 1 and hence leaves the audio speed unchanged. This setting is particularly helpful when trying to normalise the `original speed` of the given YouTube link in the resulting audiobook. In that case, set the `audio_speed` so that `original speed x audio_speed = 1`, i.e., if the `original speed` of the YouTube link is `1.5`, choosing a value of `2/3` for `audio_speed` will normalise the speed of the resulting audiobook as `1.5 x 2/3 = 1`. However, the final audiobook may sound awkward as audio speed adjustments can be a lossy process.

The `audio_quality` parameter allows to set the quality of the resulting audiobook; defaults to `4`. Here, the values are derived from column "ffmpeg option" in table "LAME Bitrate Overview" on [https://trac.ffmpeg.org/wiki/Encode/MP3](https://trac.ffmpeg.org/wiki/Encode/MP3).

The `v(erbose)` parameter increases the verbosity of the script and can be used for debugging purposes.


## Execution: Docker Container

The Docker container for version `1.3.0` (see the [release page](https://github.com/dumrauf/youtube_to_audiobook/releases/) for the latest one) can be pulled from Docker Hub via

```
docker pull dumrauf/yt2ab:v1.3.0
```

The image includes the `yt2ab.sh` Bash script and all required dependencies. As such, it uses the identical input parameters. The only new parameter is specific to Docker.

> By default, the Docker container stores all downloaded audiobooks in `/data`.

Download and convert a `<YouTube-URL>` into an audiobook in the _current directory_ via
```
docker run -v "$(pwd)":/data dumrauf/yt2ab:v1.3.0 -u <YouTube-URL>
```
For more details on how to build your own Docker container and advanced uses, see the [YouTube2Audiobook is on Docker Hub](https://www.how-hard-can-it.be/yt2ab-docker/?utm_source=GitHub&utm_medium=social&utm_campaign=README) announcement.

## FAQs

Below is a list of frequently asked questions.

### I Know How to Make This Better!

Excellent. Feel free to fork this repository, make the changes in your fork, and open a pull request so we can make things better for everyone. Thanks!


## Disclaimer

By using this software, you agree to always respect the copyright laws in your country and all other jurisdictions that may apply. Moreover, you also agree to always respect the Terms of Service of the provider you are downloading audio or video content from. The authors of this software are in no way responsible for any potential damages, liabilities, or losses.
