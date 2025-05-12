#! /bin/bash
RESOLUTION="$( xrandr | grep -o "[0-9]\{4\}x[0-9]\{4\}+"  | sed 's/+//g' )"

COMMAND="ffmpeg -framerate 20 -video_size $RESOLUTION  -f x11grab -r 20 -i :0.0+nomouse -f alsa -ac 2 -i pulse -pix_fmt yuv444p -preset ultrafast -crf 0 -threads 15"
SAVE_DIR="$HOME/.RECORDS"
ICON="/dev/null"


FILE="$( date +"%Y-%m-%d.%H.%M.%S.mp4" )"
NOTIFY='notify-send -a DELETE:"rm \"$FILE\"" -i "$ICON" "Screen Record" "Arquivo \"$FILE\" salvo"'


pkill --signal TERM -f "$( echo $COMMAND | sed 's/+/\\+/g' )" && exit

function rec(){
        $COMMAND "$FILE" &> /dev/null
        eval $NOTIFY
        sleep 5
}

cd "$SAVE_DIR"

rec
