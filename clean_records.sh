PATH="tmp/"
MONTHES=1

while getopts p:m: flag
do
    case "${flag}" in
        p) PATH=${OPTARG};;
        m) MONTHES=${OPTARG};;
    esac
done


LAST_MONTH=$(date --date='-$MONTHES month' +'%Y-%m')
rm "$PATH$LAST_MONTH-"*
