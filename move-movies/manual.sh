#! /usr/bin/env bash
set -e

CUID=${CUID:-1000}
ORIGIN=${ORIGIN:-/origin}
DESTINY=${DESTINY:-/destiny}

function move-movies(){
    FILE_NAME=$1
    NAME="${FILE_NAME##*/}"
    NAME="${NAME%.*}"
    OUT_FILE=${DESTINY}/${NAME}.mp4
    echo "Converting ${FILE_NAME} to ${OUT_FILE}"

    # If file is an mp4
    if [[ ${FILE_NAME} == *.mp4 ]]; then
        ffmpeg -i "${FILE_NAME}" \
            -hide_banner -loglevel error \
            -fflags +bitexact \
            -map 0 \
            -metadata title= \
            -c:v copy -flags:v +bitexact \
            -c:a copy -flags:a +bitexact \
            -c:s copy \
            "${OUT_FILE}"
    fi

    # If file is an mkv, convert to mp4
    if [[ ${FILE_NAME} == *.mkv ]]; then
        ffmpeg -i "${FILE_NAME}" \
            -hide_banner -loglevel error \
            -map 0 \
            -metadata title= \
            -c:v libx264 \
            -c:a aac \
            -c:s mov_text \
            "${OUT_FILE}"
    fi

    chown ${CUID}:${CUID} "${OUT_FILE}"
}

export -f move-movies

find ${ORIGIN} -type f -exec bash -c 'move-movies "$0"' {} \;

# Rename _ to .
find ${DESTINY} -type f -exec prename -v 's/_/./g' {} +
# Rename spaces to .
find ${DESTINY} -type f -exec prename -v 's/ /./g' {} +
# Rename accents to normal characters
find ${DESTINY} -type f -exec prename -v 's/á/a/g' {} +
find ${DESTINY} -type f -exec prename -v 's/é/e/g' {} +
find ${DESTINY} -type f -exec prename -v 's/í/i/g' {} +
find ${DESTINY} -type f -exec prename -v 's/ó/o/g' {} +
find ${DESTINY} -type f -exec prename -v 's/ú/u/g' {} +
find ${DESTINY} -type f -exec prename -v 's/Á/A/g' {} +
find ${DESTINY} -type f -exec prename -v 's/É/E/g' {} +
find ${DESTINY} -type f -exec prename -v 's/Í/I/g' {} +
find ${DESTINY} -type f -exec prename -v 's/Ó/O/g' {} +
find ${DESTINY} -type f -exec prename -v 's/Ú/U/g' {} +
find ${DESTINY} -type f -exec prename -v 's/ñ/n/g' {} +
find ${DESTINY} -type f -exec prename -v 's/Ñ/N/g' {} +
# Remove other special characters
find ${DESTINY} -type f -exec prename -v 's#[^[:alnum:]./]##g' {} +
