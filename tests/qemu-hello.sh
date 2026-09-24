#!/bin/bash

# Smoke test for the pc686 BSP: boot the RTEMS hello sample in qemu-system-i386
# using its multiboot loader (the same mechanism iPXE/GRUB use on real hardware)
#
# usage: tests/qemu-hello.sh <developer image tag>
# requires: docker (or podman) and qemu-system-i386 on the host

set -euo pipefail

IMAGE=${1:?usage: $0 <developer image tag>}
SAMPLE=/rtems6-pc686-legacy/kernel/build/i386/pc686/testsuites/samples/hello.exe

if ! docker version &>/dev/null; then docker=podman; else docker=docker; fi

workdir=$(mktemp -d)
trap 'rm -rf ${workdir}' EXIT

$docker run --rm --entrypoint cat ${IMAGE} ${SAMPLE} > ${workdir}/hello.exe

timeout 60 qemu-system-i386 -m 128 -no-reboot -nographic \
    -append "--video=off --console=/dev/com1" \
    -kernel ${workdir}/hello.exe | tee ${workdir}/console.log || true

grep -q "END OF TEST HELLO WORLD" ${workdir}/console.log
echo "pc686 hello sample booted OK"
