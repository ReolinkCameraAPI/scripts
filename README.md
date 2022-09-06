## Useful scripts

This repository contains different bash scripts and commands for reolink camera.

## download.sh

This script uses `ffmpeg` to download via RTSP the video and audio from your camera saving it in the MP4 format, the name will start with the `date` of the day (ex. `2022-08-26--22-00-00-capture-0000.mp4`) and a file will be recorded and saved every `$TIME` seconds.  
The name of the files starts with a date to make it easier the management of the files, like removing easily all the records of a specific month, day or year.

### Why ffmpeg?

I tried **openRTSP** ❌ but half of the video in the MP4 format is without audio and I don't know why.

example:

```
openRTSP -D 1 -c -B 10000000 -b 10000000 -q -Q -F cam_eight -d 28800 -P 10 -t rtsp://"admin":"mypassword"@192.168.0.176:554
```

source of command and explanation: https://superuser.com/questions/766437/capture-rtsp-stream-from-ip-camera-and-store

I tried **VLC** ❌ but I got some issues saving the files with the audio and managing it.

example command:

```
cvlc rtsp://admin:password@192.168.0.176:554//h264Preview_01_main --sout=file/ts:mystream.mpg
```

FFmpeg was the best, so I chose it. ✅

## clean_record.sh

This script deletes all the records inside a `tmp` directory of the previous month.
