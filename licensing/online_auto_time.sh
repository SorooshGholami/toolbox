#!/bin/bash
# Fetches the current time from a remote HTTP server's response headers
# (so it doesn't rely on trusting the local system clock) and checks it
# against an expiry date.
#
# Usage: LICENSE_EXPIRY="2026-12-31 00:00:00" ./online_auto_time.sh
#
# Fix applied vs. the original: date comparison now uses Unix epoch
# integers instead of bash string comparison on human-readable dates
# (which is not chronologically correct).

set -u

LICENSE_EXPIRY="${LICENSE_EXPIRY:-2099-01-01 00:00:00}"
expiry_epoch=$(date -d "$LICENSE_EXPIRY" +%s)

remote_date_header=$(curl -Is https://google.com | grep -i '^date:' | cut -d' ' -f2-)

if [[ -z "$remote_date_header" ]]; then
    echo "Could not reach time source — no network?"
    exit 1
fi

remote_epoch=$(date -d "$remote_date_header" +%s)

if (( remote_epoch > expiry_epoch )); then
    echo "Your app has expired."
    exit 1
fi

echo "License valid."
