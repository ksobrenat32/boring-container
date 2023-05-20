#! /usr/bin/env bash
set -e

while inotifywait -qre close_write /origin
do
    sleep 20
    prename 's/_/./g' *
    prename 's/ /./g' *
    prename 's/[^[:alnum:].]//g' *

    for file_name in $(ls --ignore='*.chunk*' /origin )
    do
        tmp_name="${file_name}.undone.mp4"
        mv "$file_name" "$tmp_name"

        ffmpeg -i "'$tmp_name'" -map_metadata -1 -fflags +bitexact -flags:v +bitexact -flags:a +bitexact -c:v copy -c:a copy -c:s copy -map 0 "'$file_name'"

        rm "$tmp_name"
        mv "$file_name" /destiny
    done
done
