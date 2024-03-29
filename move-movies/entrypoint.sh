#! /usr/bin/env bash
set -e

while inotifywait -qre close_write /origin
do
    sleep 60
    find /origin -type f ! -name "*.chunk*" -exec prename -v 's/_/./g' {} +
    find /origin -type f ! -name "*.chunk*" -exec prename -v 's/ /./g' {} +
    find /origin -type f ! -name "*.chunk*" -exec prename -v 's#[^[:alnum:]./]##g' {} +

    for file_name in $(ls --ignore='*.chunk*' /origin )
    do
        tmp_name="${file_name}.undone.mp4"
        mv "$file_name" "$tmp_name"

        ffmpeg -i "$tmp_name" -map_metadata -1 -fflags +bitexact -flags:v +bitexact -flags:a +bitexact -c:v copy -c:a copy -c:s copy -map 0 "$file_name"

        rm "$tmp_name"
        mv "$file_name" /destiny
    done
done
