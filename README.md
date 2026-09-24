RTEMS Board Support Packages
============================

A container that makes the RTEMS Board Support Packages (BSPs).

This container gets the sources from RTEMS releases, builds the toolchain and then compiles the BSP.

The developer target serves as an archive for the source code. The runtime target is a minimal container with the RTEMS BSP only, intended to be used as a base image for epics-base builds (see https://github.com/epics-containers/epics-base)

Supported BSPs
--------------

The repo is designed to allow for multiple target architectures. Supported BSPs:

- mvme5500
  - rtems version: 6.1 RELEASE
  - patches for MVME5500 boards used at DLS
  - legacy network stack
  - processor is m4700 with hardware floating point support
  - patch to gcc source to only compile for the single powerpc variant

- pc686 (Dockerfile.pc686)
  - rtems version: 6.1 RELEASE
  - target: x86 VME single board computers, e.g. VMIC/Abaco VMIVME-7750
    (Pentium III, Tundra Universe II, Intel 82559 NIC via the fxp driver)
  - legacy network stack, POSIX API, COM1 console by default
  - multiboot image: boots via iPXE/GRUB on hardware, or `qemu-system-i386 -kernel`
  - smoke test: `tests/qemu-hello.sh <developer image>`
  - NOTE: VME (Universe II) support is not yet part of the RTEMS pc686 BSP


Acknowledgements
================

This is all possible due to the hard work of the RTEMS community.

See https://docs.rtems.org/branches/master/user/start/index.html
