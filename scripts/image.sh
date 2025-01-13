#!/bin/bash

cd $(dirname $0)/../

set -euo pipefail

# REGISTRY is the mirrored private registry to build images
REGISTRY="${REGISTRY:-127.0.0.1:5000}"
# REPO is the built image repository
REPO="${REPO:-library}"
# TAG is the Elemental ArchLinux OS tag
TAG="${TAG:-latest}"

# Build OS
docker build \
    --build-arg BASE_OS=$BASE_OS \
    -f package/os/Dockerfile \
    -t $REGISTRY/$REPO/elemental-archlinux-os-container:$TAG \
    .

# Build ISO
docker build \
    -f package/iso/Dockerfile \
    -t $REGISTRY/$REPO/elemental-archlinux-iso-image:$TAG \
    .

# Build channel
docker build \
    -f package/channel/Dockerfile \
    -t $REGISTRY/$REPO/elemental-archlinux-channel:dev \
    .

docker push $REGISTRY/$REPO/elemental-archlinux-os-container:$TAG
docker push $REGISTRY/$REPO/elemental-archlinux-iso-image:$TAG
docker push $REGISTRY/$REPO/elemental-archlinux-channel:dev

echo "Done:"
echo $REGISTRY/$REPO/elemental-archlinux-os-container:$TAG
echo $REGISTRY/$REPO/elemental-archlinux-iso-image:$TAG
echo $REGISTRY/$REPO/elemental-archlinux-channel:dev
