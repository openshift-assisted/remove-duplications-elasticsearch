#!/usr/bin/env bash

set -xeuo pipefail

if command -v podman
then
    CONTAINER_CMD="podman"
else
    CONTAINER_CMD="docker"
fi

export CONTAINER_CMD
echo "Using ${CONTAINER_CMD} as container engine..."

export CONTAINER_BUILD_EXTRA_PARAMS=${CONTAINER_BUILD_EXTRA_PARAMS:-"--no-cache"}
export IMAGE=${IMAGE:-"quay.io/app-sre/remove-duplications-elasticsearch"}

# Tag with the current commit sha
IMAGE_TAG="$(git rev-parse --short=7 HEAD)"
export IMAGE_TAG

# Setup credentials to image registry
${CONTAINER_CMD} login -u="${QUAY_USER}" -p="${QUAY_TOKEN}" quay.io

# Build and push latest image
make build-image

IMAGE_COMMIT_SHA="${IMAGE}:${IMAGE_TAG}"
${CONTAINER_CMD} push "${IMAGE_COMMIT_SHA}"

# Tag the image as latest
LATEST_IMAGE="${IMAGE}:latest"
${CONTAINER_CMD} tag "${IMAGE_COMMIT_SHA}" "${LATEST_IMAGE}"
${CONTAINER_CMD} push "${IMAGE_COMMIT_SHA}"
