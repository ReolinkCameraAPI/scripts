# default parameters value
TIME=60
PORT=554
OUTPUT_PATH="."

while getopts u:p:i:t:n:o: flag
do
    case "${flag}" in
        u) USERNAME=${OPTARG};;
        p) PASSWORD=${OPTARG};;
        i) IP=${OPTARG};;
        t) TIME=${OPTARG};;
        n) PORT=${OPTARG};;
        o) OUTPUT_PATH=${OPTARG};;
    esac
done

ffmpeg -i rtsp://$USERNAME:$PASSWORD@$IP:$PORT/h264Preview_01_main \
       -c copy \
       -map 0 \
       -reset_timestamps 1 \
       -f segment \
       -segment_time $TIME \
       -strftime 1 \
       -segment_format mp4 \
       "$OUTPUT_PATH/%Y-%m-%d--%H-%M-%S--capture-%04d.mp4"
