#!/bin/bash

# Stop an all errors
set -e

# Extract Git information
SOURCE_BRANCH=$(git rev-parse --abbrev-ref HEAD)
SOURCE_COMMIT=$(git rev-parse --verify HEAD)

# Build Docker tagging
NAME=dumrauf/yt2ab
TAG=$(git describe --always)
IMG=${NAME}:${TAG}
LATEST=${NAME}:latest

# Build and tag the container
docker build --build-arg SOURCE_BRANCH=${SOURCE_BRANCH} \
             --build-arg SOURCE_COMMIT="${SOURCE_COMMIT}" \
             -t "${IMG}" \
             .
docker tag "${IMG}" "${LATEST}"
