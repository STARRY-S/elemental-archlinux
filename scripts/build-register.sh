#!/bin/bash

set -euo pipefail

cd $(dirname $0)/../

mkdir -p build && cd build

if [[ ! -e elemental-operator ]]; then
    echo "Cloning elemental-operator source code."
    git clone https://github.com/rancher/elemental-operator.git
else
    echo "elemental-operator source code already exists, checking updates."
    # cd elemental-operator
    # git restore .
    # git pull --rebase
    # cd ..
fi

cd elemental-operator
echo "Build register & support binary..."
make register
make support

echo '-------------------'
ls -al ./build/
echo '-------------------'

echo "Build Register: Done"
