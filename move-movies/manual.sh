#! /usr/bin/env bash
set -e

# Rename files not ending with chunk
prename 's/_/./g' !(*.chunk*)
prename 's/ /./g' !(*.chunk*)
prename 's/[^[:alnum:].]//g' !(*.chunk*)
prename 's/[^[:alnum:].]//g' !(*.chunk*)

for file_name in $(ls --ignore='*.chunk*' /origin )
do
    tmp_name="${file_name}.undone.mp4"
    mv "$file_name" "$tmp_name"
    ffmpeg -i "$tmp_name" -map_metadata -1 -fflags +bitexact -flags:v +bitexact -flags:a +bitexact -c:v copy -c:a copy -c:s copy -map 0 "$file_name"
    rm "$tmp_name"
    mv "$file_name" /destiny
done
