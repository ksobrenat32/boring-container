#!/usr/bin/env bash
#
set -eo pipefail

# OriginalPWD
OPWD=$(pwd)

# Get actor of image from argument
ACTOR=$1

# Get the hash from argument
SHA=$2

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

    banner "Building Image : ${NAME} with SHA : ${SHA}"
    docker buildx build -f Containerfile --tag ghcr.io/${ACTOR}/${NAME}:latest .

    # Push latest tag and sha tag
    docker push ghcr.io/${ACTOR}/${NAME}:latest

    docker tag ghcr.io/${ACTOR}/${NAME}:latest ghcr.io/${ACTOR}/${NAME}:${SHA}
    docker push ghcr.io/${ACTOR}/${NAME}:${SHA}

    # If version file exists, tag and push the image with version
    if [ -f version ]; then
        docker tag ghcr.io/${ACTOR}/${NAME}:${SHA} ghcr.io/${ACTOR}/${NAME}:$(cat version)
        docker push ghcr.io/${ACTOR}/${NAME}:$(cat version)
    fi

    # Return to originalPWD
    cd ${OPWD}
done

banner "All builds and pushs were successful :)"
