#!/bin/bash
# Compares this machine's DMI product UUID against an expected value —
# useful as a simple hardware-lock check for licensing a script/app to a
# specific machine.
#
# Usage: GIVEN_UUID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" ./get_hardware_id.sh
# If GIVEN_UUID is not set, you'll be prompted for it.

system_uuid=$(cat /sys/class/dmi/id/product_uuid 2>/dev/null)

if [[ -z "$system_uuid" ]]; then
    echo "Could not read system UUID (try running as root)."
    exit 1
fi

if [[ -z "$GIVEN_UUID" ]]; then
    read -p "Enter the expected hardware UUID: " GIVEN_UUID
fi

if [[ "$system_uuid" != "$GIVEN_UUID" ]]; then
    echo "Hardware ID does NOT match."
    exit 1
else
    echo "Hardware ID matches."
fi
