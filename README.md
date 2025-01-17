# Elemental Custom Images - ArchLinux

Demo project to use [elemental-toolkit](https://rancher.github.io/elemental-toolkit/docs/) to build [ArchLinux](https://wiki.archlinux.org) Elemental OS.

References:
- [What is Elemental toolkit](https://rancher.github.io/elemental-toolkit/docs/)
- [How to build and use custom OS images](https://elemental.docs.rancher.com/custom-images)
- [Elemental Toolkit Examples](https://github.com/rancher/elemental-toolkit/tree/main/examples)
- [SL-Micro OS Dockerfiles](https://github.com/rancher/elemental/tree/main/.obs/dockerfile)

## Usage

> [!NOTE]
>
> This project is currently **Working In Progress**, use as your own risk.

```sh
#!/bin/bash

export REGISTRY="127.0.0.1:5000"
export REPO="library"
export TAG="latest"

make image
```

## Demo

> WIP

## LICENSE

Copyright 2025 STARRY-S

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.