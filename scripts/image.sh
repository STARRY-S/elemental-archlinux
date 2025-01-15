#!/bin/bash

cd $(dirname $0)/../

set -euo pipefail

# REGISTRY is the mirrored private registry to build images
REGISTRY="${REGISTRY:-127.0.0.1:5000}"
# REPO is the built image repository
REPO="${REPO:-library}"
# TAG is the Elemental ArchLinux OS tag
TAG="${TAG:-latest}"
ELEMENTAL_TOOLKIT=${ELEMENTAL_TOOLKIT:-"ghcr.io/rancher/elemental-toolkit/elemental-cli:v2.2.1"}
# RancherSystemAgent Version
RANCHER_SYSTEM_AGENT_VERSION=${RANCHER_SYSTEM_AGENT_VERSION:-'v0.3.11'}

# Build elemental cli binary file.
./scripts/build-client.sh
# Build elemental-register & elemental-support binary file.
./scripts/build-register.sh

# Build OS
echo "Start build $REGISTRY/$REPO/elemental-archlinux-os-container:$TAG"
docker build \
    -f package/os/Dockerfile \
    --build-arg ELEMENTAL_TOOLKIT=${ELEMENTAL_TOOLKIT} \
    --build-arg RANCHER_SYSTEM_AGENT_VERSION=${RANCHER_SYSTEM_AGENT_VERSION} \
    -t $REGISTRY/$REPO/elemental-archlinux-os-container:$TAG \
    .

# Build ISO
echo "Start build $REGISTRY/$REPO/elemental-archlinux-iso-image:$TAG"
docker build \
    -f package/iso/Dockerfile \
    --build-arg ELEMENTAL_OS_IMAGE=$REGISTRY/$REPO/elemental-archlinux-os-container:$TAG \
    -t $REGISTRY/$REPO/elemental-archlinux-iso-image:$TAG \
    .

# Build channel
echo "Start build STRY/$REPO/elemental-archlinux-channel:dev"
cp package/channel/channel.template.json package/channel/channel.json
sed -i -e 's/%REGISTRY%/'$REGISTRY'/g' \
    -e 's/%REPO%/'$REPO'/g' \
    -e 's/%TAG%/'$TAG'/g' \
    package/channel/channel.json
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
