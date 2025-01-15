ARG ELEMENTAL_OS_IMAGE
FROM ${ELEMENTAL_OS_IMAGE} AS os

COPY package/iso/manifest.yaml manifest.yaml
RUN elemental --debug --config-dir . build-iso -o /output -n "elemental-archlinux-dev" dir:/

FROM busybox:stable

COPY --from=os /output /elemental-iso
