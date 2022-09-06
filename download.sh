USERNAME="admin"
PASSWORD="mypassword"
TIME=60 # seconds
IP="192.168.1.197"
PORT=554

ffmpeg -i rtsp://$USERNAME:$PASSWORD@$IP:$PORT/h264Preview_01_main \
       -c copy \
       -map 0 \
       -reset_timestamps 1 \
       -f segment \
       -segment_time $TIME \
       -strftime 1 \
       -segment_format mp4 \
       "%Y-%m-%d--%H-%M-%S--capture-%04d.mp4"

