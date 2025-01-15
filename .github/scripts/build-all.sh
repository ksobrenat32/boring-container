#!/usr/bin/env bash
#
set -eo pipefail

# OriginalPWD
OPWD=$(pwd)

# Get actor of image from argument
ACTOR=$1

# Function for banner on workflow logs

banner() {
    msg="# $* #"
    edge=$(echo "$msg" | sed 's/./#/g')
    echo
    echo "$edge"
    echo "$msg"
    echo "$edge"
    echo
}

# Indicate the build actor
#
banner "Starting build as: ${ACTOR}"

# For every directory in the repository
for IMAGE_DIR in */
do
    # Get directory name without trailing /
    IMAGE_DIR=${IMAGE_DIR%*/}

    if [[ ${IMAGE_DIR} == "archived" ]]; then
        continue
    fi

    cd ${IMAGE_DIR}

    if [ ! -f name ]; then
        NAME=${IMAGE_DIR}
    else
        NAME=$(cat name)
    fi

    if [ ! -f version ]; then
        VERSION="latest"
    else
        VERSION=$(cat version)
    fi

    banner "Building Image : ${NAME}:${VERSION}"
    docker buildx build -f Containerfile --tag ghcr.io/${ACTOR}/${NAME}:${VERSION} .

    banner "Pushing Image : ${NAME}:${VERSION}"
    docker push ghcr.io/${ACTOR}/${NAME}:${VERSION}

    # Return to originalPWD
    cd ${OPWD}
done

banner "All builds and pushs were successful :)"
