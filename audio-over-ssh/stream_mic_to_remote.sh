#!/bin/bash
# Streams this machine's microphone input to a remote host's speakers over SSH.
#
# Usage: ./stream_mic_to_remote.sh <user@remote_host>
# Requires: arecord, aplay, ssh (with key-based access to the remote host)

remote="$1"

if [[ -z "$remote" ]]; then
    echo "Usage: $0 <user@remote_host>"
    exit 1
fi

arecord -f dat | ssh -C "$remote" aplay -f dat
