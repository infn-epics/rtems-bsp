#!/bin/bash

# Download all sources for an RTEMS Source Builder build set, with retries.
#
# ftp.rtems.org intermittently resets connections. The RSB does not retry, and
# a truncated download stays in sources/ and fails its checksum on every later
# attempt. So we loop, removing any file the RSB reports as corrupt.
#
# usage (from rsb/rtems): rsb-download.sh <prefix> <build set> [attempts]

set -u -o pipefail

PREFIX=${1:?usage: $0 <prefix> <build set> [attempts]}
BSET=${2:?usage: $0 <prefix> <build set> [attempts]}
ATTEMPTS=${3:-5}

for attempt in $(seq 1 ${ATTEMPTS}); do
    echo "RSB source download attempt ${attempt}/${ATTEMPTS} for ${BSET}"
    if ../source-builder/sb-set-builder --source-only-download \
        --prefix=${PREFIX} ${BSET} 2>&1 | tee /tmp/rsb-download.log; then
        # the RSB can exit 0 after reporting errors, so check the log too
        if ! grep -q "^error:" /tmp/rsb-download.log; then
            exit 0
        fi
    fi
    # remove corrupt partial downloads so the next attempt fetches them again
    grep -o "checksum failure file: [^ ]*" /tmp/rsb-download.log |
        awk '{print $4}' | sort -u | while read -r f; do
            echo "removing corrupt download ${f}"
            rm -f "${f}"
        done
    sleep $((attempt * 10))
done

echo "RSB source download failed after ${ATTEMPTS} attempts"
exit 1
