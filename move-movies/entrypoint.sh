#! /usr/bin/env bash
set -e

CUID=${CUID:-1000}
ORIGIN=${ORIGIN:-/origin}
DESTINY=${DESTINY:-/destiny}

while inotifywait -qre close_write ${ORIGIN}
do
    sleep 10
    # Rename _ to .
    find ${ORIGIN} -type f ! -name "*.chunk*" -exec prename -v 's/_/./g' {} +
    # Rename spaces to .
    find ${ORIGIN} -type f ! -name "*.chunk*" -exec prename -v 's/ /./g' {} +
    # Rename accents to normal characters
    find ${ORIGIN} -type f ! -name "*.chunk*" -exec prename -v 's/á/a/g' {} +
    find ${ORIGIN} -type f ! -name "*.chunk*" -exec prename -v 's/é/e/g' {} +
    find ${ORIGIN} -type f ! -name "*.chunk*" -exec prename -v 's/í/i/g' {} +
    find ${ORIGIN} -type f ! -name "*.chunk*" -exec prename -v 's/ó/o/g' {} +
    find ${ORIGIN} -type f ! -name "*.chunk*" -exec prename -v 's/ú/u/g' {} +
    find ${ORIGIN} -type f ! -name "*.chunk*" -exec prename -v 's/Á/A/g' {} +
    find ${ORIGIN} -type f ! -name "*.chunk*" -exec prename -v 's/É/E/g' {} +
    find ${ORIGIN} -type f ! -name "*.chunk*" -exec prename -v 's/Í/I/g' {} +
    find ${ORIGIN} -type f ! -name "*.chunk*" -exec prename -v 's/Ó/O/g' {} +
    find ${ORIGIN} -type f ! -name "*.chunk*" -exec prename -v 's/Ú/U/g' {} +
    # Remove other special characters
    find ${ORIGIN} -type f ! -name "*.chunk*" -exec prename -v 's#[^[:alnum:]./]##g' {} +

    for FILE_NAME in $(ls --ignore='*.chunk*' ${ORIGIN} )
    do
        FILE_NAME="${ORIGIN}/${FILE_NAME}"
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

        chown ${CUID}:${CUID} ${OUT_FILE}
        rm ${FILE_NAME}
    done
done
