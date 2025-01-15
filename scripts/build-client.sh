#!/bin/bash

set -euo pipefail

cd $(dirname $0)/../

mkdir -p build && cd build

if [[ ! -e elemental-toolkit ]]; then
    echo "Cloning elemental-toolkit source code."
    git clone https://github.com/rancher/elemental-toolkit.git
else
    echo "elemental-toolkit source code already exists, checking updates."
    # cd elemental-toolkit
    # git restore .
    # git pull --rebase
    # cd ..
fi

cd elemental-toolkit
echo "Build elemental-cli..."
CGO_ENABLED=0 make build-cli

echo '-------------------'
ls -al ./build/
echo '-------------------'

echo "Build elemental-cli: Done"
