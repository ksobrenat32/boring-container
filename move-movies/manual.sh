#! /usr/bin/env bash
set -e

for file in $(ls --ignore='*.chunk*' --ignore='*.undone.mp4' /origin )
do
    prename 's/_/./g' *
    prename 's/ /./g' *
    prename 's/[^[:alnum:].]//g' *
done
for file in $(ls --ignore='*.chunk*' --ignore='*.undone.mp4' /origin )
do
    tmp_name="${file}.undone.mp4"
    mv "$file" "$tmp_name"
    ffmpeg -i "$tmp_name" -metadata title='' -fflags +bitexact -flags:v +bitexact -flags:a +bitexact -c:v copy -c:a copy -c:s copy -map 0 "$file"
    rm "$tmp_name"
    mv "$file" /destiny
done
