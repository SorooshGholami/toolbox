#!/bin/bash
# Encrypts a local timestamp file and periodically re-validates it against
# an expiry date + the system clock — a lightweight offline "time-lock"
# mechanism (detects both expiry and clock-rollback tampering).
#
# Usage:
#   LICENSE_KEY="your-passphrase" LICENSE_EXPIRY="2026-12-31 00:00:00" ./offline_time_license.sh
#
# ⚠️ SECURITY NOTE: publishing this script's source on a public repo means
# the *mechanism* is public. Even with LICENSE_KEY kept out of the code,
# anyone can read the logic, supply their own key, and re-encrypt a forged
# timestamp file. This is a deterrent against casual tampering, not real
# DRM — for anything that actually matters, validate server-side or use a
# signed license file instead.
#
# Fixes applied vs. the original version:
#   - Date comparisons now use Unix epoch integers instead of bash string
#     comparison on human-readable dates (which is not chronologically
#     correct, e.g. "Apr" sorts before "Jan" alphabetically).
#   - The main loop now sleeps between checks instead of busy-polling
#     the CPU at 100%.
#   - The encryption passphrase is no longer hardcoded in the script.

set -u

LICENSE_EXPIRY="${LICENSE_EXPIRY:-2099-01-01 00:00:00}"
LICENSE_KEY="${LICENSE_KEY:?Set the LICENSE_KEY environment variable to your encryption passphrase}"
STATE_FILE="license_state.txt"
STATE_ENC="${STATE_FILE}.enc"

expiry_epoch=$(date -d "$LICENSE_EXPIRY" +%s)

date +%s > "$STATE_FILE"
openssl enc -aes-256-cbc -pbkdf2 -iter 20000 -in "$STATE_FILE" -out "$STATE_ENC" -k "$LICENSE_KEY"
rm "$STATE_FILE"

while true; do
    minute=$(date +%M)

    # Run the check on every 5-minute mark (strip leading zero so bash
    # doesn't try to interpret e.g. "08" as an invalid octal literal).
    if (( 10#$minute % 5 == 0 )); then
        if [[ -s "$STATE_ENC" ]]; then
            openssl enc -d -aes-256-cbc -pbkdf2 -iter 20000 -in "$STATE_ENC" -out "$STATE_FILE" -k "$LICENSE_KEY"
            stored_epoch=$(cat "$STATE_FILE" 2>/dev/null)
            now_epoch=$(date +%s)

            if [[ "$stored_epoch" =~ ^[0-9]+$ ]] \
                && (( stored_epoch < expiry_epoch )) \
                && (( now_epoch > stored_epoch )); then

                echo "$now_epoch" > "$STATE_FILE"
                openssl enc -aes-256-cbc -pbkdf2 -iter 20000 -in "$STATE_FILE" -out "$STATE_ENC" -k "$LICENSE_KEY"
                rm "$STATE_FILE"
            else
                rm -f "$STATE_FILE"
                echo "License expired, or clock tampering detected."
                exit 1
            fi
        else
            echo "State file not found or empty."
            exit 1
        fi
    fi

    sleep 30
done
