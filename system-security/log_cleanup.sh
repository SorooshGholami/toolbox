#!/bin/bash
# Truncates /var/log/messages.
#
# ⚠️ INTENDED USE: routine log rotation/cleanup on your own systems/homelab.
# This is NOT an anti-forensic / log-wiping tool for covering unauthorized
# access — using it that way on a system you don't own or administer is
# illegal in most jurisdictions.
#
# Requires: root privileges (or write access to /var/log).

log_file="/var/log/messages"

if [[ ! -w "$log_file" ]]; then
    echo "No write access to $log_file — run as root."
    exit 1
fi

: > "$log_file"
echo "Logs cleaned up: $log_file"
