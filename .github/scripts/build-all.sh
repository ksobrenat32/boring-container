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
    cd ${IMAGE_DIR}

    banner "Building Image : ${IMAGE_DIR}"
    podman build . --tag ghcr.io/${ACTOR}/${IMAGE_DIR}:latest

    banner "Pushing Image : ${IMAGE_DIR}"
    podman push ghcr.io/${ACTOR}/${IMAGE_DIR}:latest

    # Return to originalPWD
    cd ${OPWD}
done

banner "All builds and pushs were successful :)"
