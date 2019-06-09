# YouTube2Audiobook

This repository contains a Bash script that downloads the audio section of a given YouTube link and converts it into an audiobook. The audiobook can then be used like any other Mp3 file.

See ["Continuously Listen to YouTube Audiobooks on Your Phone"](https://www.how-hard-can-it.be/continuously-listen-to-youtube-audiobooks-on-your-phone/) for an end-to-end solution that also includes tranferring an audiobook to a phone and leveraging an app that keeps track of playback positions during app restarts and even system reboots.


## You Have

Before you can use the Bash script in this repository out of the box, you need

 - [youtube-dl](https://youtube-dl.org/) which is a Python application that ships with a CLI and allows to download audio and video from YouTube
 - [FFmpeg](https://ffmpeg.org/) which is "a complete, cross-platform solution to record, convert and stream audio and video" (from [https://ffmpeg.org/](https://ffmpeg.org/)) and also ships with a CLI

Most likely, you also have a YouTube link that you want to convert to an audiobook.


## You Want

After running the Bash script in this repository you get an audiobook version of the input YouTube link stored on your device.


## Execution

The stand-alone Bash script `yt2ab.sh` is located in the root folder.

### Getting Started

At minimum, the Bash script `yt2ab.sh` requires a YouTube URL to be passed in via the `-u` parameter.

The YouTube link [https://youtu.be/WRbalzuvms4](https://youtu.be/WRbalzuvms4) can be converted into an audiobook via
```
./yt2ab.sh -u https://youtu.be/WRbalzuvms4
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

The `audio_speed` parameter allows to increase or decrease the speed of the resulting audiobook; defaults to 1 and hence leaves the audio speed unchanged. This setting is particulary helpful when trying to normalise the `original speed` of the given YouTube link in the resulting audiobook. In that case, set the `audio_speed` so that `original speed x audio_speed = 1`, i.e., if the `original speed` of the YouTube link is `1.5`, choosing a value of `2/3` for `audio_speed` will normalise the speed of the resulting audiobook as `1.5 x 2/3 = 1`. However, the final audiobook may sound awkward as audio speed adjustments can be a lossy process.

The `audio_quality` parameter allows to set the quality of the resulting audiobook; defaults to `4`. Here, the values are derived from column "ffmpeg option" in table "LAME Bitrate Overview" on [https://trac.ffmpeg.org/wiki/Encode/MP3](https://trac.ffmpeg.org/wiki/Encode/MP3).

The `v(erbose)` parameter increases the verbosity of the script and can be used for debugging purposes.


## FAQs

Below is a list of frequently asked questions.

### I Know How to Make This Better!

Excellent. Feel free to fork this repository, make the changes in your fork, and open a pull request so we can make things better for everyone. Thanks!


## Disclaimer

By using this software, you agree to always respect the copyright laws in your country and all other jurisdictions that may apply. Moreover, you also agree to always respect the Terms of Service of the provider you are downloading audio or video content from. The authors of this software are in no way responsible for any potential damages, liabilities, or losses.
