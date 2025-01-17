ARG ELEMENTAL_OS_IMAGE
FROM ${ELEMENTAL_OS_IMAGE} AS os
FROM ${ELEMENTAL_OS_IMAGE} AS builder

WORKDIR /iso

COPY package/iso/manifest.yaml manifest.yaml
COPY --from=os / rootfs

RUN elemental --debug --config-dir . build-iso -o /output -n "elemental-archlinux-dev"  dir:rootfs

FROM archlinux

RUN pacman -Syy --noconfirm && \
    pacman -S --noconfirm busybox

COPY --from=builder /output /elemental-iso
