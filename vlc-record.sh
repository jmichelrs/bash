#! /bin/bash
WDIR="$HOME/.vlc.SPOOL"
TIMEOUT=7200

function delete(){
        test -f "$TMPFILE" && ( rm "$TMPFILE" && notify-send -t 1200 "Deletado \"$TITLE\" ..." ) || notify-send -t 1200 "NOT FOUND \"$WIN_NAME\""
}


if [ "$#" -ne 0 ]; then
        declare -f "$1" &> /dev/null && "$1"
        exit
fi

inotifywait -me create --format "%w/%f" "$WDIR" 2> /dev/null | while read TMPFILE; do
(
        GID=$( stat -c "%G" "$TMPFILE" )
        PID=$( sg "$GID" "lsof -wF p '$TMPFILE'" | grep p | sed 's/p//g' )
        WIN="$( cat -A "/proc/$PID/cmdline" |  sed 's/\^\@/ /g' | awk '{print $4}' )"
        MDIR="$WDIR/../$WIN_NAME"

        inotifywait -t"$TIMEOUT" -e close_write "$TMPFILE" &> /dev/null && (
                sleep 1
                notify-send -t 4000 -a DELETE:"env WIN_NAME='$WIN_NAME' TMPFILE='$TMPFILE' '$0' 'delete'" "Record" "Finalizada: $WIN_NAME"
                sleep 5.5
                if [ -f "$TMPFILE" ]; then
                        mkdir "$MDIR"
                        mv "$TMPFILE" "$MDIR/$( date  +"%Y.%m.%d_%H.%M.%S.ts" )"
                fi
        )
)&
done
