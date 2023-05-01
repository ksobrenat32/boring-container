#! /usr/bin/env bash
set -e

for file in $(ls --ignore='*.chunk*' --ignore='*.undone.mp4' /origin )
do
    prename 's/_/./g' *
    prename 's/ /./g' *
    prename 's/[^[:alnum:].]//g' *
done
for file_name in $(ls --ignore='*.chunk*' --ignore='*.undone.mp4' /origin )
do
    tmp_name="${file_name}.undone.mp4"
    mv "$file_name" "$tmp_name"
    ffmpeg -i "'$tmp_name'" -map_metadata -1 -fflags +bitexact -flags:v +bitexact -flags:a +bitexact -c:v copy -c:a copy -c:s copy -map 0 "'$file_name'"
    rm "$tmp_name"
    mv "$file_name" /destiny
done
