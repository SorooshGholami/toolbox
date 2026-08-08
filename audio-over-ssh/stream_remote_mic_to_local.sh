#!/bin/bash
# Streams a remote host's microphone input to this machine's speakers over SSH.
#
# Usage: ./stream_remote_mic_to_local.sh <user@remote_host>
# Requires: arecord, aplay, ssh (with key-based access to the remote host)

remote="$1"

if [[ -z "$remote" ]]; then
    echo "Usage: $0 <user@remote_host>"
    exit 1
fi

ssh "$remote" arecord - | aplay -
